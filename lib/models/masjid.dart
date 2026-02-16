class Masjid {
  final String placeId;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final String? website;
  final double? rating;
  final int? userRatingsTotal;
  final bool? openNow;
  final List<String> openingHours;
  final List<String> photoReferences;
  final double? distanceKm;

  Masjid({
    required this.placeId,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.website,
    this.rating,
    this.userRatingsTotal,
    this.openNow,
    this.openingHours = const [],
    this.photoReferences = const [],
    this.distanceKm,
  });

  factory Masjid.fromNearbySearch(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    final photos = json['photos'] as List<dynamic>? ?? [];

    return Masjid(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      address: json['vicinity'] as String?,
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lng'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      openNow: json['opening_hours']?['open_now'] as bool?,
      photoReferences: photos
          .map((p) => p['photo_reference'] as String)
          .toList(),
    );
  }

  Masjid copyWithDetails({
    String? phoneNumber,
    String? website,
    List<String>? openingHours,
    List<String>? photoReferences,
  }) {
    return Masjid(
      placeId: placeId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      rating: rating,
      userRatingsTotal: userRatingsTotal,
      openNow: openNow,
      openingHours: openingHours ?? this.openingHours,
      photoReferences: photoReferences ?? this.photoReferences,
      distanceKm: distanceKm,
    );
  }

  Masjid copyWithDistance(double km) {
    return Masjid(
      placeId: placeId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber,
      website: website,
      rating: rating,
      userRatingsTotal: userRatingsTotal,
      openNow: openNow,
      openingHours: openingHours,
      photoReferences: photoReferences,
      distanceKm: km,
    );
  }
}
