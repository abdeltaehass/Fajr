import 'hajj_umrah_guide.dart';

// ─────────────────────────────────────────────────────────────
// MENSTRUATION (HAYD) GUIDE
// ─────────────────────────────────────────────────────────────

const List<GuideSection> haydGuide = [
  GuideSection(
    heading: 'What is Hayd?',
    steps: [
      GuideStep(
        title: 'Definition',
        description:
            'Hayd (حَيْض) is the natural monthly menstrual bleeding that occurs in women. It is a natural state that Allah has decreed, and Islam provides clear rulings regarding it.',
        note: 'The Prophet ﷺ said: "This is something Allah has written upon the daughters of Adam." (Bukhari & Muslim)',
      ),
      GuideStep(
        title: 'Duration',
        description:
            'The minimum duration of hayd is one day and one night (24 hours) according to some scholars. The maximum is typically 15 days, though the average is 6–7 days. Any bleeding beyond 15 days is considered istihadah (irregular bleeding) and has its own rulings.',
        note: 'A woman should track her cycle. If bleeding stops before 15 days, she is considered pure. If it continues beyond 15 days, she follows the rulings of istihadah.',
      ),
      GuideStep(
        title: 'Signs of Purity (Tuhr)',
        description:
            'A woman is considered pure (tahir) when she sees a white discharge (qussah baydaa) or when the bleeding completely stops and there is complete dryness. At this point she must perform ghusl.',
      ),
    ],
  ),
  GuideSection(
    heading: 'What is Forbidden During Hayd',
    steps: [
      GuideStep(
        title: 'Prayer (Salah)',
        description:
            'A woman in a state of hayd does NOT pray and does NOT make up the missed prayers after becoming pure. This is a mercy from Allah.',
        note: 'Aisha (RA) said: "We used to menstruate at the time of the Messenger of Allah ﷺ, and we were not commanded to make up prayers." (Bukhari)',
      ),
      GuideStep(
        title: 'Fasting (Sawm)',
        description:
            'A woman in hayd does NOT fast. However, she MUST make up the missed fasts of Ramadan after becoming pure.',
        note: 'The missed fasting days must be made up before the next Ramadan.',
      ),
      GuideStep(
        title: 'Tawaf',
        description:
            'Performing tawaf around the Ka\'bah is forbidden during hayd. However, she may perform all other Hajj/Umrah rituals (Sa\'i, staying in Mina, etc.) except tawaf.',
      ),
      GuideStep(
        title: 'Touching and Reciting Quran',
        description:
            'According to the majority of scholars, a woman in hayd should avoid touching the mushaf (physical Quran). She may recite Quran from memory or from a screen/app according to many contemporary scholars.',
        note: 'Scholars differ on this matter. It is safest to read from a screen or avoid reciting altogether if following the stricter opinion. Dhikr, du\'a, and listening to Quran are all permissible.',
      ),
      GuideStep(
        title: 'Intercourse',
        description:
            'Sexual intercourse is strictly forbidden during hayd. Allah says: "And they ask you about menstruation. Say: It is harm, so keep away from wives during menstruation." (Quran 2:222)',
        arabic: 'وَيَسْأَلُونَكَ عَنِ الْمَحِيضِ ۖ قُلْ هُوَ أَذًى فَاعْتَزِلُوا النِّسَاءَ فِي الْمَحِيضِ',
        note: 'Other forms of intimacy (kissing, cuddling, etc.) are permissible. After she becomes pure and performs ghusl, intercourse becomes lawful again.',
      ),
      GuideStep(
        title: 'Entering the Masjid',
        description:
            'According to the majority of scholars, a woman in hayd should not sit or stay inside the masjid. She may pass through if necessary according to some scholars.',
        note: 'She may attend Islamic classes and lectures held outside the prayer hall.',
      ),
    ],
  ),
  GuideSection(
    heading: 'What is Permitted During Hayd',
    steps: [
      GuideStep(
        title: 'Dhikr and Du\'a',
        description:
            'A woman in hayd may freely make dhikr (remembrance of Allah), make du\'a (supplication), send salawat on the Prophet ﷺ, and engage in all other forms of worship not restricted during hayd.',
      ),
      GuideStep(
        title: 'Reading Islamic Books and Listening',
        description:
            'She may read Islamic books, listen to Quran recitation, attend classes, and learn about the deen.',
      ),
      GuideStep(
        title: 'Istighfar and Tasbih',
        description:
            'SubhanAllah, Alhamdulillah, Allahu Akbar, Astaghfirullah — all dhikr and istighfar are completely permissible and highly encouraged during hayd.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Nifas (Post-Natal Bleeding)',
    steps: [
      GuideStep(
        title: 'Definition of Nifas',
        description:
            'Nifas is the bleeding that occurs after childbirth. The same rulings as hayd apply during nifas (no prayer, no fasting, no intercourse, etc.).',
      ),
      GuideStep(
        title: 'Duration of Nifas',
        description:
            'There is no minimum duration for nifas. The maximum is 40 days according to the majority of scholars. If bleeding stops before 40 days, she performs ghusl and resumes her acts of worship. If it continues beyond 40 days, she follows the rulings of istihadah.',
      ),
      GuideStep(
        title: 'Becoming Pure After Nifas',
        description:
            'Once bleeding stops or 40 days pass, she performs a full ghusl and resumes prayer, fasting, and all other acts of worship.',
      ),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────
// GHUSL (RITUAL BATH) GUIDE
// ─────────────────────────────────────────────────────────────

const List<GuideSection> ghusulGuide = [
  GuideSection(
    heading: 'What is Ghusl?',
    steps: [
      GuideStep(
        title: 'Definition',
        description:
            'Ghusl (غُسْل) is the ritual purification bath required to remove major ritual impurity (janabah). It involves washing the entire body with water and is an obligation before certain acts of worship.',
      ),
      GuideStep(
        title: 'When is Ghusl Obligatory?',
        description:
            'Ghusl is required after: (1) Janabah — sexual intercourse or ejaculation, (2) Hayd — end of menstruation, (3) Nifas — end of post-natal bleeding, (4) Death — washing the deceased Muslim.',
        note: 'Ghusl on Friday (Jumu\'ah) is highly recommended (sunnah mu\'akkadah) but not obligatory according to the majority.',
      ),
    ],
  ),
  GuideSection(
    heading: 'The Obligatory Elements (Fard)',
    steps: [
      GuideStep(
        title: '1. Intention (Niyyah)',
        description:
            'Make the intention in your heart to purify yourself from major impurity. The niyyah does not need to be spoken aloud — it is an act of the heart.',
        note: 'Example intention: "I intend to perform ghusl to purify myself from janabah/hayd."',
      ),
      GuideStep(
        title: '2. Rinse the Mouth (Madmadah)',
        description:
            'Take water into the mouth, swirl it around, and spit it out. Ensure water reaches all parts of the mouth.',
      ),
      GuideStep(
        title: '3. Rinse the Nose (Istinshaq)',
        description:
            'Sniff water into the nostrils and blow it out. Ensure water reaches the inner part of the nose.',
      ),
      GuideStep(
        title: '4. Wash the Entire Body',
        description:
            'Pour water over the entire body, ensuring water reaches every part — including the hair roots, behind the ears, navel, underarms, between the toes, and all skin folds.',
        note: 'Every part of the outer body must be reached by water. Missing even a small spot invalidates the ghusl.',
      ),
    ],
  ),
  GuideSection(
    heading: 'The Sunnah Method (Complete Ghusl)',
    steps: [
      GuideStep(
        title: 'Step 1: Make Intention',
        description:
            'Make the intention in your heart to perform ghusl for purification from major impurity.',
      ),
      GuideStep(
        title: 'Step 2: Say Bismillah',
        description: 'Begin with the name of Allah.',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
      ),
      GuideStep(
        title: 'Step 3: Wash Both Hands',
        description:
            'Wash both hands up to the wrists three times, just as in wudu.',
      ),
      GuideStep(
        title: 'Step 4: Wash Private Parts',
        description:
            'Wash the private parts and remove any impurity from the body with the left hand.',
      ),
      GuideStep(
        title: 'Step 5: Perform Wudu',
        description:
            'Perform a complete wudu (ablution) as you would for prayer. You may delay washing your feet until the very end of ghusl.',
        note: 'The Prophet ﷺ would perform wudu in full during his ghusl.',
      ),
      GuideStep(
        title: 'Step 6: Pour Water Over the Head',
        description:
            'Pour water over the head three times, rubbing the roots of the hair to ensure water reaches the scalp. Run fingers through the hair.',
        note: 'Women with thick/braided hair do not need to undo their hair for ghusl from janabah, but should undo it for ghusl from hayd. (Based on hadith of Umm Salamah, Muslim)',
      ),
      GuideStep(
        title: 'Step 7: Wash the Right Side',
        description:
            'Pour water over the right side of the body, ensuring it reaches all parts from the shoulder down. Rub to ensure full coverage.',
      ),
      GuideStep(
        title: 'Step 8: Wash the Left Side',
        description:
            'Pour water over the left side of the body in the same manner.',
      ),
      GuideStep(
        title: 'Step 9: Wash the Feet (if delayed)',
        description:
            'If you delayed washing your feet during wudu, wash them now to complete the ghusl.',
      ),
      GuideStep(
        title: 'Step 10: Ensure Full Coverage',
        description:
            'Check that water has reached every part of the body — hair roots, behind the ears, underarms, navel, between fingers and toes, and all skin folds.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Important Notes',
    steps: [
      GuideStep(
        title: 'Hair for Women',
        description:
            'For ghusl after janabah, a woman does not need to undo her braids or plaits as long as water reaches the roots of the hair. For ghusl after hayd or nifas, the majority recommend undoing braids.',
        arabic: 'إِنَّمَا يَكْفِيكِ أَنْ تَحْثِي عَلَى رَأْسِكِ ثَلَاثَ حَثَيَاتٍ',
        transliteration: 'Innama yakfiki an tahthiy \'ala ra\'siki thalatha hathayat',
        dua: '"It is sufficient for you to pour three handfuls of water on your head." — The Prophet ﷺ to Umm Salamah (Muslim)',
      ),
      GuideStep(
        title: 'Ghusl Is Sufficient for Wudu',
        description:
            'If ghusl is performed properly with the intention of wudu included, a separate wudu is not needed for prayer. The ghusl itself purifies from both major and minor impurity.',
      ),
      GuideStep(
        title: 'What Breaks Ghusl',
        description:
            'Everything that breaks wudu also requires a new wudu after ghusl. However, a new ghusl is only required if one of the causes of janabah, hayd, or nifas occurs again.',
      ),
      GuideStep(
        title: 'Ghusl of Friday (Sunnah)',
        description:
            'It is sunnah to perform ghusl before Friday prayer. The Prophet ﷺ said: "Performing ghusl on Friday is obligatory on every adult Muslim." — This is interpreted as a strong recommendation.',
        arabic: 'غُسْلُ يَوْمِ الْجُمُعَةِ وَاجِبٌ عَلَى كُلِّ مُحْتَلِمٍ',
        note: 'Other recommended times for ghusl: Eid prayers, before Ihram for Hajj/Umrah, and entering Makkah.',
      ),
    ],
  ),
];
