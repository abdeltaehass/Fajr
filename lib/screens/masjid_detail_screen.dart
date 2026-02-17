import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settings/settings_provider.dart';
import '../models/masjid.dart';
import '../services/masjid_service.dart';

class MasjidDetailScreen extends StatefulWidget {
  final Masjid masjid;
  final MasjidService masjidService;

  const MasjidDetailScreen({
    super.key,
    required this.masjid,
    required this.masjidService,
  });

  @override
  State<MasjidDetailScreen> createState() => _MasjidDetailScreenState();
}

class _MasjidDetailScreenState extends State<MasjidDetailScreen> {
  late Masjid _masjid;
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    _masjid = widget.masjid;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final detailed = await widget.masjidService.getMasjidDetails(_masjid);
      if (!mounted) return;
      setState(() {
        _masjid = detailed;
        _isLoadingDetails = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${_masjid.latitude},${_masjid.longitude}'
      '&destination_place_id=${_masjid.placeId}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhone() async {
    if (_masjid.phoneNumber == null) return;
    final uri = Uri.parse('tel:${_masjid.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWebsite() async {
    if (_masjid.website == null) return;
    final uri = Uri.parse(_masjid.website!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool get _isSelected =>
      context.settings.selectedMasjid?.placeId == _masjid.placeId;

  Widget _buildMyMasjidButton(dynamic c, dynamic s, Color textColor) {
    if (_isSelected) {
      return GestureDetector(
        onTap: () {
          context.settings.clearSelectedMasjid();
          setState(() {});
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: c.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                s.myMasjid,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '—',
                style: GoogleFonts.poppins(color: c.accent),
              ),
              const SizedBox(width: 4),
              Text(
                s.removeMyMasjid,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: c.accent.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        context.settings.setSelectedMasjid(_masjid);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_masjid.name} — ${s.myMasjidSet}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: c.card,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque, color: c.scaffold, size: 20),
            const SizedBox(width: 8),
            Text(
              s.setAsMyMasjid,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.scaffold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Scaffold(
      backgroundColor: c.scaffold,
      body: CustomScrollView(
        slivers: [
          // App bar with photo
          SliverAppBar(
            expandedHeight: _masjid.photoReferences.isNotEmpty ? 220 : 120,
            pinned: true,
            backgroundColor: c.card,
            foregroundColor: textColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _masjid.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: _masjid.photoReferences.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.masjidService.getPhotoUrl(
                            _masjid.photoReferences.first,
                            maxWidth: 800,
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, st) => Container(
                            color: c.surface,
                            child: Icon(
                              Icons.mosque,
                              size: 64,
                              color: c.accent.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        // Gradient overlay for text readability
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                c.card.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: c.surface,
                      child: Icon(
                        Icons.mosque,
                        size: 64,
                        color: c.accent.withValues(alpha: 0.3),
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and status row
                  Row(
                    children: [
                      if (_masjid.rating != null) ...[
                        Icon(Icons.star, color: c.accent, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          _masjid.rating!.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: c.accent,
                          ),
                        ),
                        if (_masjid.userRatingsTotal != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${_masjid.userRatingsTotal})',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                        const SizedBox(width: 16),
                      ],
                      if (_masjid.openNow != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _masjid.openNow!
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _masjid.openNow! ? s.openNow : s.closed,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  _masjid.openNow! ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      if (_masjid.distanceKm != null) ...[
                        const Spacer(),
                        Icon(Icons.near_me, size: 16, color: c.accentLight),
                        const SizedBox(width: 4),
                        Text(
                          '${_masjid.distanceKm!.toStringAsFixed(1)} ${s.km}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: c.accentLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.directions,
                          label: s.getDirections,
                          color: c.accent,
                          onTap: _openMaps,
                        ),
                      ),
                      if (_masjid.phoneNumber != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.phone,
                            label: s.call,
                            color: Colors.green,
                            onTap: _callPhone,
                          ),
                        ),
                      ],
                      if (_masjid.website != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.language,
                            label: s.websiteLabel,
                            color: Colors.blue,
                            onTap: _openWebsite,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Set as My Masjid button
                  _buildMyMasjidButton(c, s, textColor),
                  const SizedBox(height: 24),

                  // Address
                  if (_masjid.address != null) ...[
                    _DetailSection(
                      icon: Icons.location_on,
                      title: s.distance,
                      child: Text(
                        _masjid.address!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Phone
                  if (_masjid.phoneNumber != null) ...[
                    _DetailSection(
                      icon: Icons.phone,
                      title: s.call,
                      child: GestureDetector(
                        onTap: _callPhone,
                        child: Text(
                          _masjid.phoneNumber!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: c.accent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Website
                  if (_masjid.website != null) ...[
                    _DetailSection(
                      icon: Icons.language,
                      title: s.websiteLabel,
                      child: GestureDetector(
                        onTap: _openWebsite,
                        child: Text(
                          _masjid.website!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: c.accent,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Opening hours
                  if (_masjid.openingHours.isNotEmpty) ...[
                    _DetailSection(
                      icon: Icons.schedule,
                      title: s.openingHours,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _masjid.openingHours.map((hour) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              hour,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: textColor.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Loading indicator for details
                  if (_isLoadingDetails)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: c.accent,
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                  // No details message
                  if (!_isLoadingDetails &&
                      _masjid.phoneNumber == null &&
                      _masjid.website == null &&
                      _masjid.openingHours.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          s.noDetails,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: textColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.accent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
