import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Reverse-geocodes coordinates into a "City, Country" label, or null if it
  /// can't be resolved (e.g. offline). Used to show users which location the
  /// prayer times and Qibla are based on.
  Future<String?> getLocationName(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final city = [p.locality, p.subAdministrativeArea, p.administrativeArea]
          .firstWhere(
        (v) => v != null && v.isNotEmpty,
        orElse: () => null,
      );
      final country = p.country;
      if (city != null && country != null && country.isNotEmpty) {
        return '$city, $country';
      }
      return city ?? (country?.isNotEmpty == true ? country : null);
    } catch (_) {
      return null;
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Location permission permanently denied. Please enable in Settings.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
}

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}
