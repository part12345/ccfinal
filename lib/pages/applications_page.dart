import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/application_tile.dart';
import 'application_details_page.dart';
import 'application_form_page.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  String search = '';
  String statusFilter = 'All Status';
  String typeFilter = 'All Types';

  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = JobTrackScope.of(context);

    final applications = controller.applications.where((application) {
      final matchesSearch = application.companyName.toLowerCase().contains(
                search.toLowerCase(),
              ) ||
          application.jobPosition.toLowerCase().contains(
                search.toLowerCase(),
              ) ||
          application.location.toLowerCase().contains(
                search.toLowerCase(),
              );

      final matchesStatus =
          statusFilter == 'All Status' || application.status == statusFilter;
      final matchesType =
          typeFilter == 'All Types' || application.jobType == typeFilter;

      return matchesSearch && matchesStatus && matchesType;
    }).toList();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = controller.applications.length;
    final interviews = controller.applications.where((a) => a.status == 'Interview').length;
    final offers = controller.applications.where((a) => a.status == 'Offer').length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text(
          'Applications',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.4),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobTrackScope(
                    controller: JobTrackScope.of(context),
                    child: const ApplicationFormPage(),
                  ),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 19,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF252044), Color(0xFF172238)]
                      : const [Color(0xFF5145E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(
                  color: (isDark ? Colors.black : AppColors.primary).withValues(alpha: .16),
                  blurRadius: 18, offset: const Offset(0, 8),
                )],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.work_history_rounded, color: Colors.white, size: 23),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your career journey', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                        SizedBox(height: 3),
                        Text('Every application brings you closer.', style: TextStyle(color: Color(0xFFE5E7FF), fontSize: 11)),
                      ],
                    )),
                    Text('$total', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _MiniMetric(icon: Icons.calendar_month_rounded, label: 'Interviews', value: '$interviews')),
                    const SizedBox(width: 10),
                    Expanded(child: _MiniMetric(icon: Icons.celebration_rounded, label: 'Offers', value: '$offers')),
                    const SizedBox(width: 10),
                    Expanded(child: _MiniMetric(icon: Icons.track_changes_rounded, label: 'Showing', value: '${applications.length}')),
                  ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search by company, position or location...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    label: statusFilter,
                    onTap: () => _showStatusFilter(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterButton(
                    label: typeFilter,
                    onTap: () => _showTypeFilter(context),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      search = '';
                      searchController.clear();
                      statusFilter = 'All Status';
                      typeFilter = 'All Types';
                    });
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: applications.isEmpty
                ? _EmptyState(
                    onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobTrackScope(
                    controller: JobTrackScope.of(context),
                    child: const ApplicationFormPage(),
                  ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      5,
                      16,
                      30,
                    ),
                    itemCount: applications.length,
                    itemBuilder: (_, index) {
                      final application = applications[index];

                      return ApplicationTile(
                        application: application,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplicationDetailsPage(
                                application: application,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobTrackScope(
                    controller: JobTrackScope.of(context),
                    child: const ApplicationFormPage(),
                  ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showTypeFilter(BuildContext context) {
    const types = ['All Types', 'Full-time', 'Part-time', 'Contract', 'Internship', 'Freelance'];
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: types.map((type) => ListTile(
          title: Text(type),
          trailing: type == typeFilter ? Icon(Icons.check, color: AppColors.primary) : null,
          onTap: () {
            setState(() => typeFilter = type);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    final statuses = [
      'All Status',
      'Applied',
      'In Review',
      'Interview',
      'Offer',
      'Rejected',
    ];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: statuses.map((status) {
            return ListTile(
              title: Text(status),
              trailing: status == statusFilter
                  ? Icon(
                      Icons.check,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () {
                setState(() {
                  statusFilter = status;
                });

                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniMetric({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: .13)),
      ),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFE4E0FF), size: 17),
        const SizedBox(width: 7),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFE5E7FF), fontSize: 9)),
        ])),
      ]),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
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
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Keep the empty state scrollable so it remains usable in short windows,
    // landscape orientation, and when text scaling is increased.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No job applications yet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start tracking your job search by adding your first application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
