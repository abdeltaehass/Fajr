import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  QuranAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        final q = queue.value;
        if (index < q.length) mediaItem.add(q[index]);
      }
    });
  }

  Future<void> playSurah(
    List<String> urls,
    List<MediaItem> items, {
    int startIndex = 0,
  }) async {
    queue.add(items);
    final source = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
    );
    await _player.setAudioSource(source, initialIndex: startIndex);
    if (startIndex < items.length) mediaItem.add(items[startIndex]);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
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
      systemActions: const {MediaAction.seek},
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
