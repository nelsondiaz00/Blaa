import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Logger _logger = Logger('AuthService');

  Future<void> initializeNotifications() async {
    try {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? fcmToken = await _firebaseMessaging.getToken();
        if (fcmToken != null) {
          _logger.info('FCM Token: $fcmToken');
        } else {
          _logger.info('No se pudo obtener el token FCM.');
        }
      } else {
        _logger.info('Permiso para notificaciones no concedido.');
      }
    } catch (e) {
      _logger.info('Error al inicializar notificaciones: $e');
    }
  }

  Future<String> getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token == null) {
      _logger.warning('FCM token is null, returning empty string');
    }
    return token ?? '';
  }
}
