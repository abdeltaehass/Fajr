import 'hajj_umrah_guide.dart';

const List<GuideSection> zakatGuide = [
  GuideSection(
    heading: 'What is Zakat?',
    steps: [
      GuideStep(
        title: 'The Third Pillar of Islam',
        description:
            'Zakat (الزَّكَاة) is one of the Five Pillars of Islam and is obligatory upon every Muslim who meets the minimum wealth threshold (nisab) for a full lunar year. It is an act of worship — not merely charity — through which wealth is purified and the needs of those less fortunate are met.',
        arabic: 'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ',
        transliteration: 'Wa-aqīmū al-ṣalāta wa-ātū al-zakāta',
        dua: '"Establish the prayer and give Zakat." — Quran 2:43',
      ),
      GuideStep(
        title: 'The Rate',
        description:
            'Zakat on money, gold, silver, and trade goods is 2.5% of the total net zakatable wealth — provided the wealth has been held for one full lunar year (hawl) and meets or exceeds the nisab.',
        note:
            'Different rates apply to agricultural produce (5–10%) and livestock — these have their own detailed rulings.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Who Must Pay?',
    steps: [
      GuideStep(
        title: 'Conditions of Obligation',
        description:
            'Zakat is obligatory on a Muslim who:\n\n'
            '1. Is an adult (has reached puberty)\n'
            '2. Is sane\n'
            '3. Is free (not enslaved)\n'
            '4. Owns wealth equal to or above the nisab\n'
            '5. Has owned that wealth for a complete lunar year (hawl)',
        note:
            'Debts owed by you may be deducted from your total before calculating Zakat. If your net wealth after deducting debts falls below nisab, Zakat is not due.',
      ),
      GuideStep(
        title: 'The Lunar Year (Hawl)',
        description:
            'The hawl begins the moment your wealth first reaches the nisab threshold. If it drops below nisab at any point during the year and then rises again, a new hawl begins from when it crossed the threshold again.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Nisab — The Minimum Threshold',
    steps: [
      GuideStep(
        title: 'Gold Nisab',
        description:
            'The nisab based on gold is 85 grams of pure gold. To find the nisab in your local currency, multiply 85 by the current price per gram of gold.',
        note: 'Example: If gold is \$60/gram, nisab = 85 × \$60 = \$5,100.',
      ),
      GuideStep(
        title: 'Silver Nisab',
        description:
            'The nisab based on silver is 595 grams of pure silver. Some scholars recommend using the silver nisab as it is lower and ensures more people fulfil their obligation.',
        note:
            'There is scholarly difference on which nisab to use. Many contemporary scholars recommend gold nisab for monetary wealth and silver nisab for trade goods. Consult a scholar if unsure.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Zakatable Wealth',
    steps: [
      GuideStep(
        title: 'Cash & Bank Savings',
        description:
            'All cash in hand, current accounts, savings accounts, and fixed deposits are subject to Zakat at 2.5%, provided the total (combined with other assets) meets nisab after one lunar year.',
      ),
      GuideStep(
        title: 'Gold & Silver',
        description:
            'Gold and silver in any form — jewellery, coins, bars, or bullion — are zakatable. The weight is valued at current market price and 2.5% is paid.',
        note:
            'Scholars differ on gold jewellery that is in regular personal use. The majority position (Hanafi) is that it is still zakatable.',
      ),
      GuideStep(
        title: 'Business & Trade Goods',
        description:
            'Inventory held for the purpose of trade or sale is zakatable at market value on the date Zakat is due. Raw materials and finished goods ready for sale are included.',
      ),
      GuideStep(
        title: 'Investments & Stocks',
        description:
            'Shares held as long-term investments are zakatable on their market value. If the company\'s underlying zakatable assets can be determined, Zakat may be paid on the proportionate share of those assets instead.',
      ),
      GuideStep(
        title: 'Money Owed to You',
        description:
            'Debts that others owe you and that you expect to be repaid are added to your zakatable wealth. Debts you owe others can be subtracted.',
      ),
      GuideStep(
        title: 'Non-Zakatable Assets',
        description:
            'Personal-use items are generally not zakatable: your home, car, furniture, clothing, and tools used in your work or trade. Likewise, property held for personal residence — not rental income — is exempt.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Who Receives Zakat?',
    steps: [
      GuideStep(
        title: 'The Eight Categories (Quran 9:60)',
        description:
            'Allah has designated eight categories of recipients:\n\n'
            '1. Al-Fuqara — The poor who have nothing\n'
            '2. Al-Masakin — The needy who are not destitute but still insufficient\n'
            '3. Zakat administrators — Those who collect and distribute it\n'
            '4. Those whose hearts are to be reconciled — New Muslims or those important for the community\n'
            '5. Those in bondage — Historically, slaves seeking emancipation; today applied to those in forced labour or captivity\n'
            '6. Al-Gharimeen — The heavily indebted who cannot repay\n'
            '7. Fi Sabilillah — In the cause of Allah (scholars differ on the scope)\n'
            '8. Ibn Al-Sabil — A stranded traveller who lacks the means to return home',
        arabic:
            'إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ وَالْعَامِلِينَ عَلَيْهَا وَالْمُؤَلَّفَةِ قُلُوبُهُمْ وَفِي الرِّقَابِ وَالْغَارِمِينَ وَفِي سَبِيلِ اللَّهِ وَابْنِ السَّبِيلِ',
        dua: 'Quran 9:60',
      ),
      GuideStep(
        title: 'Who Cannot Receive Zakat',
        description:
            'Zakat cannot be given to:\n\n'
            '• Non-Muslims (some scholars allow it in specific circumstances)\n'
            '• Descendants of the Prophet ﷺ (Banu Hashim)\n'
            '• Your direct dependents (spouse, children, parents) whose expenses you are already obligated to provide\n'
            '• Wealthy individuals who have no need',
      ),
    ],
  ),
  GuideSection(
    heading: 'When & How to Pay',
    steps: [
      GuideStep(
        title: 'Timing',
        description:
            'Zakat becomes due on the same lunar calendar date each year — the anniversary of when your wealth first reached nisab. Many Muslims pay during Ramadan to gain additional reward, which is permissible as long as the hawl has been completed.',
        note:
            'Paying before the hawl is complete is permissible but paying late is sinful if you were able to pay on time.',
      ),
      GuideStep(
        title: 'Payment',
        description:
            'Zakat may be paid in cash or in kind (e.g. food, goods). It should be given directly to eligible recipients or through a trustworthy organisation that ensures proper distribution to the eight categories.',
      ),
    ],
  ),
];
