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
  Hadith(
    text: 'None of you truly believes until he loves for his brother what he loves for himself.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 13, Sahih Muslim 45',
    explanation: 'True faith demands that we extend the same goodwill to others that we desire for ourselves. This hadith is a cornerstone of Islamic brotherhood and social ethics. It means wishing good health, happiness, provision, and guidance for every fellow believer just as one wishes it for oneself. This mindset eliminates envy, rivalry, and selfishness, replacing them with genuine love and solidarity.',
  ),
  Hadith(
    text: 'Smiling at your brother is an act of charity.',
    narrator: 'Narrated by Abu Dharr (RA)',
    source: 'Jami At-Tirmidhi 1956',
    explanation: 'In Islam, even the smallest kind act carries weight. A smile costs nothing yet communicates warmth, acceptance, and love. The Prophet (peace be upon him) elevated this simple gesture to the level of sadaqah — charitable giving. This teaches that charity is not only financial; every positive interaction with a fellow human being is rewarded by Allah.',
  ),
  Hadith(
    text: 'The strong person is not the one who can wrestle others down. The strong person is the one who controls himself when he is angry.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6114',
    explanation: 'Physical strength is admirable but spiritual strength — specifically controlling anger — is the true measure of character. Anger, if unchecked, leads to broken relationships, regretted words, and harmful actions. The Prophet (peace be upon him) redefined strength for the Muslim: it is not domination over others but mastery over the self. Controlling anger is one of the hardest and most rewarded spiritual disciplines.',
  ),
  Hadith(
    text: 'Do not be angry, and Paradise is yours.',
    narrator: 'Narrated by a man who came to the Prophet (PBUH)',
    source: 'Al-Mu\'jam Al-Awsat 2374, graded Sahih',
    explanation: 'A man asked the Prophet (peace be upon him) for brief advice that would lead him to Paradise. The Prophet repeated "Do not be angry" three times. This is among the most concentrated pieces of wisdom in all of hadith literature. Anger is the root of countless sins — injustice, cruelty, broken oaths, harming others. Mastering anger effectively guards the door to most major transgressions.',
  ),
  Hadith(
    text: 'Whoever believes in Allah and the Last Day should speak good or remain silent.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6018, Sahih Muslim 47',
    explanation: 'Speech is powerful — it can build or destroy. A person of faith understands that words carry consequences not only in this life but before Allah on the Day of Judgment. This hadith establishes a simple rule: if what you are about to say is beneficial, say it. If not, silence is better. This principle alone, if applied consistently, would eliminate backbiting, slander, rumour, hurtful jokes, and idle talk.',
  ),
  Hadith(
    text: 'Make things easy, do not make them difficult. Give glad tidings, do not push people away.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 69',
    explanation: 'This was the guiding principle the Prophet (peace be upon him) taught his companions when sending them as teachers and governors. Islam is a religion of ease — Allah says in the Quran, "Allah intends ease for you and does not intend hardship." Preachers, scholars, and leaders are reminded that their role is to invite people closer to faith, not to repel them with excessive strictness or harsh judgments.',
  ),
  Hadith(
    text: 'Every act of kindness is a charity.',
    narrator: 'Narrated by Jabir ibn Abdullah (RA)',
    source: 'Sahih Al-Bukhari 2989, Sahih Muslim 1005',
    explanation: 'This hadith liberates the concept of charity from its narrow financial meaning. Every kind word, helpful gesture, patient listening, or supportive action is counted as sadaqah — charity — by Allah. This means that every day holds countless opportunities to earn the reward of giving, regardless of one\'s financial means. A Muslim who internalises this lives in a constant state of giving.',
  ),
  Hadith(
    text: 'Whoever removes a worldly hardship from a believer, Allah will remove one of the hardships of the Day of Resurrection from him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
    explanation: 'This profound hadith establishes a direct divine exchange: relieving another person\'s suffering in this world earns relief from the terrors of the Day of Judgment. Whether it is helping someone with debt, solving a problem, offering comfort, or fulfilling a need — every act of relief carries cosmic weight. It demonstrates that service to creation is inseparable from worship of the Creator.',
  ),
  Hadith(
    text: 'The most beloved of deeds to Allah is that which is most consistent, even if it is small.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Al-Bukhari 6464, Sahih Muslim 782',
    explanation: 'Quality and consistency outweigh quantity in the sight of Allah. A person who prays two rak\'ahs every night without fail is more beloved to Allah than one who prays a hundred rak\'ahs once and then abandons the practice. This hadith encourages sustainable worship — building habits that fit one\'s capacity and maintaining them throughout life, rather than overwhelming bursts of devotion that cannot be sustained.',
  ),
  Hadith(
    text: 'Tie your camel first, then put your trust in Allah.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Jami At-Tirmidhi 2517',
    explanation: 'A man asked the Prophet (peace be upon him) whether he should tie his camel or leave it untied and trust in Allah. The Prophet told him to tie it first and then trust Allah. This hadith establishes the Islamic balance between tawakkul (reliance on Allah) and taking practical measures. True tawakkul is not passivity or neglect — it means doing everything in one\'s power and then surrendering the outcome to Allah.',
  ),
  Hadith(
    text: 'The dua of a Muslim for his brother in his absence will be answered. At his head there is an angel, and every time he prays for good for his brother, the angel says: Ameen, and may the same be for you.',
    narrator: 'Narrated by Abu Ad-Darda (RA)',
    source: 'Sahih Muslim 2733',
    explanation: 'This hadith reveals a beautiful dynamic in sincere supplication for others. When you pray for a fellow Muslim in their absence — genuinely, without expectation of praise — an angel responds by granting you the very same thing you asked for your brother. It is an incentive to make dua for others generously, as each supplication for a fellow believer returns as a blessing upon oneself.',
  ),
  Hadith(
    text: 'Allah does not look at your forms and wealth, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
    explanation: 'This hadith is a direct reassurance for those who feel inadequate in worldly measures. Allah\'s evaluation has nothing to do with physical appearance, beauty, status, or wealth. What He examines is the heart — its sincerity, its love for Him, its compassion for others — and the deeds that flow from it. This equalises all people before Allah and focuses the believer on what truly matters.',
  ),
  Hadith(
    text: 'Verily, with hardship comes ease.',
    narrator: 'From the Quran, Chapter 94:5-6',
    source: 'Quran 94:5-6',
    explanation: 'Allah repeats this verse twice consecutively in Surah Ash-Sharh. The Arabic grammatical structure implies that the one hardship (definite article) corresponds to two eases. Islamic scholars note this means no matter what difficulty a believer faces, ease accompanies it — or follows very shortly. This verse is a source of immense comfort for the Muslim in times of pain, reminding them that hardship and relief are inseparable companions.',
  ),
  Hadith(
    text: 'No fatigue, nor disease, nor sorrow, nor sadness, nor hurt, nor distress befalls a Muslim, even if it were the prick he receives from a thorn — but that Allah expiates some of his sins for that.',
    narrator: 'Narrated by Abu Hurairah and Abu Sa\'id (RA)',
    source: 'Sahih Al-Bukhari 5641, Sahih Muslim 2573',
    explanation: 'Every form of suffering a Muslim endures — physical, emotional, social — is not wasted. Allah transforms pain into purification, erasing sins with every difficulty. This is one of the most comforting teachings in Islam for those going through illness, grief, anxiety, or hardship. It reframes suffering as a mercy and a means of drawing closer to Allah rather than punishment or abandonment.',
  ),
  Hadith(
    text: 'Whoever is not grateful to people is not grateful to Allah.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sunan Abu Dawud 4811',
    explanation: 'Gratitude in Islam has two dimensions: thankfulness to Allah and thankfulness to people who serve as instruments of His blessings. The Prophet (peace be upon him) linked the two — a person who habitually ignores human kindness reveals a heart that is ungrateful by nature, and such a heart will also fail in gratitude to Allah. This teaches the Muslim to be generous with acknowledgment, appreciation, and thanks.',
  ),
  Hadith(
    text: 'Charity does not decrease wealth.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2588',
    explanation: 'This statement from the Prophet (peace be upon him) directly challenges the fear of poverty that holds many people back from giving. Allah promises that genuine charity causes barakah — divine blessing — to increase what one has, whether in actual wealth, health, time, or contentment. This is a matter of faith: trusting that what one gives for Allah\'s sake comes back multiplied in ways that money alone cannot measure.',
  ),
  Hadith(
    text: 'Feed the hungry, visit the sick, and free the captive.',
    narrator: 'Narrated by Abu Musa Al-Ash\'ari (RA)',
    source: 'Sahih Al-Bukhari 5649',
    explanation: 'This brief hadith outlines three pillars of social responsibility in Islam: feeding those who are hungry addresses physical need, visiting the sick addresses emotional and social need, and freeing captives (through ransom or advocacy) addresses freedom and justice. Together, they form a picture of the compassionate, active Muslim who serves society — not just worshipping Allah in isolation but working for the welfare of all around them.',
  ),
  Hadith(
    text: 'The believer who mixes with people and bears their harm with patience is better than the believer who does not mix with people and does not bear their harm.',
    narrator: 'Narrated by Ibn Umar (RA)',
    source: 'Jami At-Tirmidhi 2507',
    explanation: 'Isolation from society may seem like a path to spiritual purity, but this hadith teaches otherwise. The believer who engages with people — despite the inevitable friction, misunderstandings, and hurt — and remains patient and upright earns a higher station than the recluse. Islam calls its followers to engage with the world, serve others, and exercise patience through social challenges. Patience within community is a form of worship.',
  ),
  Hadith(
    text: 'A Muslim is one from whose tongue and hand the Muslims are safe.',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    source: 'Sahih Al-Bukhari 10',
    explanation: 'The Prophet (peace be upon him) defined the baseline of being a good Muslim: not causing harm. "Tongue" refers to verbal harm — insults, backbiting, lies, false accusations. "Hand" refers to physical harm. A Muslim community should be a place of safety where every member feels secure from their brothers and sisters. Before achieving excellence in worship, one must first ensure they are not a source of injury to others.',
  ),
  Hadith(
    text: 'Whoever has wronged his brother — let him go to him and seek his forgiveness today before there is no dinar and no dirham.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 2449',
    explanation: 'On the Day of Judgment, the currency of forgiveness is good deeds, not money. If someone has wronged another and not been forgiven, their good deeds will be transferred to the wronged person — and if they run out, the wronged person\'s sins will be given to them. This serious consequence is why the Prophet (peace be upon him) urged resolving disputes and seeking forgiveness immediately, in this world, while there is still time.',
  ),
  Hadith(
    text: 'Pay the worker his wages before his sweat dries.',
    narrator: 'Narrated by Ibn Umar (RA)',
    source: 'Sunan Ibn Majah 2443',
    explanation: 'This hadith establishes a prophetic standard for workplace justice and economic ethics. Workers deserve prompt, fair compensation for their labour. Delaying payment is considered a form of oppression in Islam. This principle protects the vulnerable — those who depend on wages to meet their basic needs — and holds employers accountable. Islamic economics is built on a foundation of fairness and immediate fulfilment of obligations.',
  ),
  Hadith(
    text: 'The worldly life is a prison for the believer and a paradise for the disbeliever.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2956',
    explanation: 'The believer lives by constraints — halal and haram, obligations and boundaries — that restrict worldly freedom. To the believer, this world feels like a temporary holding place compared to the infinite freedom of Paradise. For those who live only for this world, these same constraints do not exist, and they experience this life as their ultimate paradise. This hadith reminds the believer not to be deceived by the apparent freedom of those who reject Allah\'s guidance.',
  ),
  Hadith(
    text: 'Allah is Beautiful and He loves beauty.',
    narrator: 'Narrated by Abdullah ibn Mas\'ud (RA)',
    source: 'Sahih Muslim 91',
    explanation: 'This hadith came in the context of a man who said he loves wearing nice clothes and beautiful shoes. The Prophet (peace be upon him) clarified that arrogance — not beauty — is what is condemned. Allah Himself possesses divine beauty and is drawn to it in His creation. A Muslim may appreciate and care for beauty in appearance, surroundings, and creation, as long as it is not accompanied by pride. It also encourages presenting oneself and one\'s worship in the best possible manner.',
  ),
  Hadith(
    text: 'Seek knowledge from the cradle to the grave.',
    narrator: 'Attributed to the Prophet Muhammad (PBUH)',
    source: 'Widely cited in Islamic scholarship',
    explanation: 'Learning has no age limit in Islam. From birth to death, every Muslim is expected to pursue knowledge — not only religious knowledge but all that benefits humanity. This lifelong commitment to learning was reflected in the Islamic Golden Age when Muslim scholars pioneered medicine, mathematics, astronomy, and philosophy. The seeking of knowledge is an act of worship; every step taken in pursuit of it is rewarded by Allah.',
  ),
  Hadith(
    text: 'Whoever follows a path to seek knowledge, Allah will make easy for him a path to Paradise.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2699',
    explanation: 'The pursuit of knowledge is one of the most direct routes to Paradise according to this hadith. This applies to religious knowledge above all, but the spirit encompasses all beneficial learning. Allah eases the journey — not just to knowledge, but to the ultimate destination. This encourages every Muslim, student or adult, to never stop learning and to trust that their efforts in seeking knowledge are seen and rewarded.',
  ),
  Hadith(
    text: 'The best of you are those who learn the Quran and teach it.',
    narrator: 'Narrated by Uthman ibn Affan (RA)',
    source: 'Sahih Al-Bukhari 5027',
    explanation: 'Among all forms of Islamic learning and teaching, engaging with the Quran holds the highest rank. This hadith is a direct invitation to study the Quran deeply — its words, meanings, rulings, and wisdom — and then pass that knowledge on to others. The dual emphasis on learning and teaching captures the ideal of knowledge: it should never stay locked within one person but should flow outward to benefit the entire community.',
  ),
  Hadith(
    text: 'Recite the Quran, for it will come as an intercessor for its people on the Day of Resurrection.',
    narrator: 'Narrated by Abu Umama Al-Bahili (RA)',
    source: 'Sahih Muslim 804',
    explanation: 'The Quran is not just a book to be read — it is a living advocate for those who recite and live by it. On the Day of Judgment, when every person will desperately need intercession, the Quran will stand up for those who devoted themselves to it and plead on their behalf before Allah. This gives every recitation a weight beyond its immediate spiritual value — it is an investment in protection and intercession for the ultimate day.',
  ),
  Hadith(
    text: 'The one who is proficient in reciting the Quran will be with the noble, righteous scribes (angels), and the one who recites but finds it difficult — for them there are two rewards.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Al-Bukhari 4937, Sahih Muslim 798',
    explanation: 'No Muslim should feel discouraged about reciting the Quran due to difficulty in pronunciation or fluency. The fluent reciter earns a high station alongside noble angels. But the one who struggles — who must work hard, repeat, and push through — actually earns double the reward: one for reciting and one for the effort and perseverance. This hadith makes the Quran accessible to every level of ability.',
  ),
  Hadith(
    text: 'Whoever among you sees an evil, let him change it with his hand; if he cannot, then with his tongue; if he cannot, then with his heart — and that is the weakest of faith.',
    narrator: 'Narrated by Abu Sa\'id Al-Khudri (RA)',
    source: 'Sahih Muslim 49',
    explanation: 'This hadith outlines the three-tiered obligation to oppose wrongdoing. Physical intervention (changing with the hand) applies when one has authority and power to do so safely. If not, speaking out against wrong is obligatory. If that is also impossible, at minimum the heart must reject it. The hadith warns that a heart that has become completely indifferent to evil — that feels no discomfort — is a sign of seriously weakened faith.',
  ),
  Hadith(
    text: 'The halal is clear and the haram is clear, and between them are doubtful matters. Whoever avoids doubtful matters has protected his religion and his honour.',
    narrator: 'Narrated by An-Nu\'man ibn Bashir (RA)',
    source: 'Sahih Al-Bukhari 52, Sahih Muslim 1599',
    explanation: 'Life presents countless grey areas where it is unclear whether something is permitted or forbidden. The Prophet (peace be upon him) advises a precautionary approach: when in doubt, stay away. This is known as wara\' — scrupulousness — and it protects the Muslim from gradually slipping from grey areas into clear haram. Like a shepherd keeping his flock from the edge of a forbidden pasture, the wise believer keeps a safe distance from boundaries.',
  ),
  Hadith(
    text: 'Be in this world as though you were a stranger or a traveller.',
    narrator: 'Narrated by Ibn Umar (RA)',
    source: 'Sahih Al-Bukhari 6416',
    explanation: 'A traveller does not accumulate excessive possessions because they know they are passing through. They focus on reaching their destination. The Prophet (peace be upon him) used this metaphor to describe the proper attitude toward worldly life: take only what you need, do not let the world grip your heart, and keep your focus on the destination — the eternal life. This worldview liberates the believer from the anxiety of materialism.',
  ),
  Hadith(
    text: 'Hayaa (modesty/shyness) is a branch of faith.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 9, Sahih Muslim 35',
    explanation: 'In a longer hadith, the Prophet (peace be upon him) enumerated the branches of faith — among them is hayaa. Hayaa is a multidimensional concept: shyness, modesty, a sense of shame that prevents indecent or harmful behaviour. It is the internal guardian of moral conduct. The hadith connects outward modesty to inner faith — someone with genuine taqwa will naturally develop hayaa as a protective instinct against what Allah dislikes.',
  ),
  Hadith(
    text: 'Make use of five before five: your youth before your old age, your health before your illness, your wealth before your poverty, your free time before you are occupied, and your life before your death.',
    narrator: 'Narrated by Ibn Abbas (RA)',
    source: 'Mustadrak Al-Hakim 7846, graded Sahih',
    explanation: 'This is one of the most practical pieces of wisdom in the prophetic tradition. Each of the five pairs highlights a resource that is abundant now but may be scarce or entirely gone in the future. Youth fades, health breaks, wealth disappears, time fills up, and life ends. The wise Muslim does not procrastinate — they worship, serve, give, learn, and strive while they still have the capacity to do so.',
  ),
  Hadith(
    text: 'The son of Adam grows old but two things grow young with him: love of wealth and love of long life.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 6421',
    explanation: 'As a person ages, most desires naturally diminish — but two grow stronger: the craving for more money and the desperate wish to live longer. This is a profound observation about human psychology. Old men often hoard wealth they will never use and cling to life even past its blessing. The hadith warns the believer to guard against these twin attachments, which can prevent generosity and acceptance of Allah\'s will.',
  ),
  Hadith(
    text: 'A good word is charity.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 2989',
    explanation: 'Words of comfort, encouragement, truth, and kindness are classified as charitable giving. This transforms everyday speech into an act of worship and service. Every time a Muslim comforts a grieving friend, speaks honestly to protect someone from harm, teaches something beneficial, or gives sincere advice — it counts as sadaqah. This removes the barrier between the wealthy and the poor in the realm of charity: everyone has words.',
  ),
  Hadith(
    text: 'Convey from me, even if it is one verse.',
    narrator: 'Narrated by Abdullah ibn Amr (RA)',
    source: 'Sahih Al-Bukhari 3461',
    explanation: 'The Prophet (peace be upon him) placed no minimum threshold on sharing Islamic knowledge. Even a single verse of Quran, a single hadith, or a single truth of Islam shared with another person carries the obligation and reward of conveying the message. This democratises the role of the preacher — every Muslim, regardless of scholarship level, has a responsibility and an opportunity to share what they know for the sake of Allah.',
  ),
  Hadith(
    text: 'The most truthful of names are Harith (one who earns/cultivates) and Hammam (one who strives).',
    narrator: 'Narrated by Abu Wahb Al-Jushami (RA)',
    source: 'Sunan Abu Dawud 4950',
    explanation: 'The Prophet (peace be upon him) pointed out that these two names capture the essential nature of every human being: we are all striving and earning creatures. No human simply exists passively — every person is either working toward something, striving for a goal. This hadith encourages the Muslim to direct their natural striving toward the right objectives: earning in halal ways and striving for the pleasure of Allah.',
  ),
  Hadith(
    text: 'None of you should wish for death because of some harm that has come to him. If he must do something, let him say: O Allah, keep me alive as long as life is good for me, and take me when death is better for me.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 5671, Sahih Muslim 2680',
    explanation: 'This hadith addresses moments of despair when the pain of life makes death seem preferable. The Prophet (peace be upon him) does not dismiss the feeling — he acknowledges it — but redirects it. Instead of wishing for death, a believer entrusts the decision to Allah. The supplication he teaches is a beautiful exercise in surrender: acknowledging that only Allah knows whether life or death is better for us at any given moment.',
  ),
  Hadith(
    text: 'Verily, Allah does not look at your bodies, nor at your faces, but He looks at your hearts and your deeds.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 2564',
    explanation: 'This reassurance from the Prophet (peace be upon him) levels the spiritual playing field. Physical beauty, appearance, age, or disability mean nothing in Allah\'s assessment. What matters is the sincerity of the heart and the goodness of deeds. This teaching liberates Muslims from obsession with outward appearances and redirects attention to inner development — purifying intentions, cultivating love for Allah, and acting with kindness and justice.',
  ),
  Hadith(
    text: 'The world is sweet and green, and Allah is going to make you successors in it and will see what you do.',
    narrator: 'Narrated by Abu Sa\'id Al-Khudri (RA)',
    source: 'Sahih Muslim 2742',
    explanation: 'The Prophet (peace be upon him) used the metaphor of a sweet and visually appealing world to describe its seduction. He then warned that humanity has been entrusted as stewards — not owners — of this world. Allah is watching how we use this trust. This hadith calls for responsible stewardship: of wealth, power, family, community, and the earth itself. The Muslim is a trustee who will be held accountable for their management.',
  ),
  Hadith(
    text: 'Whoever loves to meet Allah, Allah loves to meet him.',
    narrator: 'Narrated by Ubada ibn As-Samit (RA)',
    source: 'Sahih Al-Bukhari 6507, Sahih Muslim 2683',
    explanation: 'This hadith describes an anticipatory longing for Allah that the believer develops as their faith deepens. Meeting Allah — the ultimate reunion after a life of worship — is described as something the believer should look forward to, not fear. When a person genuinely longs to stand before Allah in joy rather than terror, it indicates that they have built a genuine loving relationship with Him through prayer, obedience, gratitude, and reliance.',
  ),
  Hadith(
    text: 'Cleanliness is half of faith.',
    narrator: 'Narrated by Abu Malik Al-Ashari (RA)',
    source: 'Sahih Muslim 223',
    explanation: 'Physical cleanliness is elevated to a matter of faith in Islam. The hadith encompasses ritual purity (wudu, ghusl), cleanliness of body and clothing, and by extension the cleanliness of environment. Scholars also interpret it to include spiritual purity — purifying the heart from sin, envy, and arrogance. Islam views body and soul as connected: a Muslim who maintains physical cleanliness is also cultivating the discipline necessary for spiritual purity.',
  ),
  Hadith(
    text: 'The reward of deeds depends upon the intentions, and every person will get the reward according to what he has intended.',
    narrator: 'Narrated by Umar ibn Al-Khattab (RA)',
    source: 'Sahih Al-Bukhari 1, Sahih Muslim 1907',
    explanation: 'This is the very first hadith of Imam Al-Bukhari\'s collection and perhaps the most fundamental principle in Islamic ethics. The same physical act — praying, fasting, giving — can earn immense reward or no reward at all depending on what it is done for. A prayer performed to impress others earns no divine reward. This hadith demands constant self-examination: why am I really doing this? It is the foundation of sincerity (ikhlas) in Islam.',
  ),
  Hadith(
    text: 'Part of the perfection of a person\'s Islam is leaving what does not concern him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Jami At-Tirmidhi 2317, graded Hasan',
    explanation: 'A spiritually mature Muslim knows the value of minding one\'s own affairs. Unnecessary involvement in others\' matters — gossip, unsolicited opinions, prying into people\'s personal lives — wastes time, generates conflict, and often leads to sin. By limiting engagement to what genuinely concerns them, a believer protects their time, preserves relationships, and demonstrates the maturity of their faith. This is also the foundation of a peaceful, functional community.',
  ),
  Hadith(
    text: 'Your Lord is amazed by a young man who has no passion for folly.',
    narrator: 'Narrated by Uqba ibn Amir (RA)',
    source: 'Musnad Ahmad 17410, graded Sahih',
    explanation: 'Youth is typically associated with recklessness, desire, and rebellion against limits. When a young person — in the height of their energy and passion — chooses piety over indulgence, Allah\'s pleasure is immense. This hadith specifically honours young believers who resist the distractions and temptations of their age. It is a powerful encouragement to Muslim youth: the very quality others might mock you for — your discipline and worship — is causing Allah to speak of you with admiration.',
  ),
  Hadith(
    text: 'If you were to rely on Allah as He should be relied upon, He would provide for you as He provides for the birds — they go out hungry in the morning and return full in the evening.',
    narrator: 'Narrated by Umar ibn Al-Khattab (RA)',
    source: 'Jami At-Tirmidhi 2344, graded Hasan',
    explanation: 'True reliance on Allah does not mean passivity — the bird still leaves the nest and searches for food. But the bird does not hoard, does not worry all night, and does not fear the future. It acts, then trusts. This hadith describes the quality of tawakkul that leads to guaranteed provision from Allah: full effort paired with complete trust. The result is the kind of certainty and contentment that transcends circumstances.',
  ),
  Hadith(
    text: 'Allah the Almighty said: I am as My servant thinks of Me. I am with him when he remembers Me.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 7405, Sahih Muslim 2675',
    explanation: 'This hadith qudsi reveals a profound truth: your experience of Allah reflects how you think of Him. If you approach Allah with hope and positive expectation, that is how He will meet you. If you come to Him in despair and doubt, you block the very mercy you are seeking. Allah promises to be exactly what His servant expects of Him. This is a call to consciously cultivate a good opinion of Allah — especially in hardship, when it is hardest to do so.',
  ),
  Hadith(
    text: 'Take care of the prayer, and take care of the prayer, and take care of the prayer, and whatever your right hand possesses.',
    narrator: 'Last words of the Prophet Muhammad (PBUH)',
    source: 'Sunan Ibn Majah 2698, Sunan Abu Dawud 5156',
    explanation: 'Among the last words the Prophet (peace be upon him) uttered on his deathbed was this triple emphasis on prayer and the rights of those under one\'s care. That prayer and the welfare of the vulnerable were his final concern says everything about their priority in Islam. Prayer is the pillar of the deen — abandoning it collapses everything else. And care for those in one\'s responsibility — children, family, employees — is a sacred trust that cannot be neglected.',
  ),
  Hadith(
    text: 'The example of a good companion and a bad companion is like that of the musk seller and the blacksmith\'s bellows.',
    narrator: 'Narrated by Abu Musa (RA)',
    source: 'Sahih Al-Bukhari 5534, Sahih Muslim 2628',
    explanation: 'From the musk seller, you will either buy perfume, or at minimum enjoy a pleasant fragrance. From the blacksmith, either your clothes may be burned by sparks, or you will at minimum be subjected to an unpleasant smell. This vivid analogy describes the impact of the people we spend time with. Good companions elevate us — they remind us of Allah, inspire righteousness, and refine our character. Bad companions gradually corrode it. Choose your circle wisely.',
  ),
  Hadith(
    text: 'Whoever guides someone to goodness will have a reward like the one who did it.',
    narrator: 'Narrated by Abu Mas\'ud Al-Ansari (RA)',
    source: 'Sahih Muslim 1893',
    explanation: 'The reward for guiding another person to a good deed is equal to doing that deed yourself — without taking anything from the original doer\'s reward. This is an extraordinary multiplication of reward available through teaching, advising, and encouraging others. Every person you point toward prayer, Quran, charity, or good character becomes a source of ongoing reward for you. Islamic knowledge shared is an investment that keeps returning.',
  ),
  Hadith(
    text: 'Three things follow the deceased to the grave: his family, his wealth, and his deeds. Two of them return, and one remains. His family and wealth return, and his deeds remain.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 6514',
    explanation: 'At the moment of death, the only companion a person takes into the grave is their deeds. Family and wealth — often our primary concerns in life — accompany us only to the edge of the grave, then leave. This hadith is a wake-up call about misplaced priorities. The Muslim who understands this invests heavily in deeds: prayers, charity, kindness, knowledge, and worship — the only currency that remains valid in the next life.',
  ),
  Hadith(
    text: 'When a man dies, his deeds come to an end except for three things: sadaqah jariyah (ongoing charity), or knowledge which is beneficial, or a virtuous descendant who prays to Allah for him.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Muslim 1631',
    explanation: 'This is one of the most hope-inspiring hadiths in Islam. While most deeds end at death, these three continue generating reward in the grave and beyond. Building a well or a school (sadaqah jariyah), teaching knowledge that is passed on through generations (beneficial knowledge), and raising children who pray for their parents — these are investments in eternity. Every Muslim who plants such seeds continues to reap rewards long after their last breath.',
  ),
  Hadith(
    text: 'Help your brother, whether he is an oppressor or he is an oppressed one.',
    narrator: 'Narrated by Anas ibn Malik (RA)',
    source: 'Sahih Al-Bukhari 2444',
    explanation: 'A companion asked how one helps an oppressor, and the Prophet (peace be upon him) replied: by preventing him from oppressing. This is a profound ethical teaching. If your friend or fellow Muslim is committing injustice, the true act of brotherhood is to stop them — not to support or excuse their wrongdoing. Enabling harm is not loyalty; it is betrayal. The best helper is the one who saves the oppressor from the consequences of their own wrongdoing.',
  ),
  Hadith(
    text: 'The Muslim who meets people and bears their harm is greater in reward than the one who does not meet people.',
    narrator: 'Narrated by Ibn Umar (RA)',
    source: 'Jami At-Tirmidhi 2507',
    explanation: 'Social engagement with its inevitable difficulties is more rewarding than comfortable isolation. The believer who chooses community — attending gatherings, participating in society, enduring misunderstandings and conflicts with patience — demonstrates a higher calibre of faith. Patience exercised in human relationships is among the most difficult and most rewarded forms of sabr. Islam is a communal faith that calls its followers to engage, endure, and elevate.',
  ),
  Hadith(
    text: 'Allah will not be merciful to those who are not merciful to people.',
    narrator: 'Narrated by Jarir ibn Abdullah (RA)',
    source: 'Sahih Al-Bukhari 7376',
    explanation: 'Mercy operates on a reciprocal principle in the sight of Allah. The quality of compassion we show toward other human beings — including our patience with their faults, our care for their suffering, and our forgiveness of their wrongs — determines the quality of mercy we receive from Allah. A hard-hearted person who shows no compassion to others cannot expect divine mercy. This makes every act of kindness and every pardoning of another person a direct investment in Allah\'s mercy upon oneself.',
  ),
  Hadith(
    text: 'Do good deeds properly, sincerely and moderately, and know that your deeds will not make you enter Paradise, and that the most beloved deed to Allah is the most regular and constant even if it were little.',
    narrator: 'Narrated by Aisha (RA)',
    source: 'Sahih Al-Bukhari 6464',
    explanation: 'This hadith corrects a dangerous misunderstanding: Paradise is not earned by the quantity of deeds — it is Allah\'s mercy that admits believers. Our deeds are expressions of gratitude and love, not payments. Having established that, the Prophet (peace be upon him) advises moderation — do what you can sustain — and consistency. A small, steady deed performed with sincerity and maintained throughout a lifetime is more valuable than a grand outburst of worship that cannot be kept up.',
  ),
  Hadith(
    text: 'Two words are light on the tongue, heavy on the Scale, and beloved to the Most Merciful: SubhanAllahi wa bihamdih, SubhanAllahil Azim.',
    narrator: 'Narrated by Abu Hurairah (RA)',
    source: 'Sahih Al-Bukhari 6406',
    explanation: 'This hadith highlights one of the most accessible and rewarding forms of dhikr. Two short phrases — "Glory be to Allah and His praise" and "Glory be to Allah the Almighty" — require barely a breath to utter, yet they carry enormous weight on the Scale of deeds on the Day of Judgment. The Prophet (peace be upon him) singled these out to show that the value of an act is not determined by its length or difficulty, but by its sincerity and the magnitude of what it glorifies.',
  ),
];

