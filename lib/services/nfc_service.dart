import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  static final NfcService _instance = NfcService._internal();
  factory NfcService() => _instance;
  NfcService._internal();

  /// Vérifie si le NFC est disponible sur l'appareil.
  Future<bool> isAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  /// Écrit [payload] sur un tag NFC NDEF.
  /// Lance la session NFC système (sheet iOS / dialogue Android).
  /// Appelle [onSuccess] ou [onError] selon le résultat.
  Future<void> writeText({
    required String payload,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              await NfcManager.instance.stopSession(errorMessage: 'Tag non compatible NDEF');
              onError('Ce tag NFC n\'est pas compatible');
              return;
            }

            if (!ndef.isWritable) {
              await NfcManager.instance.stopSession(errorMessage: 'Tag en lecture seule');
              onError('Ce tag NFC est en lecture seule');
              return;
            }

            final record = NdefRecord.createText(payload);
            final message = NdefMessage([record]);
            await ndef.write(message);

            await NfcManager.instance.stopSession();
            onSuccess();
          } catch (e) {
            await NfcManager.instance.stopSession(errorMessage: 'Erreur d\'écriture');
            onError('Erreur lors de l\'écriture : $e');
          }
        },
      );
    } catch (e) {
      onError('Impossible de démarrer la session NFC : $e');
    }
  }

  /// Stoppe la session NFC en cours (ex: annulation utilisateur).
  Future<void> stopSession() async {
    await NfcManager.instance.stopSession();
  }
}
