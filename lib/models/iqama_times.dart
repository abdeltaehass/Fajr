class IqamaTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String jumuah;

  const IqamaTimes({
    this.fajr = '',
    this.dhuhr = '',
    this.asr = '',
    this.maghrib = '',
    this.isha = '',
    this.jumuah = '',
  });

  bool get isEmpty =>
      fajr.isEmpty &&
      dhuhr.isEmpty &&
      asr.isEmpty &&
      maghrib.isEmpty &&
      isha.isEmpty &&
      jumuah.isEmpty;

  Map<String, dynamic> toJson() => {
        'fajr': fajr,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
        'jumuah': jumuah,
      };

  factory IqamaTimes.fromJson(Map<String, dynamic> json) => IqamaTimes(
        fajr: json['fajr'] as String? ?? '',
        dhuhr: json['dhuhr'] as String? ?? '',
        asr: json['asr'] as String? ?? '',
        maghrib: json['maghrib'] as String? ?? '',
        isha: json['isha'] as String? ?? '',
        jumuah: json['jumuah'] as String? ?? '',
      );
}
