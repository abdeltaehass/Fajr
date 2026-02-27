class AdhanSound {
  final String id;
  final String name;

  const AdhanSound({required this.id, required this.name});
}

const List<AdhanSound> adhanSounds = [
  AdhanSound(
    id: 'adhan_rabeh_ibn_darah.mp3',
    name: 'Rabeh Ibn Darah Al Jazairi',
  ),
  AdhanSound(
    id: 'adhan_adham_al_sharqawe.mp3',
    name: 'Adham Al Sharqawe',
  ),
  AdhanSound(
    id: 'adhan_ismail_al_sheikh.mp3',
    name: 'Ismail Al Sheikh',
  ),
  AdhanSound(
    id: 'adhan_ahmed_el_kourdi.mp3',
    name: 'Ahmed El Kourdi',
  ),
  AdhanSound(
    id: 'adhan_akhdam_bnu_al_madane.mp3',
    name: 'Akhdam Bnu Al Madane',
  ),
];

AdhanSound adhanSoundById(String id) =>
    adhanSounds.firstWhere((s) => s.id == id, orElse: () => adhanSounds.first);
