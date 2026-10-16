import 'package:flutter/material.dart';

import 'models/job_application.dart';
import 'services/storage_service.dart';
import 'services/user_storage_service.dart';
import 'theme/app_theme.dart';

import 'pages/welcome_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/applications_page.dart';
import 'pages/calendar_page.dart';
import 'pages/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JobTrackApp());
}

class JobTrackApp extends StatefulWidget {
  const JobTrackApp({super.key});

  @override
  State<JobTrackApp> createState() => _JobTrackAppState();
}

class _JobTrackAppState extends State<JobTrackApp> {
  bool darkMode = false;
  bool preferencesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final savedMode = await UserStorageService.loadDarkMode();
    if (!mounted) return;
    setState(() { darkMode = savedMode; preferencesLoaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!preferencesLoaded) {
      return MaterialApp(theme: AppTheme.lightTheme, home: const Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: WelcomePage(
        onThemeChanged: (value) {
          setState(() {
            darkMode = value;
          });
          UserStorageService.saveDarkMode(value);
        },
      ),
    );
  }
}

class JobTrackController extends ChangeNotifier {
  List<JobApplication> applications = [];

  bool darkMode = false;

  bool interviewReminders = true;
  bool applicationReminders = true;
  bool emailNotifications = false;

  Future<void> load() async {
    applications = await StorageService.loadApplications();

    notifyListeners();
  }

  Future<void> save() async {
    await StorageService.saveApplications(applications);
    notifyListeners();
  }

  Future<void> addApplication(JobApplication application) async {
    applications.insert(0, application);
    await save();
  }

  Future<void> updateApplication(JobApplication application) async {
    final index = applications.indexWhere(
      (item) => item.id == application.id,
    );

    if (index != -1) {
      applications[index] = application;
      await save();
    }
  }

  Future<void> deleteApplication(String id) async {
    applications.removeWhere(
      (item) => item.id == id,
    );

    await save();
  }

  Future<void> clearAll() async {
    applications.clear();
    await StorageService.clearApplications();
    notifyListeners();
  }


}

class JobTrackScope extends InheritedNotifier<JobTrackController> {
  const JobTrackScope({
    super.key,
    required JobTrackController controller,
    required super.child,
  }) : super(notifier: controller);

  static JobTrackController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JobTrackScope>()!
        .notifier!;
  }
}

class MainShell extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const MainShell({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  late JobTrackController controller;

  @override
  void initState() {
    super.initState();

    controller = JobTrackController();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        onNavigate: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        onThemeChanged: widget.onThemeChanged,
      ),
      const ApplicationsPage(),
      const CalendarPage(),
      ProfilePage(onThemeChanged: widget.onThemeChanged),
    ];

    return JobTrackScope(
      controller: controller,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: pages[currentIndex],
        ),
        bottomNavigationBar: NavigationBar(
          height: 74,
          selectedIndex: currentIndex,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'Applications',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
