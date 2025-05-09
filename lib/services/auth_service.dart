import 'dart:convert';
import 'package:blaa/entity/user.dart';
import 'package:blaa/services/firebase_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../config/config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  final Logger _logger = Logger('AuthService');
  AuthService._internal();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String _baseUrl = baseUrl;

  Future<bool> login(String email, String password) async {
    try {
      final token = await FirebaseService().getFCMToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          "fcmToken": token,
        }),
      );
      _logger.info(response.statusCode);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _logger.info('Info: $data');
        _secureStorage.write(key: 'auth_token', value: data['token']);
        _secureStorage.write(
          key: 'user_info',
          value: json.encode(data['user']),
        );
        return true;
      }

      return false;
    } catch (e) {
      _logger.severe('Error en login: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final token = await FirebaseService().getFCMToken();
      final tokenJWT = await getStoredToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout/$token'),
        headers: {
          'Authorization': 'Bearer $tokenJWT',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await _secureStorage.delete(key: 'auth_token');
      }

      return false;
    } catch (e) {
      _logger.severe('Error en login: $e');
      return false;
    }
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<User?> getUserLogged() async {
    final userJson = await _secureStorage.read(key: 'user_info');
    if (userJson == null) return null;

    final Map<String, dynamic> userMap = json.decode(userJson);
    return User.fromJson(userMap);
  }
}
