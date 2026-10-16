import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_application.dart';

class StorageService {
  static const String applicationsKey = 'job_applications';

  static Future<List<JobApplication>> loadApplications() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(applicationsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List decoded = jsonDecode(data);

    return decoded.map((item) => JobApplication.fromJson(item)).toList();
  }

  static Future<void> saveApplications(
    List<JobApplication> applications,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data =
        applications.map((application) => application.toJson()).toList();

    await prefs.setString(
      applicationsKey,
      jsonEncode(data),
    );
  }

  static Future<void> clearApplications() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(applicationsKey);
  }
}
