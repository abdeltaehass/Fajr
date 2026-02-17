# Fajr

An Islamic prayer times app built with Flutter. Displays accurate salah times based on your location with a beautiful Islamic-themed UI, along with a Qibla compass, daily hadith, athkar, nearby masjid finder, and full customization.

## Features

### Prayer Times
- All 5 daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) plus Sunrise
- Live countdown to the next prayer
- Hijri and Gregorian date display
- GPS-based location detection
- Pull-to-refresh support

### Qibla Compass
- Live compass with smooth low-pass filtering
- Points toward the Kaaba in Mecca
- Shows the Qibla bearing in degrees from North
- Accuracy indicator (High / Medium / Low)

### Hadith of the Day
- Curated collection of 30 authentic hadiths
- Rotates daily with source and narrator attribution
- Tap for detailed explanation

### Daily Athkar
- Morning Athkar (Athkar Al-Sabah)
- Evening Athkar (Athkar Al-Masa)
- After Prayer Athkar (Athkar Ba'd As-Salah)
- Sleep Athkar (Athkar An-Nawm)
- Tap-to-count interface with repetition tracking
- Arabic text with translations
- Progress tracking through each session

### Nearby Masjid Finder
- Find mosques near your location using Google Places API
- View address, phone number, website, opening hours, and ratings
- Get directions via Google Maps
- Tap to call or visit the masjid's website
- Set any masjid as "My Masjid" for quick access
- Your selected masjid persists across app restarts

### Settings & Customization
- **Color Themes**: Green, Blue, Black, White, Pink, Yellow, Purple
- **Seasonal Themes**: Normal, Ramadan, Eid, Hajj, Laylatul Qadr
- **Language Support**: English, Arabic, French, Turkish, Urdu, Malay
- RTL layout support for Arabic and Urdu

### Navigation
- Bottom tab navigation: Prayer Times, Hadith & Athkar, Masjid, Settings

## Getting Started

### Prerequisites
- Flutter SDK 3.11+
- A Google Places API key (for the Masjid finder feature)

### Setup

```bash
flutter pub get
```

For the Masjid finder, add your Google Places API key:

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Enable the **Places API**
3. Create an API key
4. Add it to `lib/config/api_keys.dart`:
```dart
static const String googlePlaces = 'YOUR_API_KEY_HERE';
```

Then run:
```bash
flutter run
```

## APIs

- **Prayer Times**: [Aladhan API](https://aladhan.com/prayer-times-api) (ISNA calculation method)
- **Nearby Masjids**: [Google Places API](https://developers.google.com/maps/documentation/places/web-service)
