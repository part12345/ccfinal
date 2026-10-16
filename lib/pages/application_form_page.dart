import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/job_application.dart';
import '../theme/app_theme.dart';

class ApplicationFormPage extends StatefulWidget {
  final JobApplication? application;

  const ApplicationFormPage({
    super.key,
    this.application,
  });

  bool get isEditing => application != null;

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController companyController;
  late TextEditingController positionController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  late TextEditingController linkController;
  late TextEditingController notesController;

  DateTime selectedDate = DateTime.now();
  DateTime? selectedInterviewDate;

  String jobType = 'Full-time';
  String status = 'Applied';
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final app = widget.application;

    companyController = TextEditingController(
      text: app?.companyName ?? '',
    );

    positionController = TextEditingController(
      text: app?.jobPosition ?? '',
    );

    locationController = TextEditingController(
      text: app?.location ?? '',
    );

    salaryController = TextEditingController(
      text: app?.expectedSalary ?? '',
    );

    linkController = TextEditingController(
      text: app?.jobLink ?? '',
    );

    notesController = TextEditingController(
      text: app?.notes ?? '',
    );

    if (app != null) {
      selectedDate = app.dateApplied;
      jobType = app.jobType;
      status = app.status;
      selectedInterviewDate = app.interviewDate;
    }
  }

  @override
  void dispose() {
    companyController.dispose();
    positionController.dispose();
    locationController.dispose();
    salaryController.dispose();
    linkController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> selectInterviewDate() async {
    final initial = selectedInterviewDate ?? DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Select interview date',
    );
    if (result != null) {
      setState(() {
        selectedInterviewDate = DateTime(result.year, result.month, result.day);
      });
    }
  }

  Future<void> saveApplication() async {
    if (_saving || !formKey.currentState!.validate()) return;
    if (status == 'Interview' && selectedInterviewDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an interview date.')));
      return;
    }
    setState(() => _saving = true);
    try {
      final controller = JobTrackScope.of(context);

      if (widget.isEditing) {
      final old = widget.application!;

      final updated = JobApplication(
        id: old.id,
        companyName: companyController.text.trim(),
        jobPosition: positionController.text.trim(),
        location: locationController.text.trim(),
        jobType: jobType,
        dateApplied: selectedDate,
        status: status,
        expectedSalary: salaryController.text.trim(),
        jobLink: linkController.text.trim(),
        notes: notesController.text.trim(),
        interviewDate: status == 'Interview' ? selectedInterviewDate : null,
        interviewTime: old.interviewTime,
        interviewType: old.interviewType,
        interviewLink: old.interviewLink,
      );

      await controller.updateApplication(updated);
    } else {
      final newApplication = JobApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        companyName: companyController.text.trim(),
        jobPosition: positionController.text.trim(),
        location: locationController.text.trim(),
        jobType: jobType,
        dateApplied: selectedDate,
        status: status,
        expectedSalary: salaryController.text.trim(),
        jobLink: linkController.text.trim(),
        notes: notesController.text.trim(),
        interviewDate: status == 'Interview' ? selectedInterviewDate : null,
      );

      await controller.addApplication(newApplication);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save application. Please try again. ($error)')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          editing ? 'Edit Application' : 'Add Job Application',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            _Field(
              label: 'Company Name',
              required: true,
              controller: companyController,
              hint: 'e.g. Google',
              icon: Icons.business_outlined,
            ),
            _Field(
              label: 'Job Position',
              required: true,
              controller: positionController,
              hint: 'e.g. Frontend Developer',
              icon: Icons.work_outline,
            ),
            _Field(
              label: 'Location',
              required: true,
              controller: locationController,
              hint: 'e.g. Manila, Philippines',
              icon: Icons.location_on_outlined,
            ),
            _DropdownField(
              label: 'Job Type',
              value: jobType,
              values: const [
                'Full-time',
                'Part-time',
                'Contract',
                'Internship',
                'Freelance',
              ],
              onChanged: (value) {
                setState(() {
                  jobType = value!;
                });
              },
            ),
            const SizedBox(height: 5),
            Text(
              'Date Applied *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 7),
            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('MM/dd/yyyy').format(selectedDate),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_month,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            _DropdownField(
              label: 'Status',
              value: status,
              values: const [
                'Applied',
                'In Review',
                'Interview',
                'Offer',
                'Rejected',
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),
            if (status == 'Interview') ...[
              const SizedBox(height: 2),
              Text('Interview Date *', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 7),
              InkWell(
                onTap: selectInterviewDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: Row(children: [
                    Icon(Icons.event_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(selectedInterviewDate == null ? 'Choose interview date'
                      : DateFormat('MMM d, yyyy').format(selectedInterviewDate!),
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    const Spacer(),
                    Icon(Icons.calendar_month, size: 18),
                  ]),
                ),
              ),
              if (selectedInterviewDate == null)
                Padding(padding: const EdgeInsets.only(top: 5),
                  child: Text('Please select the date of your interview.',
                    style: TextStyle(fontSize: 11, color: AppColors.red))),
              const SizedBox(height: 14),
            ],
            _Field(
              label: 'Expected Salary',
              controller: salaryController,
              hint: 'e.g. ₱30,000 - ₱40,000',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.text,
            ),
            _Field(
              label: 'Job Link',
              controller: linkController,
              hint: 'e.g. https://company.com/job',
              icon: Icons.link,
            ),
            _Field(
              label: 'Notes',
              controller: notesController,
              hint: 'Add any notes...',
              icon: Icons.notes_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : saveApplication,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: _saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(editing ? 'Update Application' : 'Save Application'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    this.required = false,
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppColors.red,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: required
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '$label is required';
                    }

                    return null;
                  }
                : null,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            initialValue: value,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
            items: values.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
