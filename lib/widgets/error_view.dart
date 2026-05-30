import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_provider.dart';

/// Shared full-screen error state. Use whenever a screen can't render its
/// primary content — keeps the look consistent and never exposes raw
/// status codes or API responses to users.
class ErrorView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const ErrorView({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: c.accentLight),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: c.scaffold,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  retryLabel ?? context.strings.retry,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
