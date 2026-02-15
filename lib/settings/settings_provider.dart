import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'app_colors.dart';
import '../l10n/app_strings.dart';

class SettingsProvider extends InheritedWidget {
  final AppSettings settings;

  const SettingsProvider({
    super.key,
    required this.settings,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<SettingsProvider>();
    assert(provider != null, 'SettingsProvider not found in context');
    return provider!.settings;
  }

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) => true;
}

extension SettingsContext on BuildContext {
  AppSettings get settings => SettingsProvider.of(this);
  AppColors get colors => SettingsProvider.of(this).colors;
  AppStrings get strings => AppStrings.of(SettingsProvider.of(this).language);
}
