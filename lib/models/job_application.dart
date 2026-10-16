class JobApplication {
  final String id;
  String companyName;
  String jobPosition;
  String location;
  String jobType;
  DateTime dateApplied;
  String status;
  String expectedSalary;
  String jobLink;
  String notes;

  DateTime? interviewDate;
  String? interviewTime;
  String? interviewType;
  String? interviewLink;

  JobApplication({
    required this.id,
    required this.companyName,
    required this.jobPosition,
    required this.location,
    required this.jobType,
    required this.dateApplied,
    required this.status,
    required this.expectedSalary,
    required this.jobLink,
    required this.notes,
    this.interviewDate,
    this.interviewTime,
    this.interviewType,
    this.interviewLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'jobPosition': jobPosition,
      'location': location,
      'jobType': jobType,
      'dateApplied': dateApplied.toIso8601String(),
      'status': status,
      'expectedSalary': expectedSalary,
      'jobLink': jobLink,
      'notes': notes,
      'interviewDate': interviewDate?.toIso8601String(),
      'interviewTime': interviewTime,
      'interviewType': interviewType,
      'interviewLink': interviewLink,
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      companyName: json['companyName'] ?? '',
      jobPosition: json['jobPosition'] ?? '',
      location: json['location'] ?? '',
      jobType: json['jobType'] ?? '',
      dateApplied: DateTime.parse(json['dateApplied']),
      status: json['status'] ?? 'Applied',
      expectedSalary: json['expectedSalary'] ?? '',
      jobLink: json['jobLink'] ?? '',
      notes: json['notes'] ?? '',
      interviewDate: json['interviewDate'] != null
          ? DateTime.parse(json['interviewDate'])
          : null,
      interviewTime: json['interviewTime'],
      interviewType: json['interviewType'],
      interviewLink: json['interviewLink'],
    );
  }
}
