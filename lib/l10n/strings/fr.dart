import '../app_strings.dart';

class FrenchStrings extends AppStrings {
  @override String get prayerTimes => 'Horaires de prière';
  @override String get hadithAthkar => 'Hadith & Athkar';
  @override String get settings => 'Paramètres';

  @override String get appTitle => 'Fajr';
  @override String get nextPrayer => 'Prochaine prière';
  @override String get hours => 'HRS';
  @override String get minutes => 'MIN';
  @override String get seconds => 'SEC';
  @override String get findingLocation => 'Recherche de votre position...';
  @override String get retry => 'Réessayer';
  @override String get couldNotLoad => 'Impossible de charger les horaires';

  @override String get qiblaDirection => 'DIRECTION DE LA QIBLA';
  @override String get fromNorth => 'du Nord';
  @override String get highAccuracy => 'Haute précision';
  @override String get mediumAccuracy => 'Précision moyenne';
  @override String get lowAccuracy => 'Faible précision — bougez le téléphone en 8';
  @override String get noCompass => 'Aucun capteur de boussole détecté';

  @override String get hadithOfTheDay => 'HADITH DU JOUR';
  @override String get dailyAthkar => 'ATHKAR QUOTIDIENS';
  @override String get morningAthkar => 'Athkar du matin';
  @override String get athkarAlSabah => 'Athkar Al-Sabah';
  @override String get eveningAthkar => 'Athkar du soir';
  @override String get athkarAlMasa => 'Athkar Al-Masa';
  @override String get afterPrayerAthkar => 'Athkar après la prière';
  @override String get athkarBadSalah => 'Athkar Ba\'d As-Salah';
  @override String get sleepAthkar => 'Athkar du sommeil';
  @override String get athkarAnNawm => 'Athkar An-Nawm';
  @override String get tapForExplanation => 'Appuyez pour l\'explication';
  @override String get explanation => 'Explication';

  @override String get tapAnywhere => 'Appuyez n\'importe où pour compter';
  @override String get completed => 'Terminé';
  @override String get acceptanceMessage => 'Qu\'Allah accepte votre rappel';
  @override String get done => 'Terminé';

  @override String get colorTheme => 'Couleur du thème';
  @override String get seasonalTheme => 'Thème saisonnier';
  @override String get language => 'Langue';
  @override String get normal => 'Normal';
  @override String get ramadan => 'Ramadan';
  @override String get eid => 'Aïd';
  @override String get hajj => 'Hajj';
  @override String get laylatulQadr => 'Laylat al-Qadr';

  @override String get masjid => 'Mosquée';
  @override String get nearbyMasjids => 'Mosquées à proximité';
  @override String get searchingMasjids => 'Recherche de mosquées à proximité...';
  @override String get noMasjidsFound => 'Aucune mosquée trouvée à proximité';
  @override String get distance => 'Distance';
  @override String get openNow => 'Ouvert maintenant';
  @override String get closed => 'Fermé';
  @override String get getDirections => 'Itinéraire';
  @override String get call => 'Appeler';
  @override String get websiteLabel => 'Site web';
  @override String get openingHours => 'Horaires d\'ouverture';
  @override String get km => 'mi';
  @override String get noDetails => 'Aucun détail supplémentaire disponible';
  @override String get apiKeyMissing => 'Veuillez ajouter votre clé API Google Places dans api_keys.dart';

  @override String get myMasjid => 'Ma Mosquée';
  @override String get setAsMyMasjid => 'Définir comme ma mosquée';
  @override String get removeMyMasjid => 'Retirer ma mosquée';
  @override String get myMasjidSet => 'Définie comme votre mosquée';
  @override String get selectYourMasjid => 'Appuyez sur une mosquée pour la sélectionner';
  @override String get masjidPrayerTimes => 'Horaires de prière';

  @override String get iqamaTimes => 'Horaires d\'Iqama';
  @override String get setIqamaTimes => 'Définir les horaires d\'Iqama';
  @override String get jumuah => 'Jumu\'ah';
  @override String get events => 'Événements';
  @override String get addEvent => 'Ajouter un événement';
  @override String get noEvents => 'Aucun événement ajouté';
  @override String get eventTitle => 'Titre de l\'événement';
  @override String get eventDate => 'Date et heure';
  @override String get eventDescription => 'Description (optionnel)';
  @override String get save => 'Enregistrer';
  @override String get cancel => 'Annuler';

  @override String get quran => 'Coran';
  @override String get searchSurahs => 'Rechercher une sourate...';
  @override String get searchMasjids => 'Rechercher une mosquée...';
  @override String get verses => 'versets';
  @override String get meccan => 'Mecquoise';
  @override String get medinan => 'Médinoise';
  @override String get loadingVerses => 'Chargement des versets...';
  @override String get couldNotLoadSurah => 'Impossible de charger la sourate. Vérifiez votre connexion.';
  @override String get showTranslation => 'Traduction';
  @override String get hideTranslation => 'Arabe seulement';
  @override String get quranReciter => 'Récitateur du Coran';

  @override String get notifications => 'Notifications';
  @override String get adhanNotification => 'Notification Adhan';
  @override String get preReminderNotif => 'Rappel 30 min avant la prière';
  @override String get notifPermDenied => 'Activez les notifications dans les paramètres iPhone pour recevoir les alertes de prière';

  @override String get prayerFajr => 'Fajr';
  @override String get prayerSunrise => 'Lever du soleil';
  @override String get prayerDhuhr => 'Dhohr';
  @override String get prayerAsr => 'Asr';
  @override String get prayerMaghrib => 'Maghrib';
  @override String get prayerIsha => 'Isha';

  @override String get upNext => 'Suivant';
  @override String get remaining => 'restant';
  @override String get offlineData => 'Derniers horaires enregistrés — pas de connexion';
  @override String get verse => 'Verset';
  @override String get serviceUnavailable => 'Le service des horaires de prière est temporairement indisponible. Nouvelle tentative...';
  @override String get somethingWentWrong => 'Une erreur s\'est produite. Veuillez réessayer.';
  @override String get verseCopied => 'Verset copié';
}
