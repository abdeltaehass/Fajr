class Dua {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;

  const Dua({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
  });
}

class DuaCategory {
  final String name;
  final String icon;
  final List<Dua> duas;

  const DuaCategory({
    required this.name,
    required this.icon,
    required this.duas,
  });
}

const List<DuaCategory> duaCategories = [
  DuaCategory(
    name: 'Morning',
    icon: '🌅',
    duas: [
      Dua(
        title: 'Waking Up',
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration: "Alhamdu lillahil-ladhi ahyana ba'da ma amatana wa-ilayhin-nushur",
        translation: 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
        source: 'Sahih Al-Bukhari 6312',
      ),
      Dua(
        title: 'Morning Remembrance',
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration: "Asbahna wa-asbahal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah",
        translation: 'We have entered a new morning and with it all dominion belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah alone, with no partner.',
        source: 'Sahih Muslim 2723',
      ),
      Dua(
        title: 'Protection in the Morning',
        arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
        transliteration: "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur",
        translation: 'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
        source: 'Sunan Abu Dawud 5068',
      ),
    ],
  ),
  DuaCategory(
    name: 'Evening',
    icon: '🌙',
    duas: [
      Dua(
        title: 'Evening Remembrance',
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        transliteration: "Amsayna wa amsal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah",
        translation: 'We have entered the evening and with it all dominion belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah alone, with no partner.',
        source: 'Sahih Muslim 2723',
      ),
      Dua(
        title: 'Seeking Forgiveness in the Evening',
        arabic: 'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
        transliteration: "Astaghfirullaha alladhi la ilaha illa huwal hayyul qayyumu wa atubu ilaih",
        translation: 'I seek the forgiveness of Allah, besides Whom none has the right to be worshipped, the Ever-Living, the Self-Sustaining, and I repent to Him.',
        source: 'Sunan Abu Dawud 1517',
      ),
    ],
  ),
  DuaCategory(
    name: 'Before Sleep',
    icon: '😴',
    duas: [
      Dua(
        title: 'Going to Sleep',
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya',
        translation: 'In Your name, O Allah, I die and I live.',
        source: 'Sahih Al-Bukhari 6324',
      ),
      Dua(
        title: 'Ayat al-Kursi Before Sleep',
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        transliteration: "Allahu la ilaha illa huwal hayyul qayyum, la ta'khudhuhu sinatun wa la nawm",
        translation: 'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep.',
        source: 'Quran 2:255 | Sahih Al-Bukhari 2311',
      ),
      Dua(
        title: 'Seeking Protection at Night',
        arabic: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ',
        transliteration: "Bismika rabbi wada'tu janbi, wa bika arfa'uh, fa-in amsakta nafsi farhamha, wa in arsaltaha fahfazha bima tahfazu bihi 'ibadakas-salihin",
        translation: 'In Your name my Lord, I lie down and in Your name I rise. If You take my soul then have mercy on it, and if You return it then protect it as You protect Your righteous servants.',
        source: 'Sahih Al-Bukhari 6320',
      ),
    ],
  ),
  DuaCategory(
    name: 'Eating & Drinking',
    icon: '🍽️',
    duas: [
      Dua(
        title: 'Before Eating',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah.',
        source: 'Sunan Abu Dawud 3767',
      ),
      Dua(
        title: 'If You Forget Bismillah',
        arabic: 'بِسْمِ اللَّهِ فِي أَوَّلِهِ وَآخِرِهِ',
        transliteration: "Bismillahi fi awwalihi wa akhirih",
        translation: 'In the name of Allah at its beginning and at its end.',
        source: 'Sunan Abu Dawud 3767',
      ),
      Dua(
        title: 'After Eating',
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
        transliteration: "Alhamdu lillahil-ladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
        translation: 'All praise is for Allah who fed me this and provided it for me without any might or power on my part.',
        source: 'Sunan Abu Dawud 4023',
      ),
      Dua(
        title: 'Before Drinking Water',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah.',
        source: 'Sahih Al-Bukhari 5376',
      ),
    ],
  ),
  DuaCategory(
    name: 'Travel',
    icon: '✈️',
    duas: [
      Dua(
        title: 'Leaving the Home',
        arabic: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: "Bismillah, tawakkaltu 'alallah, wa la hawla wa la quwwata illa billah",
        translation: 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
        source: 'Sunan Abu Dawud 5095',
      ),
      Dua(
        title: 'Entering a Vehicle',
        arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ',
        transliteration: "Subhana alladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun",
        translation: 'Glory be to the One Who has subjected this to us, and we were not capable of it, and indeed, to our Lord we will return.',
        source: 'Quran 43:13-14 | Sunan Abu Dawud 2602',
      ),
      Dua(
        title: 'Dua for the Journey',
        arabic: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى',
        transliteration: "Allahumma inna nas'aluka fi safarina hadhal birra wat-taqwa, wa minal 'amali ma tarda",
        translation: 'O Allah, we ask You on this journey for righteousness and piety, and for deeds that are pleasing to You.',
        source: 'Sahih Muslim 1342',
      ),
      Dua(
        title: 'Returning Home',
        arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
        transliteration: "Ayibuna ta'ibuna 'abiduna li-rabbina hamidun",
        translation: 'We return, repenting, worshipping, and praising our Lord.',
        source: 'Sahih Al-Bukhari 3084',
      ),
    ],
  ),
  DuaCategory(
    name: 'Entering & Leaving',
    icon: '🚪',
    duas: [
      Dua(
        title: 'Entering the Home',
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ، بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
        transliteration: "Allahumma inni as'aluka khayral mawlaji wa khayral makhraji, bismillahi walajna, wa bismillahi kharajna, wa 'alallahi rabbina tawakkalna",
        translation: 'O Allah, I ask You for goodness upon entering and goodness upon leaving. In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we rely.',
        source: 'Sunan Abu Dawud 5096',
      ),
      Dua(
        title: 'Entering the Masjid',
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        transliteration: "Allahumm aftah li abwaba rahmatik",
        translation: 'O Allah, open the gates of Your mercy for me.',
        source: 'Sahih Muslim 713',
      ),
      Dua(
        title: 'Leaving the Masjid',
        arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        transliteration: "Allahumma inni as'aluka min fadlik",
        translation: 'O Allah, I ask You of Your bounty.',
        source: 'Sahih Muslim 713',
      ),
    ],
  ),
  DuaCategory(
    name: 'During Hardship',
    icon: '🤲',
    duas: [
      Dua(
        title: 'When Afflicted',
        arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
        transliteration: "Inna lillahi wa inna ilayhi raji'un. Allahumm'jurnifi musibati wa akhlif li khayran minha",
        translation: 'Indeed to Allah we belong and to Him we shall return. O Allah, reward me in my affliction and replace it for me with something better.',
        source: 'Sahih Muslim 918',
      ),
      Dua(
        title: 'Supplication in Distress',
        arabic: 'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
        transliteration: "La ilaha illallahul 'azimul halim, la ilaha illallahu rabbul 'arshil 'azim, la ilaha illallahu rabus-samawati wa rabbul ardi wa rabbul 'arshil karim",
        translation: 'There is none worthy of worship but Allah, the Mighty, the Forbearing. There is none worthy of worship but Allah, the Lord of the Mighty Throne. There is none worthy of worship but Allah, the Lord of the heavens, the Lord of the earth, and the Lord of the Noble Throne.',
        source: 'Sahih Al-Bukhari 6346',
      ),
      Dua(
        title: 'Dua of Yunus (AS)',
        arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
        transliteration: "La ilaha illa anta subhanaka inni kuntu minaz-zalimin",
        translation: 'There is none worthy of worship but You, glory be to You; surely I was one of the wrongdoers.',
        source: 'Quran 21:87',
      ),
    ],
  ),
  DuaCategory(
    name: 'Forgiveness',
    icon: '💚',
    duas: [
      Dua(
        title: 'Sayyid al-Istighfar',
        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        transliteration: "Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana 'abduk, wa ana 'ala 'ahdika wa wa'dika mas-tata't, a'udhu bika min sharri ma sana't, abu'u laka bini'matika 'alayya wa abu'u bidhanbi, faghfir li fa-innahu la yaghfirudh-dhunuba illa ant",
        translation: 'O Allah, You are my Lord, none has the right to be worshipped but You, You created me and I am Your servant, and I abide by Your covenant and promise as best I can, I seek Your protection from the evil of what I have done, I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for none forgives sins but You.',
        source: 'Sahih Al-Bukhari 6306',
      ),
      Dua(
        title: 'Simple Seeking Forgiveness',
        arabic: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
        transliteration: "Rabbighfir li wa tub 'alayya innaka antal-tawwabur-rahim",
        translation: 'My Lord, forgive me and accept my repentance. You are the Oft-Returning, the Most Merciful.',
        source: 'Sunan Ibn Majah 3814',
      ),
    ],
  ),
  DuaCategory(
    name: 'After Prayer',
    icon: '🕌',
    duas: [
      Dua(
        title: 'Seeking Forgiveness 3x',
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah',
        translation: 'I seek the forgiveness of Allah.',
        source: 'Sahih Muslim 591',
      ),
      Dua(
        title: 'Glorification After Prayer',
        arabic: 'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ',
        transliteration: 'Subhanallah, walhamdulillah, wallahu akbar',
        translation:
            'Glory be to Allah. All praise is for Allah. Allah is the Greatest. (Each 33 times)',
        source: 'Sahih Muslim 597',
      ),
      Dua(
        title: 'Completion of 100',
        arabic:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            "La ilaha illallahu wahdahu la sharika lah, lahul mulku wa lahul hamdu wa huwa 'ala kulli shay'in qadir",
        translation:
            'There is no god but Allah alone, with no partner. To Him belongs dominion and all praise, and He has power over all things.',
        source: 'Sahih Muslim 597',
      ),
      Dua(
        title: 'Dua After Every Prayer',
        arabic:
            'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
        transliteration:
            "Allahumma a'inni 'ala dhikrika wa shukrika wa husni 'ibadatik",
        translation:
            'O Allah, help me to remember You, to give thanks to You, and to worship You in the best manner.',
        source: 'Sunan Abu Dawud 1522',
      ),
    ],
  ),
  DuaCategory(
    name: 'After Wudu',
    icon: '💧',
    duas: [
      Dua(
        title: 'Shahada After Wudu',
        arabic:
            'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        transliteration:
            "Ash-hadu an la ilaha illallahu wahdahu la sharika lah, wa ash-hadu anna Muhammadan 'abduhu wa rasuluh",
        translation:
            'I bear witness that there is no god but Allah alone, with no partner, and I bear witness that Muhammad is His servant and messenger.',
        source: 'Sahih Muslim 234',
      ),
      Dua(
        title: 'Full Dua After Wudu',
        arabic:
            'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
        transliteration:
            'Allahumma-j\'alni minat-tawwabina wa-j\'alni minal-mutatahhirin',
        translation:
            'O Allah, make me among those who repent and make me among those who purify themselves.',
        source: 'Sunan At-Tirmidhi 55',
      ),
    ],
  ),
  DuaCategory(
    name: 'Bathroom',
    icon: '🚿',
    duas: [
      Dua(
        title: 'Before Entering',
        arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
        transliteration:
            'Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith',
        translation:
            'O Allah, I seek Your protection from evil and from the evil ones.',
        source: 'Sahih Al-Bukhari 142',
      ),
      Dua(
        title: 'After Leaving',
        arabic: 'غُفْرَانَكَ',
        transliteration: 'Ghufranaka',
        translation: 'I ask You for forgiveness.',
        source: 'Sunan Abu Dawud 30',
      ),
    ],
  ),
  DuaCategory(
    name: 'For Parents',
    icon: '👨‍👩‍👦',
    duas: [
      Dua(
        title: 'Dua for Parents',
        arabic:
            'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
        transliteration:
            "Rabbighfir li wa liwali dayya warhamhuma kama rabbayani saghira",
        translation:
            'My Lord, forgive me and my parents and have mercy on them as they raised me when I was young.',
        source: 'Quran 17:24',
      ),
      Dua(
        title: 'Expanded Dua for Parents',
        arabic:
            'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
        transliteration: "Rabbir-hamhuma kama rabbayani saghira",
        translation:
            'My Lord, have mercy on them both as they raised me when I was small.',
        source: 'Quran 17:24',
      ),
    ],
  ),
  DuaCategory(
    name: 'Friday',
    icon: '🌟',
    duas: [
      Dua(
        title: 'Abundant Salawat on Friday',
        arabic:
            'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
        transliteration:
            "Allahumma salli 'ala Muhammad wa 'ala ali Muhammad kama sallayta 'ala Ibrahim wa 'ala ali Ibrahim innaka Hamidun Majid",
        translation:
            'O Allah, send blessings upon Muhammad and the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim. You are indeed Praiseworthy, Most Glorious.',
        source: 'Sahih Al-Bukhari 3370',
      ),
      Dua(
        title: 'Dua of the Hour on Friday',
        arabic:
            'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
        transliteration:
            "Allahumma innaka 'afuwwun karimun tuhibbul 'afwa fa'fu 'anni",
        translation:
            'O Allah, You are Most Forgiving, Most Generous, You love to forgive, so forgive me.',
        source: 'Sunan At-Tirmidhi 3513',
      ),
      Dua(
        title: 'Surah al-Kahf Reminder',
        arabic:
            'مَنْ قَرَأَ سُورَةَ الْكَهْفِ يَوْمَ الْجُمُعَةِ أَضَاءَ لَهُ مِنَ النُّورِ مَا بَيْنَ الْجُمُعَتَيْنِ',
        transliteration:
            "Man qara'a surata l-kahfi yawmal jumu'ati ada'a lahu minan-nuri ma bayna l-jumu'atayn",
        translation:
            '"Whoever recites Surah al-Kahf on Friday, it will illuminate him with light between the two Fridays." — Prophet Muhammad ﷺ',
        source: 'Al-Mustadrak, Al-Hakim 2/368 — Hasan',
      ),
    ],
  ),
  DuaCategory(
    name: 'Rain & Weather',
    icon: '🌧️',
    duas: [
      Dua(
        title: 'When It Rains',
        arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
        transliteration: 'Allahumma sayyiban nafi\'a',
        translation: 'O Allah, make it a beneficial rain.',
        source: 'Sahih Al-Bukhari 1032',
      ),
      Dua(
        title: 'After Rain',
        arabic: 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ',
        transliteration: "Mutirna bifadlillahi wa rahmatih",
        translation: 'We have been given rain by the grace and mercy of Allah.',
        source: 'Sahih Al-Bukhari 846',
      ),
      Dua(
        title: 'When Hearing Thunder',
        arabic:
            'سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ',
        transliteration:
            "Subhanal-ladhi yusabbihur-ra'du bihamdihi wal-mala'ikatu min khifatih",
        translation:
            'Glory be to the One Whom the thunder glorifies with His praise, and the angels too out of awe of Him.',
        source: 'Muwatta Imam Malik 2/992',
      ),
      Dua(
        title: 'During Strong Winds',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ وَأَعُوذُ بِكَ مِنْ شَرِّهَا',
        transliteration:
            "Allahumma inni as'aluka khayrana wa khayra ma fiha wa khayra ma ursilat bihi wa a'udhu bika min sharriha",
        translation:
            'O Allah, I ask You for its good and the good within it and the good it brings, and I seek Your protection from its evil.',
        source: 'Sahih Muslim 899',
      ),
    ],
  ),
  DuaCategory(
    name: 'Visiting the Sick',
    icon: '🏥',
    duas: [
      Dua(
        title: 'Dua When Visiting the Sick',
        arabic:
            'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
        transliteration: "La ba'sa tahurun in sha'Allah",
        translation:
            'Do not worry, it will be a purification, if Allah wills.',
        source: 'Sahih Al-Bukhari 5656',
      ),
      Dua(
        title: 'Ruqyah for the Sick',
        arabic:
            'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ، اشْفِهِ وَأَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا',
        transliteration:
            "Allahumma rabban-nasi adhhibil-ba's, washfihi wa antas-shafi, la shifa'a illa shifa'uk, shifa'an la yughadiru saqama",
        translation:
            'O Allah, Lord of mankind, remove the affliction and grant healing, for You are the Healer. There is no healing except Your healing — a healing that leaves no illness behind.',
        source: 'Sahih Al-Bukhari 5675',
      ),
      Dua(
        title: 'Wiping Seven Times',
        arabic:
            'أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ',
        transliteration:
            "As'alullaha l-'azima rabbal-'arshil-'azimi an yashfiyak",
        translation:
            'I ask Allah the Mighty, the Lord of the Mighty Throne, to cure you. (Recite 7 times over the ill person)',
        source: 'Sunan Abu Dawud 3106',
      ),
    ],
  ),
  DuaCategory(
    name: 'Protection',
    icon: '🛡️',
    duas: [
      Dua(
        title: 'Morning & Evening Protection',
        arabic:
            'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        transliteration:
            "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-'alim",
        translation:
            'In the name of Allah, with Whose name nothing on earth or in the heavens can cause harm, and He is the All-Hearing, the All-Knowing. (3x morning & evening)',
        source: 'Sunan Abu Dawud 5088',
      ),
      Dua(
        title: 'Protection from All Evil',
        arabic:
            'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        transliteration:
            "A'udhu bikalimatillahit-tammati min sharri ma khalaq",
        translation:
            'I seek refuge in the perfect words of Allah from the evil of what He has created.',
        source: 'Sahih Muslim 2708',
      ),
      Dua(
        title: 'Seeking Refuge in Allah',
        arabic:
            'أَعُوذُ بِاللَّهِ السَّمِيعِ الْعَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
        transliteration:
            "A'udhu billahis-sami'il-'alimi minash-shaytanir-rajim",
        translation:
            'I seek refuge in Allah, the All-Hearing, the All-Knowing, from the accursed Shaytan.',
        source: 'Quran 16:98 | Sunan Abu Dawud 775',
      ),
      Dua(
        title: 'Three Quls (3x Each)',
        arabic:
            'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        transliteration:
            'Qul huwallahu ahad (Surah 112) | Qul a\'udhu bi-rabbil-falaq (Surah 113) | Qul a\'udhu bi-rabbin-nas (Surah 114)',
        translation:
            'Recite Surah Al-Ikhlas, Surah Al-Falaq, and Surah An-Nas three times each in the morning and evening for protection throughout the day.',
        source: 'Sunan Abu Dawud 5082',
      ),
    ],
  ),
  DuaCategory(
    name: 'Gratitude & Praise',
    icon: '🌸',
    duas: [
      Dua(
        title: 'Best Dhikr',
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        transliteration: 'Subhanallahi wa bihamdih',
        translation:
            'Glory be to Allah and His is the praise. (The Prophet ﷺ said: "Two phrases light on the tongue, heavy on the Scale, and beloved to the Most Merciful.")',
        source: 'Sahih Al-Bukhari 6406',
      ),
      Dua(
        title: 'Treasure of Paradise',
        arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration: "La hawla wa la quwwata illa billah",
        translation:
            'There is no might nor power except with Allah. (The Prophet ﷺ called it a treasure from the treasures of Paradise.)',
        source: 'Sahih Al-Bukhari 6610',
      ),
      Dua(
        title: 'Remembrance of Allah',
        arabic:
            'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
        transliteration:
            "Subhanallahi wa bihamdih, subhanallahil-'azim",
        translation:
            'Glory be to Allah and His is the praise; glory be to Allah the Magnificent.',
        source: 'Sahih Al-Bukhari 6682',
      ),
      Dua(
        title: 'When Receiving Good News',
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ',
        transliteration:
            "Alhamdu lillahil-ladhi bini'matihi tatimmus-salihat",
        translation:
            'All praise is for Allah, by Whose blessing all good things are completed.',
        source: 'Sunan Ibn Majah 3803',
      ),
    ],
  ),
];
