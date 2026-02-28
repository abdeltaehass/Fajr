import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/adhan_sounds.dart';
import '../services/notification_service.dart';
import '../settings/app_colors.dart';
import '../settings/app_settings.dart';
import '../settings/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<bool> _requestNotifPermission(BuildContext context) async {
    final granted = await NotificationService.requestPermissions();
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.strings.notifPermDenied,
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: context.colors.card,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
    return granted;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final settings = context.settings;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                s.settings,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 24),

            // ── Notifications group ──────────────────────────────────
            _ExpandableGroup(
              title: s.notifications,
              icon: Icons.notifications_outlined,
              initiallyExpanded: true,
              children: [
                _SubLabel('Prayer Alerts'),
                const SizedBox(height: 8),
                _NotifToggleTile(
                  icon: Icons.notifications_active_outlined,
                  title: s.adhanNotification,
                  value: settings.adhanEnabled,
                  onChanged: (val) async {
                    if (val && !await _requestNotifPermission(context)) return;
                    settings.setAdhanEnabled(val);
                  },
                ),
                if (settings.adhanEnabled) ...[
                  const SizedBox(height: 8),
                  _NotifToggleTile(
                    icon: Icons.volume_up_outlined,
                    title: 'Adhan Sound',
                    value: settings.adhanSoundEnabled,
                    onChanged: (val) => settings.setAdhanSoundEnabled(val),
                  ),
                  if (settings.adhanSoundEnabled) ...[
                    const SizedBox(height: 8),
                    _AdhanSoundPicker(
                      selectedId: settings.adhanSoundId,
                      onChanged: (id) => settings.setAdhanSound(id),
                    ),
                  ],
                ],
                const SizedBox(height: 8),
                _NotifToggleTile(
                  icon: Icons.alarm_outlined,
                  title: 'Pre-Prayer Reminder  ·  ${settings.reminderMinutes} min',
                  value: settings.reminderEnabled,
                  onChanged: (val) async {
                    if (val && !await _requestNotifPermission(context)) return;
                    settings.setReminderEnabled(val);
                  },
                ),
                if (settings.reminderEnabled) ...[
                  const SizedBox(height: 8),
                  _StyledDropdown<int>(
                    value: settings.reminderMinutes,
                    items: [10, 20, 30]
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                '$m minutes before',
                                style: GoogleFonts.poppins(
                                  color: context.colors.accentLight,
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) settings.setReminderMinutes(val);
                    },
                  ),
                ],
                const SizedBox(height: 8),
                _NotifToggleTile(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Sunrise Notification  ·  الشروق',
                  value: settings.sunriseNotifEnabled,
                  onChanged: (val) async {
                    if (val && !await _requestNotifPermission(context)) return;
                    settings.setSunriseNotifEnabled(val);
                  },
                ),
                const SizedBox(height: 8),
                _NotifToggleTile(
                  icon: Icons.nights_stay_outlined,
                  title: 'Tahajjud Reminder  ·  1 hr before Fajr',
                  value: settings.tahajjudNotifEnabled,
                  onChanged: (val) async {
                    if (val && !await _requestNotifPermission(context)) return;
                    settings.setTahajjudNotifEnabled(val);
                  },
                ),
                const SizedBox(height: 16),
                _SubLabel(s.athkarReminders),
                const SizedBox(height: 8),
                ...[
                  ('morning',     Icons.wb_sunny_outlined, s.morningAthkar,     '6:00 AM'),
                  ('evening',     Icons.wb_twilight,        s.eveningAthkar,     '5:00 PM'),
                  ('afterPrayer', Icons.self_improvement,   s.afterPrayerAthkar, '1:30 PM'),
                  ('sleep',       Icons.bedtime_outlined,   s.sleepAthkar,       '10:00 PM'),
                ].map((entry) {
                  final (key, icon, title, time) = entry;
                  final isOn = settings.athkarNotifEnabled.contains(key);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _NotifToggleTile(
                      icon: icon,
                      title: '$title  ·  $time',
                      value: isOn,
                      onChanged: (val) async {
                        if (val && !await _requestNotifPermission(context)) return;
                        await settings.setAthkarNotifEnabled(key, val);
                        await NotificationService.scheduleAthkarNotifications(
                            settings.athkarNotifEnabled);
                      },
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),

            // ── Appearance group ─────────────────────────────────────
            _ExpandableGroup(
              title: s.colorTheme,
              icon: Icons.palette_outlined,
              initiallyExpanded: false,
              children: [
                _SubLabel(s.colorTheme),
                const SizedBox(height: 12),
                _ColorThemePicker(
                  selected: settings.colorTheme,
                  onChanged: settings.setColorTheme,
                ),
                const SizedBox(height: 16),
                _SubLabel(s.seasonalTheme),
                const SizedBox(height: 8),
                ...SeasonalTheme.values.map((season) => _SeasonalThemeTile(
                      season: season,
                      isSelected: settings.seasonalTheme == season,
                      onTap: () => settings.setSeasonalTheme(season),
                    )),
              ],
            ),
            const SizedBox(height: 12),

            // ── General group ────────────────────────────────────────
            _ExpandableGroup(
              title: 'General',
              icon: Icons.tune_outlined,
              initiallyExpanded: false,
              children: [
                _SubLabel(s.language),
                const SizedBox(height: 8),
                _LangDropdown(
                  value: settings.language,
                  onChanged: (lang) => settings.setLanguage(lang!),
                ),
                const SizedBox(height: 16),
                _SubLabel('Legal'),
                const SizedBox(height: 8),
                _LegalTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () async {
                    final uri = Uri.parse(
                        'https://abdeltaehass.github.io/Fajr/privacy-policy.html');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AdhanSoundPicker extends StatefulWidget {
  final String selectedId;
  final ValueChanged<String> onChanged;

  const _AdhanSoundPicker({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  State<_AdhanSoundPicker> createState() => _AdhanSoundPickerState();
}

class _AdhanSoundPickerState extends State<_AdhanSoundPicker> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
      return;
    }
    final sound = adhanSoundById(widget.selectedId);
    setState(() => _isPlaying = true);
    try {
      await _player.setAsset(sound.assetPath);
      await _player.play();
    } catch (_) {}
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(
          child: _StyledDropdown<String>(
            value: widget.selectedId,
            items: adhanSounds
                .map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        s.name,
                        style: GoogleFonts.poppins(
                          color: c.accentLight,
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                _player.stop();
                setState(() => _isPlaying = false);
                widget.onChanged(val);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isPlaying
                  ? c.accent.withValues(alpha: 0.2)
                  : c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPlaying ? c.accent : c.accent.withValues(alpha: 0.3),
                width: _isPlaying ? 1.5 : 1,
              ),
            ),
            child: Icon(
              _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              color: c.accent,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpandableGroup extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool initiallyExpanded;
  final List<Widget> children;

  const _ExpandableGroup({
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<_ExpandableGroup> createState() => _ExpandableGroupState();
}

class _ExpandableGroupState extends State<_ExpandableGroup> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded ? c.accent.withValues(alpha: 0.35) : c.accent.withValues(alpha: 0.12),
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(widget.icon, color: c.accent, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        color: c.accentLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: c.accentLight,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: c.accent.withValues(alpha: 0.12), height: 1),
                        const SizedBox(height: 12),
                        ...widget.children,
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SubLabel extends StatelessWidget {
  final String text;
  const _SubLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        color: c.accentLight.withValues(alpha: 0.6),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}


class _NotifToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final Future<void> Function(bool) onChanged;

  const _NotifToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: value ? c.surface.withValues(alpha: 0.4) : c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? c.accent : c.accent.withValues(alpha: 0.15),
          width: value ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? c.accent : c.accentLight, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: value ? c.accent : c.bodyText,
                fontSize: 14,
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: c.accent,
            activeTrackColor: c.accent.withValues(alpha: 0.3),
            inactiveThumbColor: textColor.withValues(alpha: 0.4),
            inactiveTrackColor: textColor.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

class _ColorThemePicker extends StatelessWidget {
  final ColorTheme selected;
  final ValueChanged<ColorTheme> onChanged;

  const _ColorThemePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ColorTheme.values.map((theme) {
        final isSelected = theme == selected;
        final palette = AppColorPalettes.forTheme(theme);
        return GestureDetector(
          onTap: () => onChanged(theme),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.scaffold,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? c.accent
                        : c.accentLight.withValues(alpha: 0.3),
                    width: isSelected ? 3 : 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: c.accent.withValues(alpha: 0.4),
                              blurRadius: 8)
                        ]
                      : [],
                ),
                child: isSelected
                    ? Icon(Icons.check, color: palette.accent, size: 20)
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                AppColorPalettes.themeName(theme),
                style: GoogleFonts.poppins(
                  color: isSelected ? c.accent : c.accentLight,
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SeasonalThemeTile extends StatelessWidget {
  final SeasonalTheme season;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeasonalThemeTile({
    required this.season,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (season) {
      case SeasonalTheme.normal:
        return Icons.brightness_5;
      case SeasonalTheme.ramadan:
        return Icons.nightlight_round;
      case SeasonalTheme.eid:
        return Icons.celebration;
      case SeasonalTheme.hajj:
        return Icons.terrain;
      case SeasonalTheme.laylatulQadr:
        return Icons.auto_awesome;
    }
  }

  String _label(BuildContext context) {
    final s = context.strings;
    switch (season) {
      case SeasonalTheme.normal:
        return s.normal;
      case SeasonalTheme.ramadan:
        return s.ramadan;
      case SeasonalTheme.eid:
        return s.eid;
      case SeasonalTheme.hajj:
        return s.hajj;
      case SeasonalTheme.laylatulQadr:
        return s.laylatulQadr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? c.surface.withValues(alpha: 0.4) : c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? c.accent : c.accent.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(_icon,
                color: isSelected ? c.accent : c.accentLight, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _label(context),
                style: GoogleFonts.poppins(
                  color: isSelected ? c.accent : c.bodyText,
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: c.accent, size: 20),
          ],
        ),
      ),
    );
  }
}

String _languageLabel(AppLanguage lang) {
  switch (lang) {
    case AppLanguage.english:    return '🇬🇧  English';
    case AppLanguage.arabic:     return '🇸🇦  العربية — Arabic';
    case AppLanguage.french:     return '🇫🇷  Français — French';
    case AppLanguage.turkish:    return '🇹🇷  Türkçe — Turkish';
    case AppLanguage.urdu:       return '🇵🇰  اردو — Urdu';
    case AppLanguage.malay:      return '🇲🇾  Bahasa Melayu — Malay';
    case AppLanguage.indonesian: return '🇮🇩  Bahasa Indonesia';
    case AppLanguage.bengali:    return '🇧🇩  বাংলা — Bengali';
    case AppLanguage.persian:    return '🇮🇷  فارسی — Persian';
  }
}

class _LangDropdown extends StatelessWidget {
  final AppLanguage value;
  final ValueChanged<AppLanguage?> onChanged;

  const _LangDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StyledDropdown<AppLanguage>(
      value: value,
      onChanged: onChanged,
      items: AppLanguage.values.map((lang) => DropdownMenuItem(
        value: lang,
        child: Text(
          _languageLabel(lang),
          style: GoogleFonts.poppins(color: c.bodyText, fontSize: 14),
        ),
      )).toList(),
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.accent.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: c.card,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.keyboard_arrow_down, color: c.accent),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LegalTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.accent.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: c.accentLight, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: c.bodyText,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.open_in_new, color: c.accentLight, size: 16),
          ],
        ),
      ),
    );
  }
}
