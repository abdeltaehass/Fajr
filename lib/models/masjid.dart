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
    final location = json['location'] as Map<String, dynamic>;
    final photos = json['photos'] as List<dynamic>? ?? [];

    return Masjid(
      placeId: json['id'] as String,
      name: (json['displayName']?['text'] as String?) ?? '',
      latitude: (location['latitude'] as num).toDouble(),
      longitude: (location['longitude'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['userRatingCount'] as int?,
      openNow: json['regularOpeningHours']?['openNow'] as bool?,
      photoReferences: photos.map((p) => p['name'] as String).toList(),
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

  Map<String, dynamic> toJson() => {
        'placeId': placeId,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': phoneNumber,
        'website': website,
        'rating': rating,
        'userRatingsTotal': userRatingsTotal,
        'openNow': openNow,
        'openingHours': openingHours,
        'photoReferences': photoReferences,
        'distanceKm': distanceKm,
      };

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['userRatingsTotal'] as int?,
      openNow: json['openNow'] as bool?,
      openingHours: (json['openingHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      photoReferences: (json['photoReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }
}
