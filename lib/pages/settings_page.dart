import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'welcome_page.dart';
import '../services/user_storage_service.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final Future<void> Function() onClearApplications;
  const SettingsPage({super.key, required this.onThemeChanged, required this.onClearApplications});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;

  @override
  void initState() { super.initState(); _loadDarkMode(); }
  Future<void> _loadDarkMode() async { final value = await UserStorageService.loadDarkMode(); if (mounted) setState(() => darkMode = value); }
  bool interviewReminders = true;
  bool applicationReminders = true;
  bool emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // APPEARANCE
              // ============================================================

              _sectionTitle('Appearance'),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: AppColors.primary,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: darkMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() { darkMode = value; });
                        UserStorageService.saveDarkMode(value);
                        widget.onThemeChanged(value);
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.language_outlined,
                    iconColor: AppColors.blue,
                    title: 'Language',
                    subtitle: 'English',
                    showArrow: true,
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============================================================
              // NOTIFICATIONS
              // ============================================================

              _sectionTitle('Notifications'),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: Icons.event_available_outlined,
                    iconColor: AppColors.green,
                    title: 'Interview Reminders',
                    trailing: Switch(
                      value: interviewReminders,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          interviewReminders = value;
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: AppColors.primary,
                    title: 'Application Reminders',
                    trailing: Switch(
                      value: applicationReminders,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          applicationReminders = value;
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.email_outlined,
                    iconColor: AppColors.textMedium,
                    title: 'Email Notifications',
                    trailing: Switch(
                      value: emailNotifications,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          emailNotifications = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============================================================
              // DATA
              // ============================================================

              _sectionTitle('Data'),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    title: 'Export Applications',
                    showArrow: true,
                    onTap: () {
                      _showMessage(
                        'Application data exported successfully.',
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.delete_outline,
                    iconColor: AppColors.red,
                    title: 'Clear All Applications',
                    titleColor: AppColors.red,
                    showArrow: true,
                    onTap: () {
                      _showClearConfirmation();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============================================================
              // ACCOUNT
              // ============================================================

              _sectionTitle('Account'),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    title: 'Back to Profile',
                    showArrow: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.lock_outline,
                    iconColor: AppColors.purple,
                    title: 'Change Password',
                    showArrow: true,
                    onTap: () {
                      _showMessage(
                        'Change password feature coming soon.',
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  _settingsTile(
                    icon: Icons.logout,
                    iconColor: AppColors.red,
                    title: 'Logout',
                    titleColor: AppColors.red,
                    showArrow: true,
                    onTap: () {
                      _showLogoutConfirmation();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ============================================================
              // APP VERSION
              // ============================================================

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.work_outline,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'JobTrack',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your Job Application Tracker',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _settingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool showArrow = false,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (trailing != null) trailing,

            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Language',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: RadioGroup<String>(
            groupValue: 'English',
            onChanged: (value) {
              Navigator.pop(context);
              if (value == 'Filipino') {
                _showMessage('Filipino language will be available soon.');
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'English',
                  title: Text('English'),
                ),
                RadioListTile<String>(
                  value: 'Filipino',
                  title: Text('Filipino'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CLEAR DATA CONFIRMATION
  // ============================================================

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.redLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline,
              color: AppColors.red,
              size: 30,
            ),
          ),
          title: Text(
            'Clear All Applications?',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'This will remove all saved job applications. '
            'This action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await widget.onClearApplications();
                if (!mounted) return;
                Navigator.of(context).pop();
                _showMessage('All applications have been cleared.');
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGOUT CONFIRMATION
  // ============================================================

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.redLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout,
              color: AppColors.red,
              size: 28,
            ),
          ),
          title: Text(
            'Logout?',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await UserStorageService.logout();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomePage(onThemeChanged: widget.onThemeChanged)),
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
