import 'hajj_umrah_guide.dart';

const List<GuideSection> islamicFinanceGuide = [
  GuideSection(
    heading: 'Principles of Islamic Finance',
    steps: [
      GuideStep(
        title: 'Riba is Forbidden (Interest)',
        description:
            'The cornerstone of Islamic finance is the prohibition of riba (ربا) — any guaranteed, predetermined return on money. This covers bank interest, bonds with fixed yields, and any contractual increase on a loan. All transactions must be tied to real economic activity.',
        arabic: 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا',
        dua: '"Allah has permitted trade and forbidden riba." — Quran 2:275',
      ),
      GuideStep(
        title: 'Gharar — Excessive Uncertainty',
        description:
            'Transactions involving excessive ambiguity or speculation (gharar) are prohibited. Contracts must clearly define the asset, price, and delivery terms. This rules out conventional derivatives, short-selling, and most forms of speculative options trading.',
        note:
            'Minor uncertainty inherent in all commerce is tolerated; it is excessive or deliberate ambiguity that is forbidden.',
      ),
      GuideStep(
        title: 'Maysir — Gambling',
        description:
            'Maysir (مَيْسِر) covers all forms of gambling and zero-sum speculation where one party\'s gain is entirely at another\'s loss without any underlying asset or productive activity. Lottery tickets, casino-style games, and highly leveraged CFDs fall under this category.',
        arabic: 'إِنَّمَا الْخَمْرُ وَالْمَيْسِرُ … رِجْسٌ مِّنْ عَمَلِ الشَّيْطَانِ',
        dua: '"Intoxicants and gambling … are an abomination of Satan\'s handiwork." — Quran 5:90',
      ),
      GuideStep(
        title: 'Profit Must Come from Real Risk',
        description:
            'In Islam, money itself cannot generate money. Returns must arise from sharing in the risk and reward of a real business or asset. The investor either shares in profit and loss (like equity) or earns rent from a tangible asset (like property).',
      ),
    ],
  ),
  GuideSection(
    heading: 'Halal Investment Screens',
    steps: [
      GuideStep(
        title: 'Business Activity Screen',
        description:
            'A company\'s core business must be halal. Scholars generally apply a 5% revenue tolerance for incidental haram income (e.g., a supermarket chain with a small alcohol section). Companies whose primary revenue comes from the following are excluded:\n\n• Alcohol, tobacco, pork\n• Conventional banking & insurance\n• Weapons & defence\n• Adult entertainment\n• Gambling & casinos',
        note:
            'Some scholarly bodies set the tolerance at 5%, others at up to 33%. Always follow a certified Shariah screening service for your investments.',
      ),
      GuideStep(
        title: 'Debt & Interest Screen',
        description:
            'Even if a company\'s business is halal, excessive debt makes it non-compliant. The common thresholds used by AAOIFI and major Islamic indices are:\n\n• Total debt ÷ Total assets < 33%\n• Interest-bearing debt ÷ Market cap < 33%\n• Cash & interest-bearing securities ÷ Market cap < 33%',
        note:
            'These ratios must be checked regularly — a company can move in and out of compliance as its balance sheet changes.',
      ),
      GuideStep(
        title: 'Purification of Dividends',
        description:
            'If a screened stock still earns a small percentage of haram income, you must purify your dividend. Calculate the haram percentage of total revenue, multiply by the dividend received, and donate that exact amount to charity — not as sadaqah (voluntary charity) but as a disposal of impure income.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Islamic Financial Contracts',
    steps: [
      GuideStep(
        title: 'Murabaha — Cost-Plus Sale',
        description:
            'The bank purchases an asset and resells it to the customer at a disclosed mark-up, payable in instalments. Because the bank takes genuine ownership and bears risk before selling, the mark-up is profit — not interest. Widely used for home and car financing.',
        note:
            'The bank must take actual ownership of the asset, even briefly, for murabaha to be valid.',
      ),
      GuideStep(
        title: 'Ijara — Islamic Leasing',
        description:
            'The financier buys an asset and leases it to the customer for a fixed term and rental. Ownership stays with the financier throughout. Common for property (Islamic mortgage) and equipment. An Ijara wa Iqtina adds a promise to sell the asset to the lessee at the end of the term.',
      ),
      GuideStep(
        title: 'Mudaraba — Profit-Sharing',
        description:
            'One party (rabb al-mal) provides capital; the other (mudarib) provides skill and management. Profits are shared at a pre-agreed ratio. Losses fall entirely on the capital provider unless caused by the manager\'s negligence. This is the basis of many Islamic savings accounts and investment funds.',
        arabic: 'الْخَرَاجُ بِالضَّمَانِ',
        dua: '"Gain accompanies liability." — Hadith (Abu Dawud)',
      ),
      GuideStep(
        title: 'Musharaka — Partnership',
        description:
            'Both parties contribute capital (and optionally labour) and share profits according to a pre-agreed ratio. Losses are shared in proportion to capital contributed. Diminishing musharaka — where the bank gradually sells its share to the client — is the Islamic alternative to a conventional mortgage.',
      ),
      GuideStep(
        title: 'Sukuk — Islamic Bonds',
        description:
            'Sukuk are asset-backed certificates representing ownership in a tangible asset, usufruct, or project. Unlike bonds, they do not pay interest — holders receive a share of the revenue the underlying asset generates. Ensure the sukuk structure is asset-backed (not just asset-based) for full compliance.',
        note:
            'Not all sukuk are equal — always verify the underlying structure has been certified by a reputable Shariah board.',
      ),
    ],
  ),
  GuideSection(
    heading: 'Halal Investing in Practice',
    steps: [
      GuideStep(
        title: 'Halal Stocks & ETFs',
        description:
            'You may invest in individually screened stocks or use Shariah-compliant ETFs and funds that have been certified by a recognised Shariah supervisory board. Popular indices include the Dow Jones Islamic Market Index and S&P 500 Shariah Index.',
        note:
            'Rebalance and re-screen periodically — compliance status changes with company earnings.',
      ),
      GuideStep(
        title: 'Crypto & Digital Assets',
        description:
            'Scholars are divided. Most agree that:\n\n• Crypto used as a medium of exchange for halal goods/services is generally permissible.\n• Highly speculative trading (day-trading, leverage) carries strong elements of maysir and gharar.\n• Crypto that pays "interest" (e.g., some staking models) must be scrutinised for riba.\n• Always seek a qualified scholar\'s ruling on specific projects.',
      ),
      GuideStep(
        title: 'Pension & Workplace Investments',
        description:
            'If your employer offers a range of pension funds, choose a Shariah-compliant or ethical fund where available. Where no halal option exists, some scholars permit participation in the default fund with purification of any haram-derived returns as a necessity (darura).',
        note:
            'Consult a qualified Islamic finance scholar for your specific situation.',
      ),
      GuideStep(
        title: 'Screening Tools & Certification',
        description:
            'Use certified screening services to verify compliance before investing:\n\n• Zoya App — stock screener for individual equities\n• Islamicly — portfolio screening\n• AAOIFI — global Shariah standards body\n• HSBC Amanah, Wahed Invest — managed halal portfolios\n\nAlways prefer investments overseen by a named, reputable Shariah supervisory board.',
      ),
    ],
  ),
];
