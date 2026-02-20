# Fajr

An Islamic prayer times app built with Flutter. Displays accurate salah times based on your location with a beautiful Islamic-themed UI, along with a Qibla compass, daily hadith, athkar, full Quran with audio recitation, nearby masjid finder, and full customization.

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

### Quran
- All 114 surahs with Arabic text and Sahih International translation
- Search surahs by English name, Arabic name, or meaning
- Meccan / Medinan badges and verse count per surah
- Bismillah header displayed automatically (except Al-Fatiha and At-Tawbah)
- Toggle translation on/off per surah
- Long-press any verse to copy Arabic and translation to clipboard
- **Audio recitation** with 7 selectable reciters (choose in Settings)
  - Mishary Rashid Al-Afasy, Abdul Rahman Al-Sudais, Mahmoud Khalil Al-Husary, Mohamed Siddiq El-Minshawi, Abu Bakr Al-Shatri, Maher Al-Muaiqly, Muhammad Jibreel
  - Play a full surah from the AppBar
  - Tap the play icon on any verse to hear that verse individually
  - Sticky audio bar with play/pause/stop controls and reciter name
  - Currently playing verse highlighted in the list

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
- **Iqama times**: manually enter iqama times for each prayer (Fajr, Dhuhr, Asr, Maghrib, Isha, Jumu'ah) with a time picker — saved persistently
- **Masjid events**: add custom events with title, date/time, and optional description; upcoming events sorted chronologically and persisted

### Notifications
- **Adhan notification**: receive an alert at each prayer time (toggleable)
- **30-min pre-prayer reminder**: get notified 30 minutes before each prayer (toggleable)
- Notifications are scheduled from your live prayer times each time you open the app
- Permissions requested on first enable; guidance shown if denied

### Settings & Customization
- **Color Themes**: Green, Blue, Black, White, Pink, Yellow, Purple
- **Seasonal Themes**: Normal, Ramadan, Eid, Hajj, Laylatul Qadr
- **Language Support**: English, Arabic, French, Turkish, Urdu, Malay
- **Quran Reciter**: choose from 7 reciters for audio playback
- RTL layout support for Arabic and Urdu

### Navigation
- Bottom tab navigation: Prayer Times, Quran, Hadith & Athkar, Masjid, Settings

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
- **Quran Text**: [AlQuran Cloud API](https://alquran.cloud/api) — `quran-uthmani` (Arabic) + `en.sahih` (Sahih International)
- **Quran Audio**: [Islamic Network CDN](https://cdn.islamic.network) — 7 reciters, 128 kbps
