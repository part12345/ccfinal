import 'package:flutter/material.dart';
import '../main.dart';
import '../services/user_storage_service.dart';
import '../theme/app_theme.dart';

class WelcomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const WelcomePage({super.key, required this.onThemeChanged});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool loginMode = false;
  bool busy = false;
  bool obscurePassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _resumeSession();
  }

  Future<void> _resumeSession() async {
    if (await UserStorageService.isLoggedIn() && mounted) _openApp();
  }

  @override
  void dispose() {
    nameController.dispose(); emailController.dispose(); passwordController.dispose(); confirmController.dispose();
    super.dispose();
  }

  void _openApp() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainShell(onThemeChanged: widget.onThemeChanged)));
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => busy = true);
    String? error;
    if (loginMode) {
      error = await UserStorageService.login(email: emailController.text, password: passwordController.text);
    } else {
      error = await UserStorageService.createAccount(name: nameController.text, email: emailController.text, password: passwordController.text);
    }
    if (!mounted) return;
    setState(() => busy = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      _openApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3730A3), Color(0xFF4F46E5), Color(0xFF8B5CF6)])),
        child: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Column(children: [
          Container(width: 78, height: 78, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(24)), child: Icon(Icons.business_center_rounded, color: Colors.white, size: 42)),
          const SizedBox(height: 16),
          Text('JobTrack', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('Your Job Application Tracker', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          Text(loginMode ? 'Welcome back!' : 'Build your future, one application at a time.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(22)), child: Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(loginMode ? 'Log in' : 'Create your account', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 6),
            Text(loginMode ? 'Continue tracking your job applications.' : 'Create an account before using JobTrack.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 18),
            if (!loginMode) ...[
              TextFormField(controller: nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)), validator: (v) => !loginMode && (v == null || v.trim().isEmpty) ? 'Enter your full name.' : null),
              const SizedBox(height: 12),
            ],
            TextFormField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined)), validator: (v) { if (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter a valid email address.'; return null; }),
            const SizedBox(height: 12),
            TextFormField(controller: passwordController, obscureText: obscurePassword, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => setState(() => obscurePassword = !obscurePassword))), validator: (v) { if (v == null || v.length < 6) return 'Use at least 6 characters.'; return null; }),
            if (!loginMode) ...[
              const SizedBox(height: 12),
              TextFormField(controller: confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_reset_outlined)), validator: (v) => !loginMode && v != passwordController.text ? 'Passwords do not match.' : null),
            ],
            const SizedBox(height: 18),
            SizedBox(height: 50, child: ElevatedButton(onPressed: busy ? null : _submit, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))), child: busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(loginMode ? 'Log In' : 'Create Account', style: TextStyle(fontWeight: FontWeight.w800)))),
            const SizedBox(height: 10),
            TextButton(onPressed: () => setState(() { loginMode = !loginMode; }), child: Text(loginMode ? 'New to JobTrack? Create an account' : 'Already have an account? Log in')),
          ]))),
          const SizedBox(height: 18),
          Text('Your applications are saved on this device.', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ])))))),
    );
  }
}
