import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/api_keys.dart';
import '../settings/settings_provider.dart';
import '../models/masjid.dart';
import '../models/prayer_times.dart';
import '../services/location_service.dart';
import '../services/masjid_service.dart';
import '../services/prayer_time_service.dart';
import '../widgets/crescent_decoration.dart';
import 'masjid_detail_screen.dart';

class MasjidScreen extends StatefulWidget {
  const MasjidScreen({super.key});

  @override
  State<MasjidScreen> createState() => _MasjidScreenState();
}

class _MasjidScreenState extends State<MasjidScreen> {
  final LocationService _locationService = LocationService();
  final MasjidService _masjidService = MasjidService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Masjid> _masjids = [];
  PrayerTimings? _myMasjidPrayerTimings;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadMasjids();
      _loadMyMasjidPrayerTimes();
    }
  }

  Future<void> _loadMasjids() async {
    if (ApiKeys.googlePlaces == 'YOUR_GOOGLE_PLACES_API_KEY') {
      setState(() {
        _isLoading = false;
        _errorMessage = context.strings.apiKeyMissing;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      final masjids = await _masjidService.searchNearbyMasjids(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _masjids = masjids;
        _isLoading = false;
      });
    } on LocationServiceException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } on MasjidServiceException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _loadMyMasjidPrayerTimes() async {
    final myMasjid = context.settings.selectedMasjid;
    if (myMasjid == null) return;
    try {
      final response = await _prayerTimeService.fetchPrayerTimes(
        latitude: myMasjid.latitude,
        longitude: myMasjid.longitude,
      );
      if (!mounted) return;
      setState(() {
        _myMasjidPrayerTimings = response.timings;
      });
    } catch (_) {
      // Supplementary data; fail silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    final c = context.colors;
    final s = context.strings;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CrescentMoon(size: 60, color: c.accent.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: c.accent),
          const SizedBox(height: 16),
          Text(
            s.searchingMasjids,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final c = context.colors;
    final s = context.strings;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque_outlined, size: 64, color: c.accentLight),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMasjids,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.scaffold,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                s.retry,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Masjid masjid) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MasjidDetailScreen(
          masjid: masjid,
          masjidService: _masjidService,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
      _loadMyMasjidPrayerTimes();
    }
  }

  Widget _buildContent() {
    final c = context.colors;
    final s = context.strings;
    final selectedMasjid = context.settings.selectedMasjid;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    if (_masjids.isEmpty && selectedMasjid == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque_outlined, size: 64, color: c.accentLight),
            const SizedBox(height: 16),
            Text(
              s.noMasjidsFound,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMasjids,
      color: c.accent,
      backgroundColor: c.card,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // My Masjid section
          if (selectedMasjid != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
              child: Row(
                children: [
                  Icon(Icons.star, color: c.accent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    s.myMasjid,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            _MyMasjidCard(
              masjid: selectedMasjid,
              masjidService: _masjidService,
              prayerTimings: _myMasjidPrayerTimings,
              onTap: () => _navigateToDetail(selectedMasjid),
            ),
            const SizedBox(height: 20),
          ],

          // Nearby header
          Padding(
            padding: EdgeInsets.fromLTRB(4, selectedMasjid != null ? 0 : 16, 4, 10),
            child: Row(
              children: [
                Icon(Icons.mosque, color: c.accent, size: 24),
                const SizedBox(width: 8),
                Text(
                  s.nearbyMasjids,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Nearby list
          ..._masjids.map((masjid) {
            final isSelected = selectedMasjid?.placeId == masjid.placeId;
            return _MasjidCard(
              masjid: masjid,
              masjidService: _masjidService,
              isSelected: isSelected,
              onTap: () => _navigateToDetail(masjid),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MyMasjidCard extends StatelessWidget {
  final Masjid masjid;
  final MasjidService masjidService;
  final PrayerTimings? prayerTimings;
  final VoidCallback onTap;

  const _MyMasjidCard({
    required this.masjid,
    required this.masjidService,
    this.prayerTimings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.accent.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: c.accent.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and photo
            if (masjid.photoReferences.isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.network(
                    masjidService.getPhotoUrl(
                      masjid.photoReferences.first,
                      maxWidth: 600,
                    ),
                    fit: BoxFit.cover,
                    cacheWidth: 600,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: child,
                      );
                    },
                    errorBuilder: (_, e, st) => Container(
                      color: c.surface,
                      child: Center(
                        child: Icon(Icons.mosque, size: 48,
                            color: c.accent.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          masjid.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 14, color: c.accent),
                            const SizedBox(width: 4),
                            Text(
                              s.myMasjid,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: c.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Address
                  if (masjid.address != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: textColor.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            masjid.address!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: textColor.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Opening hours
                  if (masjid.openingHours.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 14, color: c.accent),
                              const SizedBox(width: 6),
                              Text(
                                s.openingHours,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: c.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ...masjid.openingHours.take(3).map((hour) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  hour,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: textColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              )),
                          if (masjid.openingHours.length > 3)
                            Text(
                              '...',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: textColor.withValues(alpha: 0.4),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  // Prayer times
                  if (prayerTimings != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: c.accent),
                              const SizedBox(width: 6),
                              Text(
                                s.masjidPrayerTimes,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: c.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...prayerTimings!.dailyPrayers.map((prayer) =>
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(prayer.icon,
                                        size: 14, color: c.accent),
                                    const SizedBox(width: 8),
                                    Text(
                                      prayer.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: textColor
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      prayer.time,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: c.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Quick actions
                  Row(
                    children: [
                      if (masjid.distanceKm != null) ...[
                        Icon(Icons.near_me, size: 14, color: c.accentLight),
                        const SizedBox(width: 4),
                        Text(
                          '${masjid.distanceKm!.toStringAsFixed(1)} ${s.km}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: c.accentLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (masjid.rating != null) ...[
                        Icon(Icons.star, size: 14, color: c.accent),
                        const SizedBox(width: 2),
                        Text(
                          masjid.rating!.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: c.accent,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Quick action: directions
                      _QuickAction(
                        icon: Icons.directions,
                        color: c.accent,
                        onTap: () async {
                          final uri = Uri.parse(
                            'https://www.google.com/maps/dir/?api=1'
                            '&destination=${masjid.latitude},${masjid.longitude}'
                            '&destination_place_id=${masjid.placeId}',
                          );
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                      if (masjid.phoneNumber != null) ...[
                        const SizedBox(width: 8),
                        _QuickAction(
                          icon: Icons.phone,
                          color: Colors.green,
                          onTap: () async {
                            final uri =
                                Uri.parse('tel:${masjid.phoneNumber}');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                      ],
                      if (masjid.website != null) ...[
                        const SizedBox(width: 8),
                        _QuickAction(
                          icon: Icons.language,
                          color: Colors.blue,
                          onTap: () async {
                            final uri = Uri.parse(masjid.website!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _MasjidCard extends StatelessWidget {
  final Masjid masjid;
  final MasjidService masjidService;
  final bool isSelected;
  final VoidCallback onTap;

  const _MasjidCard({
    required this.masjid,
    required this.masjidService,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? c.accent.withValues(alpha: 0.4)
                : c.accent.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Mosque icon with checkmark overlay
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.mosque, color: c.accent, size: 28),
                  ),
                  if (isSelected)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: c.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 12, color: c.scaffold),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      masjid.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (masjid.address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        masjid.address!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textColor.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (masjid.distanceKm != null) ...[
                          Icon(Icons.near_me, size: 14, color: c.accentLight),
                          const SizedBox(width: 4),
                          Text(
                            '${masjid.distanceKm!.toStringAsFixed(1)} ${s.km}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: c.accentLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (masjid.openNow != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: masjid.openNow!
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : Colors.red.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              masjid.openNow! ? s.openNow : s.closed,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: masjid.openNow!
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (masjid.rating != null) ...[
                          Icon(Icons.star, size: 14, color: c.accent),
                          const SizedBox(width: 2),
                          Text(
                            masjid.rating!.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: c.accent,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: textColor.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
