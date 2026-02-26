class GuideStep {
  final String title;
  final String description;
  final String? arabic;
  final String? transliteration;
  final String? dua;
  final String? note;

  const GuideStep({
    required this.title,
    required this.description,
    this.arabic,
    this.transliteration,
    this.dua,
    this.note,
  });
}

class GuideSection {
  final String heading;
  final List<GuideStep> steps;

  const GuideSection({required this.heading, required this.steps});
}

// ─────────────────────────────────────────────────────────────
// UMRAH GUIDE
// ─────────────────────────────────────────────────────────────

const List<GuideSection> umrahGuide = [
  GuideSection(
    heading: 'Preparation',
    steps: [
      GuideStep(
        title: 'Ghusl & Cleanliness',
        description:
            'Perform a full body wash (ghusl) before entering the state of Ihram. Trim your nails, remove unwanted body hair, and apply itr (perfume) to your body — not to the Ihram garments themselves. Men wear two white unstitched sheets: the izar (lower) and rida\' (upper). Women wear any modest clothing that covers the entire body; there is no specific colour requirement.',
        note:
            'Perfume is prohibited on the Ihram garments but permissible on the body before entering Ihram.',
      ),
      GuideStep(
        title: 'Intention (Niyyah)',
        description:
            'Make the intention in your heart to perform Umrah for the sake of Allah alone. The intention may also be spoken aloud.',
        arabic: 'نَوَيْتُ الْعُمْرَةَ وَأَحْرَمْتُ بِهَا لِلَّهِ تَعَالَى',
        transliteration:
            'Nawaytu al-\'umrata wa-aḥramtu bihā lillāhi ta\'ālā.',
        dua: 'I intend to perform Umrah and have entered the state of Ihram for the sake of Allah.',
      ),
      GuideStep(
        title: 'Two Rak\'ahs Before Ihram',
        description:
            'Pray two rak\'ahs of sunnah prayer before entering Ihram — provided it is not a forbidden prayer time. Recite Surah al-Kafirun in the first rak\'ah and Surah al-Ikhlas in the second.',
        note:
            'Forbidden prayer times: after Fajr until sunrise, at the time of Zawal (midday), and after Asr until sunset.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Entering Ihram at the Miqat',
    steps: [
      GuideStep(
        title: 'The Miqat Boundaries',
        description:
            'You must enter the state of Ihram before crossing the Miqat — the sacred boundary points designated by the Prophet ﷺ.\n\n• Dhul Hulayfah (Abyar Ali): for pilgrims coming from Madinah\n• Al-Juhfah (near Rabigh): for pilgrims from Syria, Morocco, and Egypt\n• Qarn al-Manazil (Al-Sayl): for pilgrims from Najd and the east\n• Yalamlam (Sa\'diyah): for pilgrims from Yemen\n• Dhat Irq: for pilgrims from Iraq\n\nPassengers on aircraft are announced when approaching the Miqat — be in Ihram before this point.',
        note:
            'It is sinful to cross the Miqat without Ihram if you intend to enter Makkah for Hajj or Umrah. A fidyah (compensation) is required.',
      ),
      GuideStep(
        title: 'Talbiyah',
        description:
            'Once Ihram is entered, begin reciting the Talbiyah loudly (men) or quietly (women). Continue throughout the journey until you begin Tawaf.',
        arabic:
            'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
        transliteration:
            'Labbayk Allāhumma labbayk. Labbayk lā sharīka laka labbayk. Inna al-ḥamda wa-n-ni\'mata laka wa-l-mulk. Lā sharīka lak.',
        dua:
            'Here I am, O Allah, here I am. Here I am — You have no partner — here I am. Indeed all praise, blessings, and dominion belong to You. You have no partner.',
      ),
      GuideStep(
        title: 'Ihram Restrictions',
        description:
            'Once in Ihram, the following are prohibited:\n\n• Cutting hair or nails\n• Applying perfume or scented products\n• Hunting or harming animals\n• Sexual relations or intimate foreplay\n• Marriage contracts\n• Men: covering the head or wearing stitched garments\n• Women: wearing face veil (niqab) or gloves\n\nIf any restriction is violated, a fidyah (expiation) may be required.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Entering Masjid al-Haram',
    steps: [
      GuideStep(
        title: 'Entering the Masjid',
        description:
            'Enter with your right foot first, saying Bismillah and the masjid entry dua. When you first see the Kaaba, pause and make sincere dua — this is one of the most accepted moments for supplication.',
        arabic:
            'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: 'Allāhumma iftaḥ lī abwāba raḥmatik.',
        dua: 'O Allah, open for me the gates of Your mercy.',
        note:
            'Stop reciting the Talbiyah when you arrive at the Masjid and are about to begin Tawaf.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Tawaf al-Umrah',
    steps: [
      GuideStep(
        title: 'Starting Tawaf',
        description:
            'Tawaf consists of 7 circuits around the Kaaba, performed counter-clockwise (keeping the Kaaba on your left). Begin at the Black Stone (Hajar al-Aswad). Face the Black Stone, raise your right hand, and say the opening takbir. Kiss the Black Stone if you can reach it without harming others; otherwise touch it with your hand, or simply point to it and say the takbir.',
        arabic: 'بِسْمِ اللَّهِ، وَاللَّهُ أَكْبَرُ',
        transliteration: 'Bismillāh, wallāhu akbar.',
        dua: 'In the name of Allah, and Allah is the Greatest.',
      ),
      GuideStep(
        title: 'Idtiba and Raml (Men Only)',
        description:
            'Men performing Tawaf for the first time during Umrah should:\n\n• Idtiba: Uncover the right shoulder by passing the rida\' (upper sheet) under the right armpit and over the left shoulder. Maintain this for the entire Tawaf.\n\n• Raml: Walk briskly with short steps during the first three circuits only. Return to normal pace for circuits four through seven.',
        note:
            'Idtiba is only for Tawaf — cover the right shoulder again when praying the 2 rak\'ahs afterwards.',
      ),
      GuideStep(
        title: 'Yemeni Corner & the Dua Between Corners',
        description:
            'At the Yemeni Corner (Rukn al-Yamani), touch it with your right hand if possible. Between the Yemeni Corner and the Black Stone, recite this dua:',
        arabic:
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        transliteration:
            'Rabbanā ātinā fī d-dunyā ḥasanatan wa-fī l-ākhirati ḥasanatan wa-qinā \'adhāb an-nār.',
        dua:
            'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
        note:
            'There are no specific duas mandated for each circuit — make sincere personal dua throughout.',
      ),
      GuideStep(
        title: 'Completing 7 Circuits',
        description:
            'Complete all 7 circuits, ending each one at the Black Stone. With each passing of the Black Stone, face it, point to it, and say "Allahu Akbar." Make abundant dua, dhikr, and Quran recitation throughout Tawaf.',
        note:
            'If Tawaf is interrupted by an obligatory prayer, resume from where you left off after salah.',
      ),
    ],
  ),
  GuideSection(
    heading: 'After Tawaf',
    steps: [
      GuideStep(
        title: 'Two Rak\'ahs at Maqam Ibrahim',
        description:
            'After completing Tawaf, pray 2 rak\'ahs behind Maqam Ibrahim (the station of Ibrahim) if possible. Recite Surah al-Kafirun (Chapter 109) in the first rak\'ah and Surah al-Ikhlas (Chapter 112) in the second. If the area is crowded, you may pray anywhere in Masjid al-Haram.',
        arabic: 'وَاتَّخِذُوا مِنْ مَقَامِ إِبْرَاهِيمَ مُصَلًّى',
        dua:
            '"And take the station of Ibrahim as a place of prayer." — Quran 2:125',
      ),
      GuideStep(
        title: 'Drinking Zamzam',
        description:
            'Proceed to the Zamzam well and drink your fill, facing the Kaaba. Make dua while drinking. The Prophet ﷺ said: "The water of Zamzam is for whatever it is drunk for."',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ',
        transliteration:
            'Allāhumma innī as\'aluka \'ilman nāfi\'an wa-rizqan wāsi\'an wa-shifā\'an min kulli dā\'.',
        dua:
            'O Allah, I ask You for beneficial knowledge, abundant provision, and a cure from every illness.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Sa\'i between Safa and Marwa',
    steps: [
      GuideStep(
        title: 'Proceeding to Safa',
        description:
            'Walk to Mount Safa. As you approach, recite the following verse. This is said only on the first approach to Safa.',
        arabic:
            'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ',
        transliteration:
            'Inna aṣ-Ṣafā wa-l-Marwata min sha\'ā\'iri llāh.',
        dua:
            '"Indeed, Safa and Marwa are among the symbols of Allah." — Quran 2:158',
      ),
      GuideStep(
        title: 'Dua on Safa',
        description:
            'Ascend Safa until you can see the Kaaba (or face the direction of the Kaaba). Raise your hands and make dua. Say the following three times, making dua between each repetition:',
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ أَنْجَزَ وَعْدَهُ وَنَصَرَ عَبْدَهُ وَهَزَمَ الْأَحْزَابَ وَحْدَهُ',
        transliteration:
            'Lā ilāha illallāhu waḥdahu lā sharīka lah, lahu l-mulku wa-lahu l-ḥamdu wa-huwa \'alā kulli shay\'in qadīr. Lā ilāha illallāhu waḥdahu anjaza wa\'dahu wa-naṣara \'abdahu wa-hazama l-aḥzāba waḥdah.',
        dua:
            'There is no god but Allah alone, with no partner. To Him belongs all dominion and all praise, and He has power over all things. There is no god but Allah alone — He fulfilled His promise, gave victory to His servant, and defeated the confederates alone.',
      ),
      GuideStep(
        title: 'Walking to Marwa (7 Circuits)',
        description:
            'Walk from Safa to Marwa = 1 trip. Marwa to Safa = 1 trip. You need 7 trips total, ending at Marwa.\n\n• Trip 1: Safa → Marwa\n• Trip 2: Marwa → Safa\n• Trip 3: Safa → Marwa\n• Trip 4: Marwa → Safa\n• Trip 5: Safa → Marwa\n• Trip 6: Marwa → Safa\n• Trip 7: Safa → Marwa (end here)\n\nMen should jog briskly between the two green fluorescent markers (the area known as Batayn al-Masil). Make dua, dhikr, and Quran recitation throughout.\n\nUpon reaching Marwa, ascend it, face the Kaaba, and repeat the same dua as on Safa.',
        note:
            'Sa\'i does not require wudu, but it is recommended to be in a state of purity.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Completing Umrah',
    steps: [
      GuideStep(
        title: 'Tahallul — Shaving or Cutting Hair',
        description:
            'After Sa\'i, men should shave the entire head (Halq — preferred) or cut hair from all parts of the head (Taqsir — acceptable). Women cut a finger-tip length (approximately 2–3 cm) from the ends of their hair.\n\nShaving is superior to cutting for men, as the Prophet ﷺ made dua three times for those who shave and once for those who cut.',
        arabic: 'اللَّهُمَّ اغْفِرْ لِلْمُحَلِّقِينَ',
        dua:
            'O Allah, forgive those who shave their heads. (The Prophet ﷺ said this three times.)',
        note:
            'With Tahallul, all Ihram restrictions are lifted. Your Umrah is now complete — Alhamdulillah.',
      ),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────
// HAJJ GUIDE (Tamattu' — most common for non-residents)
// ─────────────────────────────────────────────────────────────

const List<GuideSection> hajjGuide = [
  GuideSection(
    heading: 'Overview',
    steps: [
      GuideStep(
        title: 'Types of Hajj',
        description:
            'There are three valid ways to perform Hajj:\n\n1. Tamattu\' (متمتع): Perform Umrah first during the Hajj months, exit Ihram, then re-enter Ihram specifically for Hajj on the 8th of Dhul Hijjah. A sacrificial animal (hady) is required. This is the most common method for pilgrims traveling from outside Saudi Arabia and was encouraged by the Prophet ﷺ.\n\n2. Ifrad (مفرد): Enter Ihram for Hajj only, without Umrah in the same journey. No hady is required.\n\n3. Qiran (قارن): Enter Ihram for both Hajj and Umrah simultaneously, without exiting Ihram between them. A hady is required.',
        note:
            'This guide covers Tamattu\'. The Umrah steps are performed first (see the Umrah guide), followed by the Hajj steps below.',
      ),
      GuideStep(
        title: 'The Five Pillars of Hajj',
        description:
            'These acts are obligatory pillars (arkan) — Hajj is invalid without them:\n\n1. Ihram with intention\n2. Wuquf at Arafat (standing at Arafat on the 9th of Dhul Hijjah)\n3. Tawaf al-Ifadah (the main Tawaf of Hajj)\n4. Sa\'i between Safa and Marwa\n5. Shaving or cutting hair (Tahallul)',
      ),
    ],
  ),
  GuideSection(
    heading: '8th Dhul Hijjah — Yawm al-Tarwiyah',
    steps: [
      GuideStep(
        title: 'Re-enter Ihram for Hajj',
        description:
            'After completing your Umrah and having been in a state of Tahalul (out of Ihram), you re-enter Ihram specifically for Hajj on the 8th of Dhul Hijjah. Perform ghusl, apply perfume to the body, wear the Ihram garments, and make the intention for Hajj.',
        arabic:
            'نَوَيْتُ الْحَجَّ وَأَحْرَمْتُ بِهِ لِلَّهِ تَعَالَى',
        transliteration:
            'Nawaytu l-ḥajja wa-aḥramtu bihi lillāhi ta\'ālā.',
        dua: 'I intend to perform Hajj and have entered Ihram for the sake of Allah.',
        note:
            'For Tamattu\', you enter Ihram from your accommodation in Makkah, not from the Miqat boundary.',
      ),
      GuideStep(
        title: 'Proceeding to Mina',
        description:
            'After making Ihram and the Fajr prayer, proceed to Mina. This day is called Yawm al-Tarwiyah (the Day of Watering) — historically, pilgrims would fill their water supplies here.\n\nPray Dhuhr, Asr, Maghrib, Isha (shortened to 2 rak\'ahs for Dhuhr, Asr, and Isha — not combined), and the Fajr of the 9th in Mina. Spend the day and night there.',
        note:
            'Staying in Mina on the 8th is a confirmed Sunnah, though not obligatory.',
      ),
    ],
  ),
  GuideSection(
    heading: '9th Dhul Hijjah — Yawm Arafah (The Heart of Hajj)',
    steps: [
      GuideStep(
        title: 'Moving to Arafat',
        description:
            'After the Fajr prayer in Mina, proceed to Arafat after sunrise. Arafat is a vast plain approximately 20 km east of Makkah. The Prophet ﷺ said: "Al-Hajj is Arafat." — Wuquf (standing) at Arafat is the single most important pillar of Hajj.',
        note:
            'Make sure you are within the boundaries of Arafat. Namirah Mosque straddles the boundary — only the part that is inside Arafat is valid. The entire plain of Arafat is a valid standing place; you do not have to be on Jabal al-Rahmah (Mount of Mercy) specifically.',
      ),
      GuideStep(
        title: 'Dhuhr & Asr — Combined and Shortened',
        description:
            'At the time of Dhuhr, pray Dhuhr and Asr together (Jam\' Taqdim — combined early), each shortened to 2 rak\'ahs, with one adhan and two iqamahs. This follows the Sunnah of the Prophet ﷺ on this day.',
      ),
      GuideStep(
        title: 'Wuquf — Standing at Arafat',
        description:
            'The Wuquf begins at Dhuhr time and continues until after sunset. This is the single greatest spiritual moment of Hajj. Spend it in:\n\n• Abundant dua — raise your hands and ask Allah for everything\n• Talbiyah\n• Istighfar (seeking forgiveness)\n• Salawat upon the Prophet ﷺ\n• Quran recitation\n• Dhikr\n\nThe Prophet ﷺ said: "The best supplication is the supplication on the Day of Arafah." (Tirmidhi)',
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'Lā ilāha illallāhu waḥdahu lā sharīka lah, lahu l-mulku wa-lahu l-ḥamdu wa-huwa \'alā kulli shay\'in qadīr.',
        dua:
            'There is no god but Allah alone, with no partner. To Him belongs dominion and praise, and He has power over all things.',
        note:
            'Wuquf lasts from Dhuhr until sunset. Missing Arafat entirely invalidates the Hajj.',
      ),
      GuideStep(
        title: 'Moving to Muzdalifah After Sunset',
        description:
            'After sunset, depart Arafat calmly and proceed to Muzdalifah. Do not rush or push. Pray Maghrib and Isha together (shortened) upon arriving in Muzdalifah. This is called Jam\' Ta\'khir (delayed combination).',
      ),
    ],
  ),
  GuideSection(
    heading: 'Night in Muzdalifah',
    steps: [
      GuideStep(
        title: 'Spending the Night',
        description:
            'Muzdalifah is the open valley between Arafat and Mina. The Prophet ﷺ spent the night here in prayer and remembrance.\n\nPray Fajr very early in Muzdalifah, then engage in dua and dhikr until just before sunrise.',
        note:
            'The elderly, sick, and women with children may leave Muzdalifah after midnight.',
      ),
      GuideStep(
        title: 'Collecting Pebbles',
        description:
            'Collect pebbles for the Rami (stoning of the Jamarat). You need a minimum of 49 pebbles — collect 70 to have spares.\n\nPebble size: approximately the size of a chickpea or hazelnut. They can be collected from Muzdalifah or Mina — not from the Jamarat basin itself.',
        note:
            'It is permissible to collect pebbles from Mina as well, not only Muzdalifah.',
      ),
    ],
  ),
  GuideSection(
    heading: '10th Dhul Hijjah — Yawm al-Nahr (Day of Sacrifice)',
    steps: [
      GuideStep(
        title: '1st Act: Rami of Jamrat al-Aqabah',
        description:
            'After leaving Muzdalifah, proceed to the Jamarat in Mina. On this day, throw 7 pebbles at the largest pillar only — Jamrat al-Aqabah (also called Jamrat al-Kubra). Say "Allahu Akbar" with each throw. Stop reciting the Talbiyah before throwing the first pebble.',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allāhu akbar.',
        dua: 'Allah is the Greatest. (Say this with each pebble throw.)',
        note:
            'The pebble must land within the basin. Throwing 7 pebbles at only this Jamarat suffices for today.',
      ),
      GuideStep(
        title: '2nd Act: Hady — Animal Sacrifice',
        description:
            'Slaughter a sacrificial animal. For Tamattu\', this is obligatory. Options:\n\n• Sheep or goat: sufficient for one person\n• Cow or camel: shared among 7 people\n\nThe sacrifice can be delegated to an authorized agent or performed through the official Hajj sacrifice coupons. The meat is distributed to the poor.',
        note:
            'The sequence on this day is: Rami → Sacrifice → Shave/Cut → Tawaf al-Ifadah. However, if the order is changed, it is acceptable with no penalty according to the hadith.',
      ),
      GuideStep(
        title: '3rd Act: Tahallul Awwal — First Release',
        description:
            'After Rami and Hady, shave the head (men — preferred) or cut the hair (women: a finger-tip length from the ends). With this, most Ihram restrictions are lifted:\n\n✅ Allowed: wearing normal clothes, perfume, trimming nails\n❌ Still prohibited: sexual relations with spouse (until Tahallul Thani)',
      ),
      GuideStep(
        title: '4th Act: Tawaf al-Ifadah',
        description:
            'Proceed to Masjid al-Haram and perform Tawaf al-Ifadah (also called Tawaf al-Ziyarah) — the main Tawaf of Hajj. This is a pillar (rukn); Hajj is invalid without it.\n\n7 circuits, counter-clockwise, the same as Tawaf of Umrah, but without Idtiba or Raml (brisk walking).',
      ),
      GuideStep(
        title: '5th Act: Sa\'i of Hajj',
        description:
            'After Tawaf al-Ifadah, perform Sa\'i between Safa and Marwa (7 circuits, starting at Safa and ending at Marwa) — the same as during Umrah.\n\nNote: If you performed Sa\'i after the Tawaf al-Qudum (arrival Tawaf) earlier in Hajj, you do not need to repeat Sa\'i now.',
      ),
      GuideStep(
        title: 'Tahallul Thani — Full Release',
        description:
            'After completing Tawaf al-Ifadah and Sa\'i, all Ihram restrictions are completely lifted — including sexual relations with the spouse. The state of full Tahallul has been achieved. Return to Mina.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Ayyam al-Tashreeq — 11th, 12th, 13th Dhul Hijjah',
    steps: [
      GuideStep(
        title: 'Staying in Mina',
        description:
            'You must spend the nights of the 11th and 12th of Dhul Hijjah in Mina. Pray all 5 daily prayers in Mina, shortened to 2 rak\'ahs (Qasr) — without combining.',
        note:
            'Spending the nights in Mina is obligatory (wajib). Missing it without a valid excuse requires a fidyah (sacrifice).',
      ),
      GuideStep(
        title: 'Rami — Stoning All Three Jamarat (11th & 12th)',
        description:
            'On each of these days, throw 7 pebbles at each of the three Jamarat in this order:\n\n1. Jamrat al-Sughra (Small pillar) — 7 pebbles\n2. Jamrat al-Wusta (Middle pillar) — 7 pebbles\n3. Jamrat al-Kubra / Aqabah (Large pillar) — 7 pebbles\n\nTotal: 21 pebbles per day.\n\nAfter throwing at the small and middle Jamarat, face the Kaaba, raise your hands, and make a long, sincere dua. Do not make dua after the large Jamarat.',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allāhu akbar.',
        dua: 'Allah is the Greatest. (Say with each pebble throw.)',
        note:
            'The Rami time is after Dhuhr on the 11th and 12th (and the 13th if you stay). It is also valid until sunset.',
      ),
      GuideStep(
        title: 'Early Departure (Nafr Awwal)',
        description:
            'You may leave Mina on the 12th of Dhul Hijjah after completing the Rami, provided you depart before sunset. This is called Nafr Awwal (early departure) and is permissible.\n\nIf you remain in Mina after sunset on the 12th, it becomes obligatory to stay for the 13th and perform the Rami on that day as well (Nafr Thani — late departure).',
        arabic:
            'فَمَنْ تَعَجَّلَ فِي يَوْمَيْنِ فَلَا إِثْمَ عَلَيْهِ وَمَنْ تَأَخَّرَ فَلَا إِثْمَ عَلَيْهِ',
        dua:
            '"Whoever hastens in two days, there is no sin on him; and whoever delays, there is no sin on him." — Quran 2:203',
      ),
    ],
  ),
  GuideSection(
    heading: 'Tawaf al-Wada\' — Farewell Tawaf',
    steps: [
      GuideStep(
        title: 'Farewell Tawaf',
        description:
            'Before leaving Makkah, perform Tawaf al-Wada\' (Farewell Tawaf) — 7 circuits around the Kaaba. This is the last act before departing. The Prophet ﷺ commanded: "Let none of you depart except that his last covenant with the House is by Tawaf." (Muslim)\n\nAfter the final circuit, make dua at the Multazam (the wall between the Black Stone and the door of the Kaaba), then exit.',
        note:
            'Women who are menstruating or in nifas (post-birth bleeding) are excused from Tawaf al-Wada\'. They may depart without it.',
      ),
      GuideStep(
        title: 'Leaving Makkah',
        description:
            'Exit the Masjid walking backwards, keeping your face toward the Kaaba for as long as possible. Make dua asking Allah to accept your Hajj.\n\nThe Prophet ﷺ said: "An accepted Hajj has no reward except Paradise." (Bukhari & Muslim)\n\nMay Allah accept your Hajj and grant you the status of a Hajj Mabrur. Ameen.',
        arabic:
            'اللَّهُمَّ تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ',
        transliteration:
            'Allāhumma taqabbal minnā innaka anta s-samī\'u l-\'alīm.',
        dua:
            'O Allah, accept from us. Indeed You are the All-Hearing, the All-Knowing.',
      ),
    ],
  ),
];
