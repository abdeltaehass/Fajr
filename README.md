# Manar

An all-in-one Islamic companion app built with Flutter. Accurate prayer times, Quran with audio, Qibla compass, Athkar, Islamic guides, Zakat calculator, streak tracker, and more — with a beautiful customisable UI.

## Features

### Prayer Times
- All 5 daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) plus Sunrise
- Live countdown to the next prayer
- Hijri and Gregorian date display
- GPS-based location detection with automatic refresh when location changes
- Pull-to-refresh forces a fresh GPS + API fetch
- **Offline mode**: last successfully fetched prayer times are cached and displayed automatically when the API is unavailable
- Auto-retries on network or server failure

### Qibla Compass
- Live compass with smooth low-pass filtering
- Points toward the Kaaba in Mecca
- Shows the Qibla bearing in degrees from North
- Accuracy indicator (High / Medium / Low)
- Available offline using GPS (no internet required)

### Quran
- All 114 surahs with Arabic text and Sahih International translation
- Search surahs by English name, Arabic name, or meaning
- Meccan / Medinan badges and verse count per surah
- Toggle translation on/off per surah
- Long-press any verse to copy Arabic and translation to clipboard
- **Audio recitation** with 7 selectable reciters (choose in Settings)
  - Mishary Rashid Al-Afasy, Abdul Rahman Al-Sudais, Mahmoud Khalil Al-Husary, Mohamed Siddiq El-Minshawi, Abu Bakr Al-Shatri, Maher Al-Muaiqly, Muhammad Jibreel
  - Play a full surah from the AppBar
  - **Repeat mode**: loop the current surah continuously for memorisation
  - Tap the play icon on any verse to hear that verse individually
  - Sticky audio bar with play/pause/stop/repeat controls
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
- **Next button** to skip to the next dhikr without tapping the counter
- Arabic text with translations
- Progress tracking through each session

### Streak Tracker
- Create custom streaks with your own title (e.g. "Prayed Fajr", "Read Quran", "Fasted")
- Tap the checkmark each day to mark a streak complete
- Tracks current streak and all-time best streak
- Flame indicator goes orange when a streak is active
- Streak automatically resets if a day is missed
- Accessible from the Dashboard quick actions

### Islamic Guides
- **Salah Guide**: step-by-step prayer guide
- **Umrah Guide**: complete Umrah walkthrough
- **Hajj Guide**: full Hajj guide with all rites
- **Purity Guide**: Hayd and Ghusl rulings
- **Zakat Guide**: Zakat obligations with built-in Nisab calculator
- **Islamic Finance & Halal Investing Guide**: principles of Islamic finance, halal investment screens, Islamic financial contracts (Murabaha, Ijara, Mudaraba, Musharaka, Sukuk), and practical guidance for halal investing

### Islamic Calendar
- Monthly Gregorian calendar with Hijri date shown for every day
- Highlights Islamic events, recommended fasts, and Eid days
- Events include: Ashura, Mawlid, Isra & Mi'raj, Ramadan, Laylat al-Qadr, Eid al-Fitr, Arafah, Eid al-Adha, Ayyam al-Bidh, 6 days of Shawwal, and more
- Tap any highlighted day for a full description
- Today button to jump back to the current month

### Nearby Masjid Finder
- Find mosques near your location using Google Places API
- View address, phone number, website, opening hours, and ratings
- Get directions via Google Maps
- Set any masjid as "My Masjid" for quick access
- **Iqama times**: manually enter iqama times for each prayer with a time picker
- **Masjid events**: add custom events with title, date/time, and optional description

### Tasbeeh Counter
- Digital counter for dhikr
- Customisable target count

### 99 Names of Allah
- All 99 Names with Arabic, transliteration, and meaning

### Duas Collection
- Curated duas for daily occasions with Arabic and translation

### Notifications
- **Adhan notification**: alert at each prayer time
- **Pre-prayer reminder**: configurable minutes before each prayer
- Athkar reminders: morning, evening, after prayer, before sleep
- Permissions requested on first enable

### Widgets
- Home screen and lock screen widgets for prayer times

### Settings & Customisation
- **Prayer Calculation Method**: choose from 10 methods (ISNA, MWL, Egyptian, Umm Al-Qura, Karachi, Kuwait, Qatar, Turkey, Russia, Moonsighting)
- **Color Themes**: Green, Blue, Black, White, Pink, Yellow, Purple, Teal, Crimson, Orange, Brown
- **Seasonal Themes**: Normal, Ramadan, Eid, Hajj, Laylatul Qadr
- **Language Support**: English, Arabic, French, Turkish, Urdu, Malay, Indonesian, Bengali, Persian
- **Quran Reciter**: choose from 7 reciters
- RTL layout support for Arabic, Urdu, and Persian

## Getting Started

### Prerequisites
- Flutter SDK 3.11+
- A Google Places API key (for the Masjid finder)

### Setup

```bash
flutter pub get
```

For the Masjid finder, add your Google Places API key to `lib/config/api_keys.dart`:
```dart
static const String googlePlaces = 'YOUR_API_KEY_HERE';
```

Then run:
```bash
flutter run
```

## APIs

- **Prayer Calculation Method**: choose from 10 calculation methods (ISNA, MWL, Egyptian, Umm Al-Qura, Karachi, Kuwait, Qatar, Turkey, Russia, Moonsighting)

- **Prayer Times**: [Aladhan API](https://aladhan.com/prayer-times-api)
- **Nearby Masjids**: [Google Places API](https://developers.google.com/maps/documentation/places/web-service)
- **Quran Text**: [AlQuran Cloud API](https://alquran.cloud/api) — `quran-uthmani` + `en.sahih`
- **Quran Audio**: [Islamic Network CDN](https://cdn.islamic.network) — 7 reciters, 128 kbps
