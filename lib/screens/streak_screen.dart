import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/streak.dart';
import '../services/streak_service.dart';
import '../settings/app_colors.dart';
import '../settings/settings_provider.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  List<Streak> _streaks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final streaks = await StreakService.load();
    if (mounted) setState(() { _streaks = streaks; _loading = false; });
  }

  Future<void> _save() => StreakService.save(_streaks);

  void _toggle(Streak streak) {
    final wasDone = streak.isCompletedToday;
    setState(() {
      if (wasDone) {
        streak.unmarkToday();
      } else {
        streak.markToday();
      }
    });
    HapticFeedback.lightImpact();
    _save();
  }

  void _addStreak() {
    showDialog(
      context: context,
      builder: (_) => _AddStreakDialog(
        onAdd: (title) {
          final s = Streak(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
          );
          setState(() => _streaks.add(s));
          _save();
        },
      ),
    );
  }

  void _deleteStreak(Streak streak) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "${streak.title}"?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('This will remove the streak and all its progress.',
            style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _streaks.remove(streak));
              _save();
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text(
          'Streak Tracker',
          style: GoogleFonts.poppins(
            color: c.accent,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: c.accent),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _streaks.isEmpty
              ? _buildEmpty(c)
              : _buildList(c),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStreak,
        backgroundColor: c.accent,
        foregroundColor: c.scaffold,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmpty(AppColors c) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_outlined,
              size: 64, color: c.accent.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'No streaks yet',
            style: GoogleFonts.poppins(
              color: c.bodyText.withValues(alpha: 0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start tracking a habit',
            style: GoogleFonts.poppins(
              color: c.bodyText.withValues(alpha: 0.35),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(AppColors c) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _streaks.length,
      itemBuilder: (context, i) => _StreakCard(
        streak: _streaks[i],
        onToggle: () => _toggle(_streaks[i]),
        onDelete: () => _deleteStreak(_streaks[i]),
      ),
    );
  }
}

String _days(int n) => '$n day${n == 1 ? '' : 's'}';

String _streakSubtitle(int count, bool active, bool done) {
  if (count == 0) return 'Start your streak today';
  if (!active) return 'Streak broken — restart today';
  if (done) return 'Done for today!';
  return '${_days(count)} — keep it going!';
}

class _StreakCard extends StatelessWidget {
  final Streak streak;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _StreakCard({
    required this.streak,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = streak.isCompletedToday;
    final active = streak.isStreakActive;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done
              ? c.accent.withValues(alpha: 0.5)
              : c.accent.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Flame + streak count
            Column(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: active
                      ? const Color(0xFFFF6B35)
                      : c.bodyText.withValues(alpha: 0.25),
                  size: 28,
                ),
                const SizedBox(height: 2),
                Text(
                  '${streak.currentStreak}',
                  style: GoogleFonts.poppins(
                    color: active ? c.accent : c.bodyText.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Title + best streak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streak.title,
                    style: GoogleFonts.poppins(
                      color: c.bodyText,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _streakSubtitle(streak.currentStreak, active, done),
                    style: GoogleFonts.poppins(
                      color: c.bodyText.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  if (streak.longestStreak > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Best: ${_days(streak.longestStreak)}',
                      style: GoogleFonts.poppins(
                        color: c.accent.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Check button
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: done ? c.accent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done ? c.accent : c.bodyText.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: done
                    ? Icon(Icons.check, color: c.scaffold, size: 20)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            // Delete
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                color: c.bodyText.withValues(alpha: 0.25),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddStreakDialog extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const _AddStreakDialog({required this.onAdd});

  @override
  State<_AddStreakDialog> createState() => _AddStreakDialogState();
}

class _AddStreakDialogState extends State<_AddStreakDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    widget.onAdd(title);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'New Streak',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'e.g. Prayed Fajr, Read Quran...',
          hintStyle: GoogleFonts.poppins(fontSize: 13),
          border: const OutlineInputBorder(),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
