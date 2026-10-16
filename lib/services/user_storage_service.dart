import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  static const _phoneKey = 'profile_phone';
  static const _locationKey = 'profile_location';
  static const _targetKey = 'profile_target_position';
  static const _passwordKey = 'account_password';
  static const _loggedInKey = 'account_logged_in';
  static const _darkModeKey = 'jobtrack_dark_mode';

  static Future<Map<String, String>> loadProfile() async {
    final p = await SharedPreferences.getInstance();
    return {
      'name': p.getString(_nameKey) ?? '',
      'email': p.getString(_emailKey) ?? '',
      'phone': p.getString(_phoneKey) ?? '',
      'location': p.getString(_locationKey) ?? 'Philippines',
      'targetPosition': p.getString(_targetKey) ?? 'Frontend Developer',
    };
  }

  static Future<void> saveProfile({required String name, required String email, required String phone, required String location, required String targetPosition}) async {
    final p = await SharedPreferences.getInstance();
    final writesSucceeded = await Future.wait<bool>([
      p.setString(_nameKey, name.trim()),
      p.setString(_emailKey, email.trim()),
      p.setString(_phoneKey, phone.trim()),
      p.setString(_locationKey, location.trim()),
      p.setString(_targetKey, targetPosition.trim()),
    ]);
    if (writesSucceeded.any((success) => !success)) {
      throw Exception('Device storage did not confirm all profile changes.');
    }
  }

  static Future<bool> hasAccount() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString(_emailKey) ?? '').isNotEmpty && (p.getString(_passwordKey) ?? '').isNotEmpty;
  }

  static Future<String?> createAccount({required String name, required String email, required String password}) async {
    final p = await SharedPreferences.getInstance();
    if ((p.getString(_emailKey) ?? '').isNotEmpty) return 'An account already exists on this device. Please log in.';
    await p.setString(_nameKey, name.trim());
    await p.setString(_emailKey, email.trim().toLowerCase());
    await p.setString(_passwordKey, password);
    await p.setString(_phoneKey, '');
    await p.setString(_locationKey, 'Philippines');
    await p.setString(_targetKey, 'Frontend Developer');
    await p.setBool(_loggedInKey, true);
    return null;
  }

  static Future<String?> login({required String email, required String password}) async {
    final p = await SharedPreferences.getInstance();
    if ((p.getString(_emailKey) ?? '').toLowerCase() != email.trim().toLowerCase() || p.getString(_passwordKey) != password) {
      return 'Email or password is incorrect.';
    }
    await p.setBool(_loggedInKey, true);
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_loggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_loggedInKey, false);
  }

  static Future<bool> loadDarkMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_darkModeKey) ?? false;
  }

  static Future<void> saveDarkMode(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_darkModeKey, value);
  }
}
