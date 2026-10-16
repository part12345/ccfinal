import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/job_application.dart';
import '../theme/app_theme.dart';
import 'company_logo.dart';

class ApplicationTile extends StatelessWidget {
  final JobApplication application;
  final VoidCallback onTap;

  const ApplicationTile({
    super.key,
    required this.application,
    required this.onTap,
  });

  Color _statusColor() {
    switch (application.status) {
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

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: isDark ? .9 : .7)),
          boxShadow: [BoxShadow(
            color: (isDark ? Colors.black : AppColors.primary).withValues(alpha: isDark ? .12 : .045),
            blurRadius: 12, offset: const Offset(0, 4),
          )],
        ),
        child: Row(
          children: [
            CompanyLogo(
              company: application.companyName,
              size: 45,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.companyName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: -0.2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    application.jobPosition,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    application.location,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    application.status,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('MMM d, yyyy').format(application.dateApplied),
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 19,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
