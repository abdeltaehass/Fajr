class Hadith {
  final String text;
  final String narrator;
  final String source;
  final String explanation;

  const Hadith({
    required this.text,
    required this.narrator,
    required this.source,
    required this.explanation,
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
    explanation:
        'This is the first hadith in Imam Al-Bukhari\'s collection and one of the most foundational in Islam. It establishes that the value of every deed lies in its intention. Two people can perform the exact same act, but the one who does it sincerely for Allah earns reward, while the one who does it for worldly gain receives only what he aimed for. This hadith is a reminder to constantly check and purify the intention behind everything we do.',
  ),
  Hadith(
    text:
        'None of you truly believes until he loves for his brother what he loves for himself.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 13, Sahih Muslim 45',
    explanation:
        'This hadith defines the standard of true brotherhood in Islam. Complete faith (iman) is not achieved until a Muslim genuinely wishes good for others as he would for himself. It goes beyond simply avoiding harm — it calls for actively wanting the best for your fellow Muslim in matters of religion and worldly life alike. This selfless concern for others is the foundation of a healthy community.',
  ),
  Hadith(
    text:
        'Whoever believes in Allah and the Last Day, let him speak good or remain silent. Whoever believes in Allah and the Last Day, let him be generous to his neighbor. Whoever believes in Allah and the Last Day, let him be generous to his guest.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6018, Sahih Muslim 47',
    explanation:
        'The Prophet (peace be upon him) connects three practical behaviors to genuine faith. First, guarding the tongue — if what you are about to say is not good, silence is better. Second, honoring the neighbor, which Islam places enormous emphasis on regardless of their religion. Third, hospitality to guests, a deeply valued trait in Islamic culture. These are concrete ways faith manifests in daily life.',
  ),
  Hadith(
    text:
        'A Muslim is the one from whose tongue and hands other Muslims are safe, and a Muhajir (emigrant) is the one who abandons what Allah has forbidden.',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    source: 'Sahih Al-Bukhari 10, Sahih Muslim 40',
    explanation:
        'The Prophet (peace be upon him) redefines what it means to be a true Muslim — not just someone who performs rituals, but someone whose character ensures others feel safe around them. Similarly, true emigration (hijrah) is not merely physical relocation but the spiritual journey of leaving behind sins and forbidden acts. Both definitions point to the inner transformation Islam demands.',
  ),
  Hadith(
    text: 'Do not be angry, and Paradise will be yours.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6116',
    explanation:
        'A man came to the Prophet (peace be upon him) asking for advice, and the Prophet repeated this phrase multiple times. Controlling anger is one of the most difficult struggles but also one of the most rewarded. Anger leads to harmful words and actions that damage relationships and earn sin. By mastering anger, a person demonstrates the self-control that characterizes the people of Paradise.',
  ),
  Hadith(
    text:
        'The strong man is not the one who can overpower others. Rather, the strong man is the one who controls himself when he is angry.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6114, Sahih Muslim 2609',
    explanation:
        'The Prophet (peace be upon him) redefines strength away from physical power toward emotional and spiritual discipline. Anyone can lash out in anger, but it takes real strength to hold back, control your words, and respond with wisdom. This hadith teaches that the greatest battles we fight are within ourselves, and the greatest victories are over our own impulses.',
  ),
  Hadith(
    text:
        'Allah does not look at your bodies or your forms, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
    explanation:
        'This hadith dismantles superficial judgments. Allah does not evaluate people based on physical appearance, wealth, or social status. What matters is the state of the heart — its sincerity, its devotion, its purity — and the deeds that flow from it. This is a powerful equalizer: no one has an advantage before Allah except through genuine faith and righteous action.',
  ),
  Hadith(
    text:
        'Part of the perfection of one\'s Islam is his leaving that which does not concern him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Jami At-Tirmidhi 2317',
    explanation:
        'This hadith encourages Muslims to focus on what is truly important and avoid meddling in affairs that do not concern them. Gossip, excessive curiosity about others\' private matters, and unnecessary involvement in disputes all distract from one\'s own spiritual growth. A perfected Islam means a focused, purposeful life where energy is spent on what benefits oneself and others.',
  ),
  Hadith(
    text:
        'Whoever follows a path in pursuit of knowledge, Allah will make easy for him a path to Paradise.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
    explanation:
        'Islam places enormous value on seeking knowledge, especially religious knowledge. The "path" here can be literal (traveling to study) or figurative (dedicating time and effort to learn). Allah rewards the sincere seeker by smoothing their journey to Paradise — both by making further knowledge accessible and by counting the effort itself as worship.',
  ),
  Hadith(
    text: 'The best of you are those who learn the Quran and teach it.',
    narrator: 'Narrated by Uthman ibn Affan (RA)',
    source: 'Sahih Al-Bukhari 5027',
    explanation:
        'The Quran is the word of Allah and the primary source of guidance in Islam. Learning it — memorizing, understanding, and reflecting on its meanings — is one of the noblest pursuits. But the hadith goes further: teaching it to others multiplies the reward. The best Muslims are those who both internalize the Quran and pass it on, creating a chain of guidance that benefits generations.',
  ),
  Hadith(
    text:
        'Make things easy and do not make them difficult, cheer people up and do not drive them away.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 69, Sahih Muslim 1734',
    explanation:
        'The Prophet (peace be upon him) sent Muadh and Abu Musa to Yemen with this instruction. It reflects a core principle of Islamic teaching and leadership: facilitate, don\'t complicate. Whether in giving religious advice, leading a community, or raising children, the approach should be one of encouragement, ease, and positivity — not harshness that pushes people away from the faith.',
  ),
  Hadith(
    text:
        'The most beloved of deeds to Allah are the most consistent of them, even if they are few.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Al-Bukhari 6464, Sahih Muslim 783',
    explanation:
        'Allah values consistency over intensity. A small act of worship performed every day — even just a few minutes of Quran recitation or a brief supplication — is more beloved than a grand act done once and then abandoned. This hadith takes the pressure off trying to do everything at once and encourages building sustainable habits of worship that last a lifetime.',
  ),
  Hadith(
    text:
        'When a man dies, his deeds come to an end except for three things: ongoing charity, beneficial knowledge, or a righteous child who prays for him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 1631',
    explanation:
        'Death cuts off all ability to earn reward — except through three channels that continue to generate good deeds after one passes. Ongoing charity (sadaqah jariyah) includes things like building a well, a mosque, or funding education. Beneficial knowledge means anything you taught or shared that continues to help others. A righteous child who makes dua for you is the fruit of good parenting. These three encourage investing in things with lasting impact.',
  ),
  Hadith(
    text:
        'The best among you is the one who is best to his family, and I am the best among you to my family.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Jami At-Tirmidhi 3895',
    explanation:
        'Character is first tested at home. It\'s easy to be kind and patient with strangers, but the true measure of a person is how they treat their family — spouse, children, and parents. The Prophet (peace be upon him) led by example, helping with household chores, being playful with his wives, and showing affection. This hadith sets the standard: the best Muslim is the best family member.',
  ),
  Hadith(
    text:
        'He who is not merciful to others, will not be treated mercifully.',
    narrator: 'Narrated by Jarir ibn Abdullah (RA)',
    source: 'Sahih Al-Bukhari 7376, Sahih Muslim 2319',
    explanation:
        'Mercy is reciprocal. Allah\'s mercy toward us is connected to our mercy toward others — people, animals, and all of creation. Someone who is hard-hearted, cruel, or indifferent to the suffering of others cannot expect to receive Allah\'s mercy on the Day of Judgment. This hadith motivates compassion in every interaction and reminds us that how we treat others shapes how we will be treated.',
  ),
  Hadith(
    text:
        'Smiling in the face of your brother is charity. Enjoining what is good and forbidding what is evil is charity. Guiding a man who has lost his way is charity.',
    narrator: 'Narrated by Abu Dharr (RA)',
    source: 'Jami At-Tirmidhi 1956',
    explanation:
        'Charity in Islam is not limited to giving money. Even the simplest act of kindness — a genuine smile — counts as charity before Allah. This hadith broadens the concept of sadaqah to include every positive interaction: offering guidance, encouraging good, discouraging harm, and being warm and approachable. It shows that everyone, regardless of wealth, can be generous.',
  ),
  Hadith(
    text:
        'The believer is not one who eats his fill while his neighbor is hungry.',
    narrator: 'Narrated by Ibn Abbas (RA)',
    source: 'Al-Adab Al-Mufrad 112',
    explanation:
        'This hadith highlights the social responsibility that comes with faith. A true believer cannot ignore the needs of those around them. If your neighbor is going hungry while you eat comfortably, something is wrong with your faith. Islam creates a community where people look out for each other, and this hadith is a wake-up call against selfishness and indifference.',
  ),
  Hadith(
    text:
        'Be in this world as if you were a stranger or a traveler along a path.',
    narrator: 'Narrated by Abdullah ibn Umar (RA)',
    source: 'Sahih Al-Bukhari 6416',
    explanation:
        'This profound advice puts worldly life in perspective. A traveler does not get too attached to the places they pass through — they take what they need and move on. Similarly, a Muslim should not become so absorbed in worldly pleasures and possessions that they forget the ultimate destination: the Hereafter. This mindset helps maintain focus on what truly matters and reduces anxiety over temporary losses.',
  ),
  Hadith(
    text:
        'Richness is not having many possessions. Rather, true richness is the richness of the soul.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6446, Sahih Muslim 1051',
    explanation:
        'The Prophet (peace be upon him) redefines wealth. A person with vast possessions but a heart full of greed and dissatisfaction is truly poor, while someone with little but a content heart is truly rich. Contentment (qana\'ah) is a treasure that money cannot buy. This hadith encourages gratitude for what you have rather than constantly chasing more.',
  ),
  Hadith(
    text:
        'Verily, Allah does not look at your appearance or your wealth, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
    explanation:
        'A reinforcement of the principle that outward appearances are meaningless to Allah. Society may judge by looks, status, and bank accounts, but Allah judges by what is in the heart — sincerity, humility, love, and fear of Him — and by the actions those inner qualities produce. This is deeply liberating: your worth before Allah depends on things entirely within your control.',
  ),
  Hadith(
    text:
        'Take advantage of five before five: your youth before your old age, your health before your illness, your wealth before your poverty, your free time before your busyness, and your life before your death.',
    narrator: 'Narrated by Ibn Abbas (RA)',
    source: 'Shu\'ab Al-Iman 10248',
    explanation:
        'This hadith is a powerful call to action. Every blessing we enjoy is temporary and can be taken away at any moment. Youth fades, health deteriorates, wealth can vanish, free time disappears, and life itself ends. The wise person uses each of these blessings for worship, good deeds, and preparation for the Hereafter before the opportunity passes forever.',
  ),
  Hadith(
    text:
        'The supplication between the adhan and the iqamah is not rejected.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Jami At-Tirmidhi 212',
    explanation:
        'The time between the call to prayer (adhan) and the start of the prayer (iqamah) is a special window when supplications are accepted. This is one of the best times to ask Allah for anything — forgiveness, guidance, health, provision, or any need. The hadith encourages Muslims to use this brief window wisely rather than letting it pass in idle talk.',
  ),
  Hadith(
    text:
        'Whoever says SubhanAllah wa bihamdihi one hundred times a day will have his sins forgiven even if they were like the foam of the sea.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6405, Sahih Muslim 2691',
    explanation:
        'A remarkably simple act with an extraordinary reward. Saying "SubhanAllah wa bihamdihi" (Glory and praise be to Allah) one hundred times takes only a few minutes but can erase a lifetime of minor sins. The comparison to sea foam emphasizes the vastness of sins that can be forgiven through this easy yet powerful remembrance. It shows Allah\'s generosity in rewarding small, consistent acts of worship.',
  ),
  Hadith(
    text:
        'The two words most beloved to the Most Merciful are: SubhanAllahi wa bihamdihi, SubhanAllahil Adheem (Glory and praise be to Allah, Glory be to Allah the Almighty).',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 7563, Sahih Muslim 2694',
    explanation:
        'These two phrases are described as light on the tongue, heavy on the scales (of good deeds), and beloved to the Most Merciful. Despite being easy to say, they carry immense spiritual weight. They combine glorification of Allah (declaring Him free of imperfection) with praise. Making these a regular part of your daily remembrance is one of the simplest ways to earn Allah\'s love and fill your scales with good deeds.',
  ),
  Hadith(
    text: 'A good word is charity.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 2989, Sahih Muslim 1009',
    explanation:
        'Even a kind, encouraging, or comforting word carries the reward of charity. Words have power — they can heal, inspire, and bring joy. The Prophet (peace be upon him) teaches that you don\'t need money to be charitable. A sincere compliment, a word of encouragement to someone struggling, or even saying "Bismillah" are all forms of giving that Allah rewards.',
  ),
  Hadith(
    text:
        'Whoever removes a worldly hardship from a believer, Allah will remove from him one of the hardships of the Day of Resurrection.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
    explanation:
        'This hadith establishes a divine principle of reciprocity. When you help relieve someone\'s difficulty — whether financial, emotional, or practical — Allah will relieve your difficulties on the most terrifying day: the Day of Judgment. This powerful incentive encourages Muslims to actively look for ways to help others, knowing that every act of relief will be returned to them when they need it most.',
  ),
  Hadith(
    text:
        'The best of people are those who are most beneficial to people.',
    narrator: 'Narrated by Jabir (RA)',
    source: 'Al-Mu\'jam Al-Awsat 5787',
    explanation:
        'This concise hadith establishes a simple ranking system: the best person is the most useful to others. It shifts the focus from personal worship alone to community impact. A Muslim should strive not only to perfect their own relationship with Allah but to be a source of benefit — through knowledge, service, charity, emotional support, or any form of help — to the people around them.',
  ),
  Hadith(
    text: 'Modesty brings nothing but goodness.',
    narrator: 'Narrated by Imran ibn Husayn (RA)',
    source: 'Sahih Al-Bukhari 6117, Sahih Muslim 37',
    explanation:
        'Modesty (haya\') in Islam encompasses shyness from doing wrong, humility, and a sense of shame that prevents a person from behaving inappropriately. The Prophet (peace be upon him) declares that this quality only produces positive outcomes — it protects from sin, earns respect, and draws one closer to Allah. It is considered a branch of faith and a distinguishing trait of a believer.',
  ),
  Hadith(
    text:
        'The most complete of the believers in faith is the one with the best character among them. And the best of you are those who are best to their women.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Jami At-Tirmidhi 1162',
    explanation:
        'Faith and character are inseparable in Islam. The most complete believer is not necessarily the one who prays the most but the one with the best manners and conduct. The hadith then singles out treatment of women as a key indicator — how a man treats his wife reflects his true character. This was revolutionary guidance that elevated the status of women and made kindness to them a measure of faith.',
  ),
  Hadith(
    text:
        'Allah is gentle and loves gentleness. He gives for gentleness what He does not give for harshness, nor for anything else.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Muslim 2593',
    explanation:
        'Gentleness is not weakness — it is a divine attribute that Allah loves to see in His servants. This hadith teaches that a gentle approach achieves results that force and harshness never can. Whether in teaching, parenting, resolving conflicts, or giving advice, gentleness opens hearts and minds. Allah specifically rewards gentleness with blessings that are not accessible through any other approach.',
  ),
];
