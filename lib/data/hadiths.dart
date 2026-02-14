class Hadith {
  final String text;
  final String narrator;
  final String source;

  const Hadith({
    required this.text,
    required this.narrator,
    required this.source,
  });
}

Hadith get todaysHadith {
  final dayOfYear =
      DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
  return hadithCollection[dayOfYear % hadithCollection.length];
}

const List<Hadith> hadithCollection = [
  Hadith(
    text:
        'Actions are judged by intentions, so each man will have what he intended. Thus, he whose migration was to Allah and His Messenger, his migration is to Allah and His Messenger; but he whose migration was for some worldly thing he might gain, or for a wife he might marry, his migration is to that for which he migrated.',
    narrator: 'Narrated by Umar ibn Al-Khattab (RA)',
    source: 'Sahih Al-Bukhari 1, Sahih Muslim 1907',
  ),
  Hadith(
    text:
        'None of you truly believes until he loves for his brother what he loves for himself.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 13, Sahih Muslim 45',
  ),
  Hadith(
    text:
        'Whoever believes in Allah and the Last Day, let him speak good or remain silent. Whoever believes in Allah and the Last Day, let him be generous to his neighbor. Whoever believes in Allah and the Last Day, let him be generous to his guest.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6018, Sahih Muslim 47',
  ),
  Hadith(
    text:
        'A Muslim is the one from whose tongue and hands other Muslims are safe, and a Muhajir (emigrant) is the one who abandons what Allah has forbidden.',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    source: 'Sahih Al-Bukhari 10, Sahih Muslim 40',
  ),
  Hadith(
    text:
        'Do not be angry, and Paradise will be yours.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6116',
  ),
  Hadith(
    text:
        'The strong man is not the one who can overpower others. Rather, the strong man is the one who controls himself when he is angry.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6114, Sahih Muslim 2609',
  ),
  Hadith(
    text:
        'Allah does not look at your bodies or your forms, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
  ),
  Hadith(
    text:
        'Part of the perfection of one\'s Islam is his leaving that which does not concern him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Jami At-Tirmidhi 2317',
  ),
  Hadith(
    text:
        'Whoever follows a path in pursuit of knowledge, Allah will make easy for him a path to Paradise.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
  ),
  Hadith(
    text:
        'The best of you are those who learn the Quran and teach it.',
    narrator: 'Narrated by Uthman ibn Affan (RA)',
    source: 'Sahih Al-Bukhari 5027',
  ),
  Hadith(
    text:
        'Make things easy and do not make them difficult, cheer people up and do not drive them away.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 69, Sahih Muslim 1734',
  ),
  Hadith(
    text:
        'The most beloved of deeds to Allah are the most consistent of them, even if they are few.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Al-Bukhari 6464, Sahih Muslim 783',
  ),
  Hadith(
    text:
        'When a man dies, his deeds come to an end except for three things: ongoing charity, beneficial knowledge, or a righteous child who prays for him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 1631',
  ),
  Hadith(
    text:
        'The best among you is the one who is best to his family, and I am the best among you to my family.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Jami At-Tirmidhi 3895',
  ),
  Hadith(
    text:
        'He who is not merciful to others, will not be treated mercifully.',
    narrator: 'Narrated by Jarir ibn Abdullah (RA)',
    source: 'Sahih Al-Bukhari 7376, Sahih Muslim 2319',
  ),
  Hadith(
    text:
        'Smiling in the face of your brother is charity. Enjoining what is good and forbidding what is evil is charity. Guiding a man who has lost his way is charity.',
    narrator: 'Narrated by Abu Dharr (RA)',
    source: 'Jami At-Tirmidhi 1956',
  ),
  Hadith(
    text:
        'The believer is not one who eats his fill while his neighbor is hungry.',
    narrator: 'Narrated by Ibn Abbas (RA)',
    source: 'Al-Adab Al-Mufrad 112',
  ),
  Hadith(
    text:
        'Be in this world as if you were a stranger or a traveler along a path.',
    narrator: 'Narrated by Abdullah ibn Umar (RA)',
    source: 'Sahih Al-Bukhari 6416',
  ),
  Hadith(
    text:
        'Richness is not having many possessions. Rather, true richness is the richness of the soul.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6446, Sahih Muslim 1051',
  ),
  Hadith(
    text:
        'Verily, Allah does not look at your appearance or your wealth, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
  ),
  Hadith(
    text:
        'Take advantage of five before five: your youth before your old age, your health before your illness, your wealth before your poverty, your free time before your busyness, and your life before your death.',
    narrator: 'Narrated by Ibn Abbas (RA)',
    source: 'Shu\'ab Al-Iman 10248',
  ),
  Hadith(
    text:
        'The supplication between the adhan and the iqamah is not rejected.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Jami At-Tirmidhi 212',
  ),
  Hadith(
    text:
        'Whoever says SubhanAllah wa bihamdihi one hundred times a day will have his sins forgiven even if they were like the foam of the sea.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6405, Sahih Muslim 2691',
  ),
  Hadith(
    text:
        'The two words most beloved to the Most Merciful are: SubhanAllahi wa bihamdihi, SubhanAllahil Adheem (Glory and praise be to Allah, Glory be to Allah the Almighty).',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 7563, Sahih Muslim 2694',
  ),
  Hadith(
    text:
        'A good word is charity.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 2989, Sahih Muslim 1009',
  ),
  Hadith(
    text:
        'Whoever removes a worldly hardship from a believer, Allah will remove from him one of the hardships of the Day of Resurrection.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
  ),
  Hadith(
    text:
        'The best of people are those who are most beneficial to people.',
    narrator: 'Narrated by Jabir (RA)',
    source: 'Al-Mu\'jam Al-Awsat 5787',
  ),
  Hadith(
    text:
        'Modesty brings nothing but goodness.',
    narrator: 'Narrated by Imran ibn Husayn (RA)',
    source: 'Sahih Al-Bukhari 6117, Sahih Muslim 37',
  ),
  Hadith(
    text:
        'The most complete of the believers in faith is the one with the best character among them. And the best of you are those who are best to their women.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Jami At-Tirmidhi 1162',
  ),
  Hadith(
    text:
        'Allah is gentle and loves gentleness. He gives for gentleness what He does not give for harshness, nor for anything else.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Muslim 2593',
  ),
];
