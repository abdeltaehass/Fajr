import 'package:url_launcher/url_launcher.dart';

/// Launch helpers for values that arrive from remote APIs (masjid website
/// and phone fields from Google Places). Kept in one place so every screen
/// shares the same guards and they can't drift apart.
class SafeLauncher {
  /// Opens [website] in the external browser, but only for real web URLs —
  /// never custom schemes (tel:, file:, other apps' deep links).
  static Future<void> openWebsite(String? website) async {
    if (website == null) return;
    final uri = Uri.tryParse(website);
    if (uri == null || !(uri.scheme == 'https' || uri.scheme == 'http')) {
      return;
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Dials [phone] after stripping everything except digits, +, *, # so a
  /// malformed API value can't smuggle a different scheme into the dialer.
  static Future<void> dial(String? phone) async {
    if (phone == null) return;
    final sanitized = phone.replaceAll(RegExp(r'[^0-9+*#]'), '');
    if (sanitized.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: sanitized);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
