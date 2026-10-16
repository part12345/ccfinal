import 'package:flutter/material.dart';
import '../services/user_storage_service.dart';
import '../theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _target = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final p = await UserStorageService.loadProfile();
    _name.text = p['name'] ?? ''; _email.text = p['email'] ?? ''; _phone.text = p['phone'] ?? ''; _location.text = p['location'] ?? ''; _target.text = p['targetPosition'] ?? '';
    if (mounted) setState(() => _loading = false);
  }
  @override
  void dispose() { _name.dispose(); _email.dispose(); _phone.dispose(); _location.dispose(); _target.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await UserStorageService.saveProfile(
        name: _name.text,
        email: _email.text,
        phone: _phone.text,
        location: _location.text,
        targetPosition: _target.text,
      );
      // Read the profile back to confirm that preferences were written before leaving.
      final saved = await UserStorageService.loadProfile();
      final matches = saved['name'] == _name.text.trim() &&
          saved['email'] == _email.text.trim() &&
          saved['phone'] == _phone.text.trim() &&
          saved['location'] == _location.text.trim() &&
          saved['targetPosition'] == _target.text.trim();
      if (!matches) throw Exception('The profile could not be verified after saving.');
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save profile. Please try again. ($error)')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Edit Profile')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(20), children: [
      Center(child: Container(width: 76, height: 76, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .12), shape: BoxShape.circle), child: Icon(Icons.person_outline, size: 40, color: AppColors.primary))),
      const SizedBox(height: 22),
      _field(_name, 'Full name', Icons.person_outline),
      _field(_email, 'Email address', Icons.email_outlined, keyboard: TextInputType.emailAddress, validator: (v) => v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? 'Enter a valid email address.' : null),
      _field(_phone, 'Phone number', Icons.phone_outlined, keyboard: TextInputType.phone, required: false),
      _field(_location, 'Location', Icons.location_on_outlined),
      _field(_target, 'Target position', Icons.work_outline),
      const SizedBox(height: 12),
      SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save_outlined),
          label: Text(_saving ? 'Saving...' : 'Save Changes'),
        ),
      ),
    ])),
  );

  Widget _field(TextEditingController controller, String label, IconData icon, {TextInputType? keyboard, String? Function(String?)? validator, bool required = true}) => Padding(padding: const EdgeInsets.only(bottom: 14), child: TextFormField(controller: controller, keyboardType: keyboard, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)), validator: validator ?? (v) => required && (v == null || v.trim().isEmpty) ? 'This field is required.' : null));
}
