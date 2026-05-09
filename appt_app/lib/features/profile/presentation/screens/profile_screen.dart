import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/domain/entities/profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/image_picker_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bioCtrl;

  /// Holds a newly picked base64 avatar during an edit session.
  /// Null means "no change to avatar this edit cycle".
  String? _pendingAvatarBase64;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _startEditing(Profile profile) {
    _nameCtrl.text = profile.displayName;
    _phoneCtrl.text = profile.phoneNumber ?? '';
    _bioCtrl.text = profile.bio ?? '';
    _pendingAvatarBase64 = null;
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    _pendingAvatarBase64 = null;
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    try {
      await ref.read(profileProvider.notifier).updateProfile(
            _nameCtrl.text.trim(),
            _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
            _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
            avatarUrl: _pendingAvatarBase64,
          );
      if (mounted) {
        _pendingAvatarBase64 = null;
        setState(() => _isEditing = false);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (profileState is ProfileLoaded && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit profile',
              onPressed: () => _startEditing(profileState.profile),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _cancelEditing,
              child: const Text('Cancel'),
            ),
        ],
      ),
      body: switch (profileState) {
        ProfileLoading() => const Center(child: CircularProgressIndicator()),
        ProfileError(message: final msg) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $msg'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(profileProvider.notifier).loadProfile(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ProfileLoaded(profile: final p) =>
          _buildBody(context, p, false),
        ProfileSaving(profile: final p) =>
          _buildBody(context, p, true),
      },
    );
  }

  Widget _buildBody(BuildContext context, Profile profile, bool isSaving) {
    // When editing, show the pending avatar; otherwise show the saved one.
    final displayAvatar = _isEditing
        ? (_pendingAvatarBase64 ?? profile.avatarUrl)
        : profile.avatarUrl;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Center(
            child: ImagePickerAvatar(
              displayName: profile.displayName,
              avatarBase64: displayAvatar,
              isEditing: _isEditing,
              onImagePicked: (base64) =>
                  setState(() => _pendingAvatarBase64 = base64),
            ),
          ),
          const SizedBox(height: 24),
          if (!_isEditing) ...[
            _InfoTile(label: 'Name', value: profile.displayName),
            _InfoTile(label: 'Email', value: profile.email),
            _InfoTile(label: 'Phone', value: profile.phoneNumber ?? '—'),
            _InfoTile(label: 'Bio', value: profile.bio ?? '—'),
          ] else ...[
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: profile.email,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioCtrl,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : _saveProfile,
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ],
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(),
        ],
      ),
    );
  }
}
