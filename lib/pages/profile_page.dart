import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';
import '../services/user_storage_service.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  const ProfilePage({super.key, required this.onThemeChanged});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> profile = {'name': '', 'email': '', 'phone': '', 'location': 'Philippines', 'targetPosition': 'Frontend Developer'};
  @override
  void initState() { super.initState(); _loadProfile(); }
  Future<void> _loadProfile() async { final p = await UserStorageService.loadProfile(); if (mounted) setState(() => profile = p); }

  @override
  Widget build(BuildContext context) {
    final controller = JobTrackScope.of(context);

    final total = controller.applications.length;

    final interviews =
        controller.applications.where((e) => e.status == 'Interview').length;

    final offers =
        controller.applications.where((e) => e.status == 'Offer').length;

    final rejected =
        controller.applications.where((e) => e.status == 'Rejected').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
                  builder: (_) => SettingsPage(onThemeChanged: widget.onThemeChanged, onClearApplications: controller.clearAll),
                ),
              );
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.purple,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile['name']!.isEmpty ? 'Your Name' : profile['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  profile['email']!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async { final saved = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const EditProfilePage())); if (saved == true) _loadProfile(); },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.white70,
                    ),
                  ),
                  child: Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                _ProfileRow(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: profile['location']!,
                ),
                _ProfileRow(
                  icon: Icons.work_outline,
                  title: 'Target Position',
                  value: profile['targetPosition']!,
                ),
                _ProfileRow(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  value: profile['phone']!.isEmpty ? 'Not provided' : profile['phone']!,
                ),
                _ProfileRow(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: profile['email']!,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Application Statistics',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                _StatisticRow(
                  icon: Icons.description,
                  color: AppColors.blue,
                  title: 'Total Applications',
                  value: '$total',
                ),
                _StatisticRow(
                  icon: Icons.event,
                  color: AppColors.purple,
                  title: 'Interviews',
                  value: '$interviews',
                ),
                _StatisticRow(
                  icon: Icons.check_circle,
                  color: AppColors.green,
                  title: 'Offers',
                  value: '$offers',
                ),
                _StatisticRow(
                  icon: Icons.cancel,
                  color: AppColors.red,
                  title: 'Rejected',
                  value: '$rejected',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: total == 0 ? 0 : (interviews + offers) / total,
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'Start adding applications'
                      : '${((interviews + offers) / total * 100).round()}% of applications reached interview or offer stage.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _StatisticRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
