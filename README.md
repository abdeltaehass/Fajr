# Fajr

An Islamic prayer times app built with Flutter. Displays accurate salah times based on your location with a beautiful Islamic-themed UI, along with a Qibla compass, daily hadith, and morning/evening athkar.

## Features

### Prayer Times
- All 5 daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) plus Sunrise
- Live countdown to the next prayer
- Hijri and Gregorian date display
- GPS-based location detection
- Pull-to-refresh support

### Qibla Compass
- Live compass that rotates with your device
- Points toward the Kaaba in Mecca
- Shows the Qibla bearing in degrees from North
- Falls back to static bearing when compass sensor is unavailable

### Hadith of the Day
- Curated collection of 30 authentic hadiths
- Rotates daily with source and narrator attribution

### Morning & Evening Athkar
- Complete Athkar Al-Sabah (morning remembrances)
- Complete Athkar Al-Masa (evening remembrances)
- Tap-to-count interface with repetition tracking
- Arabic text with English translations
- Progress tracking through each session

### Navigation
- Bottom tab navigation between Prayer Times and Hadith & Athkar

## Getting Started

```bash
flutter pub get
flutter run
```

## API

Prayer times are fetched from the [Aladhan API](https://aladhan.com/prayer-times-api) using the ISNA calculation method.
