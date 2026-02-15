import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/app_colors.dart';
import '../settings/app_settings.dart';
import '../settings/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            const SizedBox(height: 32),

            // Color Theme Section
            _SectionHeader(title: s.colorTheme),
            const SizedBox(height: 16),
            _ColorThemePicker(
              selected: settings.colorTheme,
              onChanged: settings.setColorTheme,
            ),
            const SizedBox(height: 32),

            // Seasonal Theme Section
            _SectionHeader(title: s.seasonalTheme),
            const SizedBox(height: 12),
            ...SeasonalTheme.values.map((season) => _SeasonalThemeTile(
                  season: season,
                  isSelected: settings.seasonalTheme == season,
                  onTap: () => settings.setSeasonalTheme(season),
                )),
            const SizedBox(height: 24),

            // Language Section
            _SectionHeader(title: s.language),
            const SizedBox(height: 12),
            ...AppLanguage.values.map((lang) => _LanguageTile(
                  language: lang,
                  isSelected: settings.language == lang,
                  onTap: () => settings.setLanguage(lang),
                )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        color: c.accentLight,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
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
                    color: isSelected ? c.accent : c.accentLight.withValues(alpha: 0.3),
                    width: isSelected ? 3 : 1.5,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: c.accent.withValues(alpha: 0.4), blurRadius: 8)]
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
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
            Icon(_icon, color: isSelected ? c.accent : c.accentLight, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _label(context),
                style: GoogleFonts.poppins(
                  color: isSelected ? c.accent : c.bodyText,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: c.accent, size: 20),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  String get _label {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'العربية — Arabic';
      case AppLanguage.french:
        return 'Français — French';
      case AppLanguage.turkish:
        return 'Türkçe — Turkish';
      case AppLanguage.urdu:
        return 'اردو — Urdu';
      case AppLanguage.malay:
        return 'Bahasa Melayu — Malay';
    }
  }

  String get _flag {
    switch (language) {
      case AppLanguage.english:
        return '🇬🇧';
      case AppLanguage.arabic:
        return '🇸🇦';
      case AppLanguage.french:
        return '🇫🇷';
      case AppLanguage.turkish:
        return '🇹🇷';
      case AppLanguage.urdu:
        return '🇵🇰';
      case AppLanguage.malay:
        return '🇲🇾';
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
            Text(_flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _label,
                style: GoogleFonts.poppins(
                  color: isSelected ? c.accent : c.bodyText,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: c.accent, size: 20),
          ],
        ),
      ),
    );
  }
}
