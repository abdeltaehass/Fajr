import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/api_keys.dart';
import '../settings/settings_provider.dart';
import '../models/masjid.dart';
import '../services/location_service.dart';
import '../services/masjid_service.dart';
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

  bool _isLoading = true;
  String? _errorMessage;
  List<Masjid> _masjids = [];

  @override
  void initState() {
    super.initState();
    _loadMasjids();
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

  Widget _buildContent() {
    final c = context.colors;
    final s = context.strings;

    if (_masjids.isEmpty) {
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Icon(Icons.mosque, color: c.accent, size: 28),
                const SizedBox(width: 10),
                Text(
                  s.nearbyMasjids,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: c.isLight ? c.scaffold : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _masjids.length,
              itemBuilder: (context, index) {
                return _MasjidCard(
                  masjid: _masjids[index],
                  masjidService: _masjidService,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MasjidCard extends StatelessWidget {
  final Masjid masjid;
  final MasjidService masjidService;

  const _MasjidCard({required this.masjid, required this.masjidService});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.strings;
    final textColor = c.isLight ? c.scaffold : Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MasjidDetailScreen(
              masjid: masjid,
              masjidService: masjidService,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.accent.withValues(alpha: 0.15)),
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
              // Mosque icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.mosque, color: c.accent, size: 28),
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
