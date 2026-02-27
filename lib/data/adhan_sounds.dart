class AdhanSound {
  final String id;
  final String name;
  final String assetPath;

  const AdhanSound({required this.id, required this.name, required this.assetPath});
}

const List<AdhanSound> adhanSounds = [
  AdhanSound(
    id: 'adhan_rabeh_ibn_darah.mp3',
    name: 'Rabeh Ibn Darah Al Jazairi',
    assetPath: 'assets/audio/adhan_rabeh_ibn_darah.mp3',
  ),
  AdhanSound(
    id: 'adhan_adham_al_sharqawe.mp3',
    name: 'Adham Al Sharqawe',
    assetPath: 'assets/audio/adhan_adham_al_sharqawe.mp3',
  ),
  AdhanSound(
    id: 'adhan_ismail_al_sheikh.mp3',
    name: 'Ismail Al Sheikh',
    assetPath: 'assets/audio/adhan_ismail_al_sheikh.mp3',
  ),
  AdhanSound(
    id: 'adhan_ahmed_el_kourdi.mp3',
    name: 'Ahmed El Kourdi',
    assetPath: 'assets/audio/adhan_ahmed_el_kourdi.mp3',
  ),
  AdhanSound(
    id: 'adhan_akhdam_bnu_al_madane.mp3',
    name: 'Akhdam Bnu Al Madane',
    assetPath: 'assets/audio/adhan_akhdam_bnu_al_madane.mp3',
  ),
];

AdhanSound adhanSoundById(String id) =>
    adhanSounds.firstWhere((s) => s.id == id, orElse: () => adhanSounds.first);
