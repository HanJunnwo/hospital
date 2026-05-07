import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_user_model.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  static const String _keyLoggedIn = 'logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';

  // Mock registered users (in a real app this would be an API)
  // static final Map<String, Map<String, String>> _mockUsers = {};

  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Bypass strict validation as requested to allow UI testing
    final user = AuthUserModel(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Raihan Ramadhan',
      email: email.trim().isEmpty ? 'user@gmail.com' : email.trim(),
      token: 'mock_token',
    );
    await _saveUser(user);
    return user;
  }

  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Bypass strict validation as requested to allow UI testing
    final user = AuthUserModel(
      id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Pengguna Baru' : name.trim(),
      email: email.trim().isEmpty ? 'user@gmail.com' : email.trim(),
      token: 'mock_token',
    );
    await _saveUser(user);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  Future<AuthUserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final id = prefs.getString(_keyUserId);
    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);

    if (id == null || name == null || email == null) return null;

    return AuthUserModel(id: id, name: name, email: email);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> _saveUser(AuthUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserEmail, user.email);
  }
}
