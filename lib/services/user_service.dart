import 'dart:convert';
import 'package:blaa/entity/user.dart';
import 'package:blaa/services/auth_service.dart';
import 'package:blaa/services/firebase_service.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../config/config.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  final Logger _logger = Logger('UserService');
  final String _baseUrl = baseUrl;

  UserService._internal();

  Future<bool> createAccount(
    String email,
    String password,
    String fullName,
    String phoneNumber,
    String position,
    String photoUrl,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'position': position,
          'photoUrl': photoUrl,
          'fcmToken': await FirebaseService().getFCMToken(),
        }),
      );

      if (response.statusCode == 201) {
        _logger.info('Account created successfully');
        
        return true;
      } else {
        _logger.warning('Failed to create account: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.severe('Error en createAccount: $e');
      return false;
    }
  }

  Future<String?> uploadPhoto(String filePath) async {
    final uri = Uri.parse('$_baseUrl/user/photo/upload');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('photo', filePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        return decoded['photoUrl'];
      } else {
        _logger.warning('Upload failed with status: ${response.statusCode}');
        _logger.warning(await response.stream.bytesToString());
        return null;
      }
    } catch (e) {
      _logger.severe('Error uploading photo: $e');
      return null;
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final loginToken = await AuthService().getStoredToken();

      _logger.info("Token: $loginToken");
      final response = await http.get(
        Uri.parse('$_baseUrl/user/all'),
        headers: {
          'Authorization': 'Bearer $loginToken',
          'Content-Type': 'application/json',
        },
      );
      _logger.info(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<User> users =
            data.map((userJson) => User.fromJson(userJson)).toList();
        _logger.info(
          'Successfully retrieved users: ${users.length} users found',
        );
        return users;
      } else {
        _logger.warning('Failed to fetch users: ${response.body}');
        return [];
      }
    } catch (e) {
      _logger.severe('Error fetching users: $e');
      return [];
    }
  }

  Future<List<User>> getRecentUsers() async {
    try {
      final loginToken = await AuthService().getStoredToken();
      final emailUser = (await AuthService().getUserLogged())?.email;
      _logger.info("Token: $loginToken");
      final response = await http.get(
        Uri.parse('$_baseUrl/user/with-messages?email=$emailUser'),
        headers: {
          'Authorization': 'Bearer $loginToken',
          'Content-Type': 'application/json',
        },
      );
      _logger.info(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<User> users =
            data.map((userJson) => User.fromJson(userJson)).toList();
        _logger.info(
          'Successfully retrieved users: ${users.length} users found',
        );
        return users;
      } else {
        _logger.warning('Failed to fetch users: ${response.body}');
        return [];
      }
    } catch (e) {
      _logger.severe('Error fetching users: $e');
      return [];
    }
  }
}
