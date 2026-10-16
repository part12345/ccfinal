import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/job_application.dart';
import '../theme/app_theme.dart';
import '../widgets/company_logo.dart';
import 'application_form_page.dart';

class ApplicationDetailsPage extends StatelessWidget {
  final JobApplication application;

  const ApplicationDetailsPage({
    super.key,
    required this.application,
  });

  Color statusColor(String status) {
    switch (status) {
      case 'Applied':
        return AppColors.blue;
      case 'In Review':
        return AppColors.orange;
      case 'Interview':
        return AppColors.purple;
      case 'Offer':
        return AppColors.green;
      case 'Rejected':
        return AppColors.red;
      default:
        return AppColors.textMedium;
    }
  }

  Future<void> deleteApplication(BuildContext context) async {
    final controller = JobTrackScope.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.redLight,
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 32,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Delete Application?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this application?\n\n'
            '${application.companyName} - ${application.jobPosition}',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await controller.deleteApplication(application.id);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = statusColor(application.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobTrackScope(
                    controller: JobTrackScope.of(context),
                    child: ApplicationFormPage(application: application),
                  ),
                ),
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                CompanyLogo(
                  company: application.companyName,
                  size: 55,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.companyName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        application.jobPosition,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          application.status,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _Section(
            title: 'Application Information',
            children: [
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: application.location,
              ),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Applied',
                value:
                    DateFormat('MMM d, yyyy').format(application.dateApplied),
              ),
              _InfoRow(
                icon: Icons.work_outline,
                label: 'Job Type',
                value: application.jobType,
              ),
              _InfoRow(
                icon: Icons.payments_outlined,
                label: 'Expected Salary',
                value: application.expectedSalary.isEmpty
                    ? 'Not specified'
                    : application.expectedSalary,
              ),
              if (application.jobLink.isNotEmpty)
                _InfoRow(
                  icon: Icons.link,
                  label: 'Job Link',
                  value: application.jobLink,
                ),
            ],
          ),
          if (application.notes.isNotEmpty) ...[
            const SizedBox(height: 15),
            _Section(
              title: 'Details',
              children: [
                Text(
                  application.notes,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
          if (application.interviewDate != null) ...[
            const SizedBox(height: 15),
            _Section(
              title: 'Interview Information',
              children: [
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: DateFormat('MMM d, yyyy')
                      .format(application.interviewDate!),
                ),
                if (application.interviewTime != null)
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: application.interviewTime!,
                  ),
                if (application.interviewType != null)
                  _InfoRow(
                    icon: Icons.video_call_outlined,
                    label: 'Type',
                    value: application.interviewType!,
                  ),
                if (application.interviewLink != null)
                  _InfoRow(
                    icon: Icons.link,
                    label: 'Link',
                    value: application.interviewLink!,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobTrackScope(
                          controller: JobTrackScope.of(context),
                          child: ApplicationFormPage(application: application),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined),
                  label: Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    deleteApplication(context);
                  },
                  icon: Icon(Icons.delete_outline),
                  label: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
