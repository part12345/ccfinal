import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteJob {
  final String title;
  final String company;
  final String location;
  final String url;
  final String description;

  const RemoteJob({required this.title, required this.company, required this.location, required this.url, required this.description});

  factory RemoteJob.fromJson(Map<String, dynamic> json) => RemoteJob(
    title: (json['title'] ?? 'Untitled role').toString(),
    company: (json['company_name'] ?? 'Company not listed').toString(),
    location: (json['candidate_required_location'] ?? 'Remote').toString(),
    url: (json['url'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
  );
}

class RemoteJobsService {
  static Future<List<RemoteJob>> fetchJobs() async {
    final response = await http.get(
      Uri.parse('https://remotive.com/api/remote-jobs?limit=10'),
      headers: const {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('The jobs service returned status ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final jobs = decoded['jobs'] as List<dynamic>? ?? [];
    return jobs.map((item) => RemoteJob.fromJson(item as Map<String, dynamic>)).toList();
  }
}
