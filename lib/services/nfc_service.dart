import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

bool get _isAndroidTarget =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

class NfcService {
  static final NfcService _instance = NfcService._internal();
  static const Duration _sessionTimeout = Duration(seconds: 20);

  factory NfcService() => _instance;
  NfcService._internal();

  bool _sessionInProgress = false;

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
    if (_sessionInProgress) {
      onError('Une session NFC est déjà en cours');
      return;
    }

    final available = await isAvailable();
    if (!available) {
      onError(
        _isAndroidTarget
            ? 'NFC désactivé ou indisponible sur cet appareil Android'
            : 'NFC indisponible sur cet appareil',
      );
      return;
    }

    _sessionInProgress = true;
    final completer = Completer<_NfcWriteOutcome>();
    var completed = false;

    Future<void> completeOutcome(_NfcWriteOutcome outcome) async {
      if (completed) return;
      completed = true;

      await _safeStopSession(
        errorMessage: outcome.success ? null : outcome.sessionErrorMessage,
      );

      if (!completer.isCompleted) {
        completer.complete(outcome);
      }
    }

    try {
      final record = NdefRecord.createText(payload, languageCode: 'fr');
      final message = NdefMessage([record]);

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          if (completed) return;

          try {
            final ndef = Ndef.from(tag);

            if (ndef != null) {
              if (!ndef.isWritable) {
                await completeOutcome(
                  const _NfcWriteOutcome.error(
                    'Ce tag NFC est en lecture seule',
                    sessionErrorMessage: 'Tag en lecture seule',
                  ),
                );
                return;
              }

              if (message.byteLength > ndef.maxSize) {
                await completeOutcome(
                  _NfcWriteOutcome.error(
                    'Tag trop petit (${ndef.maxSize} octets max, ${message.byteLength} requis)',
                    sessionErrorMessage: 'Espace insuffisant',
                  ),
                );
                return;
              }

              await ndef.write(message);
              await completeOutcome(const _NfcWriteOutcome.success());
              return;
            }

            if (_isAndroidTarget) {
              final formatable = NdefFormatable.from(tag);
              if (formatable != null) {
                await formatable.format(message);
                await completeOutcome(const _NfcWriteOutcome.success());
                return;
              }
            }

            await completeOutcome(
              const _NfcWriteOutcome.error(
                'Ce tag NFC n\'est pas compatible NDEF',
                sessionErrorMessage: 'Tag non compatible NDEF',
              ),
            );
          } catch (e) {
            await completeOutcome(
              _NfcWriteOutcome.error(
                'Erreur lors de l\'écriture NFC : $e',
                sessionErrorMessage: 'Erreur d\'écriture',
              ),
            );
          }
        },
        onError: (NfcError error) async {
          await completeOutcome(
            _NfcWriteOutcome.error(
              'Session NFC interrompue : ${error.message}',
              sessionErrorMessage: error.message,
            ),
          );
        },
      );

      final result = await completer.future.timeout(_sessionTimeout);
      if (result.success) {
        onSuccess();
      } else {
        onError(result.errorMessage ?? 'Échec NFC');
      }
    } on TimeoutException {
      await _safeStopSession(errorMessage: 'Session expirée');
      onError('Aucun tag détecté. Réessayez en approchant le téléphone du tag');
    } catch (e) {
      onError('Impossible de démarrer la session NFC : $e');
    } finally {
      _sessionInProgress = false;
    }
  }

  /// Stoppe la session NFC en cours (ex: annulation utilisateur).
  Future<void> stopSession() async {
    await _safeStopSession();
    _sessionInProgress = false;
  }

  Future<void> _safeStopSession({String? errorMessage}) async {
    try {
      await NfcManager.instance.stopSession(errorMessage: errorMessage);
    } catch (_) {
      // Ignore: une session peut déjà être fermée.
    }
  }
}

class _NfcWriteOutcome {
  const _NfcWriteOutcome.success()
    : success = true,
      errorMessage = null,
      sessionErrorMessage = null;

  const _NfcWriteOutcome.error(this.errorMessage, {this.sessionErrorMessage})
    : success = false;

  final bool success;
  final String? errorMessage;
  final String? sessionErrorMessage;
}
