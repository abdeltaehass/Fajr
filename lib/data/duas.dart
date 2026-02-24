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
];
