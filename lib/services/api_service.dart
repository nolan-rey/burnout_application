import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  static const String _baseUrl = 'http://98.66.235.57';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _auth = AuthService();

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_auth.token}',
      };

  Map<String, String> get _publicHeaders => {
        'Content-Type': 'application/json',
      };

  void _checkStatus(http.Response res) {
    if (res.statusCode >= 400) {
      String msg = 'Erreur serveur';
      try {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        msg = body['error']?.toString() ?? msg;
      } catch (_) {}
      throw ApiException(res.statusCode, msg);
    }
  }

  // ─── Auth ────────────────────────────────────────────────────────────────────

  /// Retourne true si le login réussit et sauvegarde le token.
  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: _publicHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    _checkStatus(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] == true && body['token'] != null) {
      await _auth.saveToken(body['token'] as String);
      return true;
    }
    return false;
  }

  // ─── Status ──────────────────────────────────────────────────────────────────

  Future<String> getApiStatus() async {
    final res = await http.get(Uri.parse('$_baseUrl/'));
    _checkStatus(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body['status']?.toString() ?? '';
  }

  // ─── Utilisateurs ────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUsers() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: _authHeaders,
    );
    _checkStatus(res);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(body['users'] as List);
  }

  // ─── Programmes ──────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getProgrammes() async {
    final res = await http.get(
      Uri.parse('$_baseUrl/programmes'),
      headers: _authHeaders,
    );
    _checkStatus(res);
    return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
  }

  Future<void> createProgramme(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/programmes'),
      headers: _authHeaders,
      body: jsonEncode(data),
    );
    _checkStatus(res);
  }

  Future<void> updateProgramme(int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/programmes/$id'),
      headers: _authHeaders,
      body: jsonEncode(data),
    );
    _checkStatus(res);
  }

  Future<void> deleteProgramme(int id) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl/programmes/$id'),
      headers: _authHeaders,
    );
    _checkStatus(res);
  }
}
