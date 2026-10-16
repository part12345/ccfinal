import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/company_logo.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();

  void previousMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month - 1,
        1,
      );
    });
  }

  void nextMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = JobTrackScope.of(context);

    final interviews = controller.applications.where((app) {
      return app.interviewDate != null &&
          app.interviewDate!.year == selectedDate.year &&
          app.interviewDate!.month == selectedDate.month;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
        children: [
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: previousMonth,
                      icon: Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          DateFormat('MMMM yyyy').format(selectedDate),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: nextMonth,
                      icon: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _CalendarGrid(
                  month: selectedDate,
                  selectedDate: selectedDate,
                  interviewDates: controller.applications
              .where((app) => app.interviewDate != null)
              .map((app) => app.interviewDate!)
              .toList(),
          onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Upcoming Interviews',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${interviews.length}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (interviews.isEmpty)
            AppCard(
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 42,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No interviews this month',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your upcoming interviews will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else
            ...interviews.map(
              (application) => AppCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CompanyLogo(
                      company: application.companyName,
                      size: 42,
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
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            application.jobPosition,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${application.interviewTime ?? 'Time TBD'} • '
                            '${application.interviewType ?? 'TBD'}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('MMM d').format(application.interviewDate!),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final List<DateTime> interviewDates;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarGrid({
    required this.month,
    required this.selectedDate,
    required this.interviewDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    );

    final leadingEmpty = firstDay.weekday % 7;

    final days = <Widget>[];

    const weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    for (final day in weekdays) {
      days.add(
        Center(
          child: Text(
            day,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < leadingEmpty; i++) {
      days.add(const SizedBox());
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(
        month.year,
        month.month,
        day,
      );

      final selected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;

      final hasInterview = interviewDates.any((eventDate) =>
          eventDate.year == date.year && eventDate.month == date.month && eventDate.day == date.day);
      days.add(
        GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text('$day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface)),
                if (hasInterview)
                  Positioned(bottom: 3, child: Container(width: 4, height: 4,
                    decoration: BoxDecoration(color: selected ? Colors.white : AppColors.primary,
                      shape: BoxShape.circle))),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: days,
    );
  }
}
