import 'hajj_umrah_guide.dart';

const List<GuideSection> salahGuide = [
  GuideSection(
    heading: 'Prerequisites — Conditions of Salah',
    steps: [
      GuideStep(
        title: 'Purity (Taharah)',
        description:
            'You must be in a state of ritual purity. If you have broken wudu (ablution), perform it before praying. If you are in a state of major ritual impurity (janabah), a full bath (ghusl) is required first.',
        note: 'Salah is not valid without wudu. The Prophet ﷺ said: "Allah does not accept prayer without purification." (Muslim)',
      ),
      GuideStep(
        title: 'Prayer Time (Waqt)',
        description:
            'Each of the five prayers has a specific time window. Praying outside its time without a valid excuse is not accepted. The five times are: Fajr (dawn to sunrise), Dhuhr (midday to mid-afternoon), Asr (mid-afternoon to sunset), Maghrib (after sunset until twilight disappears), Isha (nightfall until midnight or Fajr).',
        note: 'Check the prayer times in the app to know the exact window for your location.',
      ),
      GuideStep(
        title: 'Facing the Qibla',
        description:
            'Face the direction of the Kaaba in Mecca (Qibla) during your prayer. If you are unable to determine the direction, use your best judgment. The Qibla Compass in this app can help you find the exact direction.',
        note: 'If you cannot face Qibla due to illness or danger, pray in whatever direction you can.',
      ),
      GuideStep(
        title: 'Covering the Awrah',
        description:
            'Men must cover from the navel to the knee. Women must cover the entire body except the face and hands during prayer. Clothing must be clean and free of impurity.',
      ),
      GuideStep(
        title: 'Clean Place',
        description:
            'The place of prayer must be clean. Use a prayer mat or ensure the floor is free of impurity. You may pray anywhere clean — in a field, office, or home.',
      ),
      GuideStep(
        title: 'Intention (Niyyah)',
        description:
            'Make the intention in your heart for which prayer you are performing (Fajr, Dhuhr, Asr, Maghrib, or Isha) and how many rak\'ahs. The intention does not need to be spoken aloud — it is in the heart.',
        note: 'Example: "I intend to perform the Fard (obligatory) prayer of Fajr — two rak\'ahs — for Allah."',
      ),
    ],
  ),

  GuideSection(
    heading: 'Wudu — Ritual Ablution',
    steps: [
      GuideStep(
        title: 'Intention for Wudu',
        description: 'Make the intention in your heart to perform wudu for purification. Begin with Bismillah.',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        dua: 'In the name of Allah.',
      ),
      GuideStep(
        title: 'Wash Hands',
        description: 'Wash both hands up to the wrists three times, starting with the right hand, making sure water reaches between the fingers.',
      ),
      GuideStep(
        title: 'Rinse the Mouth',
        description: 'Take water into the mouth and swirl it around, then spit it out. Do this three times.',
        note: 'Use a miswak (tooth stick) or toothbrush before wudu if possible.',
      ),
      GuideStep(
        title: 'Sniff Water into the Nose',
        description: 'Sniff water into the nose using the right hand, then blow it out with the left hand. Do this three times.',
      ),
      GuideStep(
        title: 'Wash the Face',
        description: 'Wash the entire face three times — from the hairline to the chin, and from ear to ear. Men must wash through the beard.',
      ),
      GuideStep(
        title: 'Wash the Arms',
        description: 'Wash the right arm from the fingertips up to and including the elbow three times. Then wash the left arm the same way.',
      ),
      GuideStep(
        title: 'Wipe the Head',
        description: 'Wet your hands and wipe once over the entire head — from front to back and then back to front. Do this once only.',
      ),
      GuideStep(
        title: 'Wipe the Ears',
        description: 'Using the same wet hands from the head wipe, insert index fingers into the ears and wipe around with thumbs. Do this once.',
      ),
      GuideStep(
        title: 'Wash the Feet',
        description: 'Wash the right foot up to and including the ankle three times, making sure water reaches between the toes. Then wash the left foot.',
      ),
      GuideStep(
        title: 'Dua After Wudu',
        description: 'After completing wudu, recite this dua while looking towards the sky.',
        arabic:
            'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        transliteration:
            'Ashhadu an lā ilāha illallāhu waḥdahu lā sharīka lah, wa ashhadu anna Muḥammadan \'abduhu wa rasūluh.',
        dua:
            'I bear witness that there is no god but Allah alone, with no partner, and I bear witness that Muhammad is His servant and Messenger.',
        note: 'Whoever recites this after wudu, all eight gates of Paradise will be opened for him. (Muslim)',
      ),
    ],
  ),

  GuideSection(
    heading: 'Beginning the Prayer',
    steps: [
      GuideStep(
        title: 'Standing (Qiyam)',
        description:
            'Stand upright facing the Qibla with feet slightly apart (shoulder width). Lower your gaze to the place of prostration. Relax your shoulders.',
        note: 'You may pray sitting if standing is too difficult, and lying down if sitting is not possible.',
      ),
      GuideStep(
        title: 'Opening Takbir — Takbiratul Ihram',
        description:
            'Raise both hands to the level of the ears (or shoulders), palms facing the Qibla, and say the opening Takbir. This marks the official beginning of the prayer — you may not speak, eat, or turn away after this.',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allāhu Akbar',
        dua: 'Allah is the Greatest.',
        note: 'This is the only obligatory statement that must be said aloud (by the imam or for personal salah). After saying it, place the right hand over the left on the chest.',
      ),
      GuideStep(
        title: 'Opening Supplication (Dua Al-Istiftah)',
        description:
            'After the opening Takbir, recite this opening dua silently. It is sunnah (recommended).',
        arabic:
            'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَهَ غَيْرُكَ',
        transliteration:
            'Subḥānaka-llāhumma wa biḥamdik, wa tabāraka smuk, wa ta\'ālā jadduk, wa lā ilāha ghayruk.',
        dua:
            'Glory be to You, O Allah, and praise. Blessed is Your name and exalted is Your majesty. There is no god but You.',
      ),
      GuideStep(
        title: 'Seeking Refuge (Ta\'awwudh)',
        description: 'Recite this silently before Al-Fatiha in the first rak\'ah.',
        arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
        transliteration: 'A\'ūdhu billāhi mina-sh-shayṭāni-r-rajīm.',
        dua: 'I seek refuge in Allah from the accursed Shaytan.',
      ),
      GuideStep(
        title: 'Bismillah',
        description: 'Recite Bismillah silently before Al-Fatiha.',
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        transliteration: 'Bismillāhi-r-raḥmāni-r-raḥīm.',
        dua: 'In the name of Allah, the Most Gracious, the Most Merciful.',
      ),
      GuideStep(
        title: 'Recite Surah Al-Fatiha',
        description:
            'Recite Al-Fatiha in every rak\'ah. It is obligatory. Say "Ameen" after the last verse (silently in Dhuhr and Asr, aloud in Fajr, Maghrib and Isha).',
        arabic:
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمَٰنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        transliteration:
            'Al-ḥamdu lillāhi rabbi-l-\'ālamīn. Ar-raḥmāni-r-raḥīm. Māliki yawmi-d-dīn. Iyyāka na\'budu wa iyyāka nasta\'īn. Ihdinā-ṣ-ṣirāṭa-l-mustaqīm. Ṣirāṭa-lladhīna an\'amta \'alayhim, ghayri-l-maghḍūbi \'alayhim wa la-ḍ-ḍāllīn.',
        dua:
            'All praise is due to Allah, Lord of all the worlds. The Most Gracious, the Most Merciful. Master of the Day of Judgment. You alone we worship, and You alone we ask for help. Guide us to the straight path — the path of those upon whom You have bestowed favor, not of those who have evoked Your anger or of those who are astray.',
        note: 'Reciting Al-Fatiha is a pillar (rukn) of Salah. If omitted, the rak\'ah is invalid.',
      ),
      GuideStep(
        title: 'Recite an Additional Surah or Verses',
        description:
            'After Al-Fatiha, recite any surah or a few verses from the Quran in the first two rak\'ahs. This is highly recommended (sunnah). Common choices: Surah Al-Ikhlas, Al-Falaq, An-Nas, Al-Kafirun, Al-Asr.',
        arabic:
            'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        transliteration:
            'Qul huwa-llāhu aḥad. Allāhu-ṣ-ṣamad. Lam yalid wa lam yūlad. Wa lam yakun lahu kufuwan aḥad.',
        dua:
            'Say: He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born. Nor is there to Him any equivalent.',
        note: 'Example: Surah Al-Ikhlas (shown above). In Fajr, Maghrib and Isha the additional surah is recited aloud.',
      ),
    ],
  ),

  GuideSection(
    heading: 'Ruku — Bowing',
    steps: [
      GuideStep(
        title: 'Takbir Before Ruku',
        description:
            'Raise your hands to ear level and say "Allahu Akbar" while moving into the bowing position.',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allāhu Akbar',
        dua: 'Allah is the Greatest.',
      ),
      GuideStep(
        title: 'The Bowing Position (Ruku)',
        description:
            'Bow until your back is horizontal and parallel to the ground. Place both hands firmly on your knees with fingers spread. Keep your head level with your back — not raised or lowered. Stay still.',
      ),
      GuideStep(
        title: 'Dhikr in Ruku',
        description: 'While in ruku, recite this at least three times:',
        arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
        transliteration: 'Subḥāna rabbiya-l-\'aẓīm.',
        dua: 'Glory be to my Lord, the Most Great.',
        note: 'Recite 3, 5, 7 or 9 times. Take your time — tranquility (tuma\'ninah) is obligatory.',
      ),
      GuideStep(
        title: 'Rising from Ruku (I\'tidal)',
        description:
            'Rise from ruku while raising your hands to shoulder level and saying:',
        arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ',
        transliteration: 'Sami\'a-llāhu liman ḥamidah.',
        dua: 'Allah hears the one who praises Him.',
      ),
      GuideStep(
        title: 'Standing Upright (I\'tidal Position)',
        description:
            'Stand fully upright with hands at your sides. Then say this while standing:',
        arabic: 'رَبَّنَا وَلَكَ الْحَمْدُ حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ',
        transliteration: 'Rabbanā wa laka-l-ḥamd, ḥamdan kathīran ṭayyiban mubārakan fīh.',
        dua: 'Our Lord, to You is all praise — abundant, good, and blessed praise.',
        note: 'You must stand fully still after ruku before moving to sujud. This upright pause is obligatory.',
      ),
    ],
  ),

  GuideSection(
    heading: 'Sujud — Prostration',
    steps: [
      GuideStep(
        title: 'Takbir Before First Sujud',
        description: 'Say "Allahu Akbar" while going down into prostration. Do not raise hands for this takbir.',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allāhu Akbar',
        dua: 'Allah is the Greatest.',
      ),
      GuideStep(
        title: 'The Prostration Position (Sujud)',
        description:
            'Place these seven parts on the ground: forehead (including the nose), both palms, both knees, and the toes of both feet. Keep the forehead and nose firmly on the ground. Arms should be away from the body (not spread on the ground). Fingers point toward the Qibla.',
        note: 'The Prophet ﷺ said: "I have been commanded to prostrate on seven bones." (Bukhari & Muslim)',
      ),
      GuideStep(
        title: 'Dhikr in Sujud',
        description: 'Recite at least three times in sujud:',
        arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
        transliteration: 'Subḥāna rabbiya-l-a\'lā.',
        dua: 'Glory be to my Lord, the Most High.',
        note: 'Sujud is the position closest to Allah. Make dua in your own words here — this is highly recommended.',
      ),
      GuideStep(
        title: 'Sitting Between Prostrations (Jalsa)',
        description:
            'Rise from sujud saying "Allahu Akbar" and sit upright. The right foot is upright (toes facing Qibla) while the left foot is flat and you sit on it. Place hands on thighs. Recite:',
        arabic: 'رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي',
        transliteration: 'Rabbi-ghfir lī, rabbi-ghfir lī.',
        dua: 'My Lord, forgive me. My Lord, forgive me.',
        note: 'Being still (tuma\'ninah) in this seated position is obligatory before going into the second sujud.',
      ),
      GuideStep(
        title: 'Second Sujud',
        description:
            'Say "Allahu Akbar" and go into the second prostration, same as the first. Recite the same dhikr at least three times.',
        arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
        transliteration: 'Subḥāna rabbiya-l-a\'lā.',
        dua: 'Glory be to my Lord, the Most High.',
        note: 'This completes one full rak\'ah.',
      ),
    ],
  ),

  GuideSection(
    heading: 'Second Rak\'ah & Tashahhud',
    steps: [
      GuideStep(
        title: 'Rising for the Second Rak\'ah',
        description:
            'After the second sujud of the first rak\'ah, say "Allahu Akbar" and rise to standing. Begin the second rak\'ah with Al-Fatiha (no opening dua or ta\'awwudh this time). Then recite an additional surah.',
      ),
      GuideStep(
        title: 'Perform Ruku and Sujud Again',
        description:
            'Perform ruku, I\'tidal, first sujud, jalsa, and second sujud exactly as in the first rak\'ah.',
      ),
      GuideStep(
        title: 'Sitting for Tashahhud (At-Tahiyyat)',
        description:
            'After the second sujud of the second rak\'ah, sit for the Tashahhud. For a 2 rak\'ah prayer (Fajr or Sunnah), this is the final sitting. For Dhuhr, Asr, Isha (4 rak\'ahs) or Maghrib (3 rak\'ahs), this is the first Tashahhud.\n\nSitting position: right foot upright, left foot flat, sit on left foot. Place left hand on left knee, right hand on right knee — raise the right index finger when saying the shahada.',
        arabic:
            'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        transliteration:
            'At-taḥiyyātu lillāhi wa-ṣ-ṣalawātu wa-ṭ-ṭayyibāt. As-salāmu \'alayka ayyuha-n-nabiyyu wa raḥmatullāhi wa barakātuh. As-salāmu \'alaynā wa \'alā \'ibādi-llāhi-ṣ-ṣāliḥīn. Ashhadu an lā ilāha illallāh, wa ashhadu anna Muḥammadan \'abduhu wa rasūluh.',
        dua:
            'All greetings, prayers and good words are for Allah. Peace be upon you, O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no god but Allah, and I bear witness that Muhammad is His servant and Messenger.',
        note: 'Raise and move the right index finger while saying the shahada as a sign of tawhid (oneness of Allah).',
      ),
      GuideStep(
        title: 'Salawat (Ibrahimiyyah) — In the Final Sitting',
        description:
            'After the Tashahhud in the FINAL sitting (not the middle one for 3 or 4 rak\'ah prayers), recite the Salawat:',
        arabic:
            'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ. اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
        transliteration:
            'Allāhumma ṣalli \'alā Muḥammadin wa \'alā āli Muḥammad, kamā ṣallayta \'alā Ibrāhīma wa \'alā āli Ibrāhīm, innaka ḥamīdun majīd. Allāhumma bārik \'alā Muḥammadin wa \'alā āli Muḥammad, kamā bārakta \'alā Ibrāhīma wa \'alā āli Ibrāhīm, innaka ḥamīdun majīd.',
        dua:
            'O Allah, send prayers upon Muhammad and the family of Muhammad, as You sent prayers upon Ibrahim and the family of Ibrahim — truly You are Praiseworthy and Glorious. O Allah, bless Muhammad and the family of Muhammad, as You blessed Ibrahim and the family of Ibrahim — truly You are Praiseworthy and Glorious.',
      ),
      GuideStep(
        title: 'Dua Before Salam (Recommended)',
        description:
            'Before ending the prayer with Salam, it is sunnah to seek refuge from four things. Recite:',
        arabic:
            'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ، وَمِنْ عَذَابِ الْقَبْرِ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ',
        transliteration:
            'Allāhumma innī a\'ūdhu bika min \'adhābi jahannam, wa min \'adhābi-l-qabr, wa min fitnati-l-maḥyā wa-l-mamāt, wa min sharri fitnati-l-masīḥi-d-dajjāl.',
        dua:
            'O Allah, I seek refuge in You from the punishment of Hellfire, from the punishment of the grave, from the tribulations of life and death, and from the evil of the trial of the Antichrist.',
        note: 'This is highly recommended in every prayer. (Bukhari & Muslim)',
      ),
    ],
  ),

  GuideSection(
    heading: 'Salam — Ending the Prayer',
    steps: [
      GuideStep(
        title: 'First Salam (Right)',
        description:
            'Turn your head to the right and say the Salam. This is the obligatory ending of the prayer.',
        arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
        transliteration: 'As-salāmu \'alaykum wa raḥmatullāh.',
        dua: 'Peace be upon you and the mercy of Allah.',
      ),
      GuideStep(
        title: 'Second Salam (Left)',
        description: 'Turn your head to the left and say the Salam again.',
        arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
        transliteration: 'As-salāmu \'alaykum wa raḥmatullāh.',
        dua: 'Peace be upon you and the mercy of Allah.',
        note: 'The prayer is now complete. You may add "wa barakātuh" on the right side — this is established in some narrations.',
      ),
    ],
  ),

  GuideSection(
    heading: 'Adhkar After Salah',
    steps: [
      GuideStep(
        title: 'Istighfar (3 times)',
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfiru-llāh.',
        dua: 'I seek forgiveness from Allah.',
        description: 'Say this three times immediately after Salam.',
      ),
      GuideStep(
        title: 'Opening Dua',
        arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        transliteration: 'Allāhumma anta-s-salām, wa minka-s-salām, tabārakta yā dha-l-jalāli wa-l-ikrām.',
        dua: 'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of Majesty and Honor.',
        description: 'Recite this once after the Istighfar.',
      ),
      GuideStep(
        title: 'Tasbih, Tahmid, Takbir (33 each)',
        description: 'Recite each of these 33 times:',
        arabic: 'سُبْحَانَ اللَّهِ ۝ الْحَمْدُ لِلَّهِ ۝ اللَّهُ أَكْبَرُ',
        transliteration: 'SubḥānAllāh (33x) · Alḥamdulillāh (33x) · Allāhu Akbar (33x)',
        dua: 'Glory be to Allah · Praise be to Allah · Allah is the Greatest',
        note: 'Then complete 100 by saying: "Lā ilāha illallāhu waḥdahu lā sharīka lah, lahu-l-mulku wa lahu-l-ḥamd, wa huwa \'alā kulli shay\'in qadīr." — This wipes away sins even if they were like the foam of the sea. (Muslim)',
      ),
      GuideStep(
        title: 'Ayat al-Kursi',
        description: 'Recite Ayat al-Kursi (2:255) once after each obligatory prayer.',
        arabic:
            'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        transliteration: 'Allāhu lā ilāha illā huwa-l-ḥayyu-l-qayyūm...',
        dua: 'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep...',
        note: 'Whoever recites Ayat al-Kursi after every obligatory prayer, nothing will prevent him from entering Paradise except death. (An-Nasa\'i, authenticated)',
      ),
    ],
  ),

  GuideSection(
    heading: 'Prayer-Specific Notes',
    steps: [
      GuideStep(
        title: 'Fajr — 2 Rak\'ahs',
        description:
            'Fajr has 2 obligatory rak\'ahs. Al-Fatiha and additional surah are recited aloud by the imam (or yourself if praying alone). Sit for Tashahhud and Salawat after the second rak\'ah, then make Salam.',
        note: 'Sunnah: Pray 2 rak\'ahs of Sunnah Fajr before the Fard, reciting Al-Kafirun and Al-Ikhlas.',
      ),
      GuideStep(
        title: 'Dhuhr — 4 Rak\'ahs',
        description:
            'Dhuhr has 4 obligatory rak\'ahs. All recitation is silent. After the 2nd rak\'ah, sit for the first Tashahhud (recite At-Tahiyyat only — no Salawat). Then rise for rak\'ahs 3 and 4. After the 4th rak\'ah, sit for the final Tashahhud with Salawat, then Salam.',
        note: 'In rak\'ahs 3 and 4, recite only Al-Fatiha (no additional surah).',
      ),
      GuideStep(
        title: 'Asr — 4 Rak\'ahs',
        description: 'Same structure as Dhuhr — 4 rak\'ahs with silent recitation. First Tashahhud after 2nd rak\'ah, final Tashahhud after 4th.',
      ),
      GuideStep(
        title: 'Maghrib — 3 Rak\'ahs',
        description:
            'Maghrib has 3 obligatory rak\'ahs. Recitation in rak\'ahs 1 and 2 is aloud. After the 2nd rak\'ah, sit for the first Tashahhud (At-Tahiyyat only). Rise for the 3rd rak\'ah (silent, Al-Fatiha only). After the 3rd rak\'ah, sit for the final Tashahhud with Salawat, then Salam.',
      ),
      GuideStep(
        title: 'Isha — 4 Rak\'ahs',
        description:
            'Isha has 4 obligatory rak\'ahs. Rak\'ahs 1 and 2 are recited aloud. Same structure as Dhuhr regarding Tashahhud positions.',
        note: 'Sunnah: Pray 2 rak\'ahs of Witr after Isha (minimum), and ideally end the night with Witr if praying Tahajjud.',
      ),
      GuideStep(
        title: 'Making Up Missed Prayers (Qada)',
        description:
            'If you miss a prayer, you must make it up (qada) as soon as you remember or are able. The structure is the same as the original prayer. Make the intention that you are making up the missed prayer.',
        note: 'The Prophet ﷺ said: "Whoever forgets a prayer or sleeps through it, its expiation is to pray it when he remembers." (Muslim)',
      ),
    ],
  ),
];
