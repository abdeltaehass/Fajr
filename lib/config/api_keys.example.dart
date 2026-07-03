// Template for lib/config/api_keys.dart, which is gitignored on purpose so
// real keys never land in version control.
//
// Setup:
//   1. Copy this file to lib/config/api_keys.dart
//   2. Replace the placeholder with your Google Places API (New) key
//      (https://console.cloud.google.com/apis/credentials)
//   3. Restrict the key to your iOS bundle ID and the Places API (New)
//      before shipping — keys embedded in an app binary are extractable.
class ApiKeys {
  static const String googlePlaces = 'YOUR_GOOGLE_PLACES_API_KEY';
}
