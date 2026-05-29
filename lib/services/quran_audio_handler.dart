import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  // Source-stuck watchdog — if an ayah never reaches the `ready` state.
  Timer? _stuckTimer;
  int _watchedIndex = -1;

  // Position-stuck watchdog state — if the player reports `playing` but the
  // playback position isn't actually advancing (the symptom users describe
  // as "freezes mid-ayah"). The timer itself runs for the lifetime of the
  // handler.
  Duration _lastPosition = Duration.zero;
  DateTime _lastPositionMove = DateTime.now();
  int? _lastSkippedIndex; // de-dupe so we don't skip the same ayah twice

  // Surahs at or below this length load eagerly. Eager loading avoids the
  // between-ayah loading gaps that show up as "freezes." Bumped to 120 so
  // most surahs (everything except the 6 longest) get pre-loaded — this
  // is what makes background playback survive iOS suspension, since the
  // player no longer needs to fetch anything mid-recitation.
  static const int _eagerLoadThreshold = 120;
  static const Duration _stuckTimeout = Duration(seconds: 5);
  static const Duration _positionStuckTimeout = Duration(seconds: 3);

  // If we paused due to an OS interruption (call, adhan, route change),
  // remember it so we can auto-resume when the interruption ends.
  bool _pausedByInterruption = false;

  QuranAudioHandler() {
    _player.playbackEventStream.listen(
      _broadcastState,
      onError: (Object e, StackTrace st) async {
        // Decode / network failures surface here. Skip to next so one bad
        // ayah doesn't freeze the surah.
        await _skipOnError();
      },
    );
    _player.processingStateStream.listen(_onProcessingStateChanged);
    _player.currentIndexStream.listen((index) {
      _watchedIndex = index ?? -1;
      _resetPositionWatchdog();
      _stuckTimer?.cancel();
      _scheduleStuckCheck();
      if (index != null) {
        final q = queue.value;
        if (index < q.length) {
          // Publish the new ayah's MediaItem. Duration is unknown at this
          // point — the durationStream listener will republish with
          // duration filled in once the ayah finishes loading.
          mediaItem.add(q[index]);
        }
      }
    });
    // When the player learns the current ayah's duration, republish the
    // MediaItem with the duration set so iOS shows a scrub bar on the lock
    // screen / Control Center.
    _player.durationStream.listen((duration) {
      if (duration == null) return;
      final current = mediaItem.value;
      if (current == null) return;
      if (current.duration == duration) return;
      mediaItem.add(current.copyWith(duration: duration));
    });
    _player.positionStream.listen((pos) {
      if (pos != _lastPosition) {
        _lastPosition = pos;
        _lastPositionMove = DateTime.now();
      }
    });
    Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!_player.playing) return;
      if (_player.processingState != ProcessingState.ready) return;
      final stuckFor = DateTime.now().difference(_lastPositionMove);
      if (stuckFor < _positionStuckTimeout) return;
      // Player is "playing" but position has been frozen for 3+ seconds.
      // Skip — but de-dupe so we don't loop on the same ayah.
      final idx = _player.currentIndex;
      if (idx != null && idx == _lastSkippedIndex) return;
      _lastSkippedIndex = idx;
      _lastPositionMove = DateTime.now();
      await _skipOnError();
    });

    _wireInterruptionHandling();
  }

  // Listens to AVAudioSession interruption events. Without this, when the
  // adhan / a phone call / a navigation prompt steals the audio session,
  // just_audio gets paused but never resumes — the player goes silent and
  // the user thinks "Quran stopped when I locked my phone."
  Future<void> _wireInterruptionHandling() async {
    final session = await AudioSession.instance;

    session.interruptionEventStream.listen((event) async {
      if (event.begin) {
        // Something is taking over the audio session.
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Brief lower-priority audio (e.g. a notification ping).
            // Just_audio handles ducking; nothing for us to do.
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_player.playing) {
              _pausedByInterruption = true;
              await _player.pause();
            }
            break;
        }
      } else {
        // Interruption over.
        switch (event.type) {
          case AudioInterruptionType.duck:
            break;
          case AudioInterruptionType.pause:
            if (_pausedByInterruption) {
              _pausedByInterruption = false;
              try {
                await _player.play();
              } catch (_) {}
            }
            break;
          case AudioInterruptionType.unknown:
            _pausedByInterruption = false;
            break;
        }
      }
    });

    // Headphones unplugged / route change to speakers — pause so Quran
    // recitation doesn't blast out of the phone speaker by accident.
    session.becomingNoisyEventStream.listen((_) async {
      if (_player.playing) {
        try {
          await _player.pause();
        } catch (_) {}
      }
    });
  }

  void _resetPositionWatchdog() {
    _lastPosition = Duration.zero;
    _lastPositionMove = DateTime.now();
    _lastSkippedIndex = null;
  }

  Future<void> playSurah(
    List<String> urls,
    List<MediaItem> items, {
    int startIndex = 0,
  }) async {
    try {
      await _player.stop();
    } catch (_) {}
    _stuckTimer?.cancel();
    _pausedByInterruption = false;
    queue.add(items);

    // Explicitly claim the audio session before playing. Without this,
    // iOS may quietly deactivate playback the next time the screen locks
    // because nothing has formally claimed the session for background use.
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
    } catch (_) {}

    final source = ConcatenatingAudioSource(
      // Eager prep on short/medium surahs — short = whole Juz Amma fits — kills
      // the between-ayah pauses users perceive as "freezes." Long surahs stay
      // lazy so we don't blast hundreds of parallel requests at the start.
      useLazyPreparation: urls.length > _eagerLoadThreshold,
      children: urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
    );
    try {
      await _player.setAudioSource(source, initialIndex: startIndex);
    } catch (_) {
      // Source-setup failure — try once more with a fresh queue so a stuck
      // initial ayah doesn't permanently block playback.
      if (startIndex + 1 < urls.length) {
        try {
          await _player.setAudioSource(source, initialIndex: startIndex + 1);
        } catch (_) {
          return;
        }
      } else {
        return;
      }
    }
    if (startIndex < items.length) mediaItem.add(items[startIndex]);
    await _player.play();
  }

  /// Called by UI on app resume. If we look like we silently died in the
  /// background (player not playing, but we still have a queue and aren't
  /// at the end), try to resume from where we were.
  Future<void> resumeIfStalled() async {
    if (_player.playing) return;
    if (queue.value.isEmpty) return;
    if (_player.processingState == ProcessingState.completed) return;
    if (_player.processingState == ProcessingState.idle) return;
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _player.play();
    } catch (_) {}
  }

  void _onProcessingStateChanged(ProcessingState state) {
    if (state == ProcessingState.ready || state == ProcessingState.completed) {
      _stuckTimer?.cancel();
      return;
    }
    if (_player.playing && state != ProcessingState.idle) {
      _scheduleStuckCheck();
    }
  }

  // Skip if the player stays in a non-ready state for this ayah past
  // _stuckTimeout. This catches both "source failed to load silently" and
  // "CDN file is so slow the user calls it a freeze."
  void _scheduleStuckCheck() {
    if (!_player.playing) return;
    _stuckTimer?.cancel();
    final idx = _watchedIndex;
    _stuckTimer = Timer(_stuckTimeout, () async {
      if (!_player.playing) return;
      if (_player.currentIndex != idx) return;
      final state = _player.processingState;
      if (state == ProcessingState.ready ||
          state == ProcessingState.completed) {
        return;
      }
      await _skipOnError();
    });
  }

  Future<void> _skipOnError() async {
    try {
      if (_player.hasNext) {
        await _player.seekToNext();
      } else {
        await _player.stop();
      }
    } catch (_) {}
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    _stuckTimer?.cancel();
    _resetPositionWatchdog();
    await _player.stop();
    mediaItem.add(null);
    queue.add([]);
    return super.stop();
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.hasPrevious) await _player.seekToPrevious();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  bool get isRepeating => _player.loopMode == LoopMode.all;

  Future<void> toggleRepeat() async {
    await _player.setLoopMode(isRepeating ? LoopMode.off : LoopMode.all);
  }

  @override
  Future<void> onNotificationDeleted() => stop();

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      // systemActions powers iOS's MPRemoteCommandCenter — without these
      // entries the lock-screen / Control Center buttons are inert.
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }
}
