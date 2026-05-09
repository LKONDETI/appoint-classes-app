import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// A circular avatar widget that:
/// - Displays a profile image from a base64 string when [avatarBase64] is set
/// - Falls back to initials when there is no image
/// - In [isEditing] mode, shows a camera-icon overlay and opens the image
///   picker on tap (gallery + camera choice)
/// - Reports the newly picked base64 string via [onImagePicked]
class ImagePickerAvatar extends StatelessWidget {
  final String displayName;
  final String? avatarBase64;
  final bool isEditing;
  final ValueChanged<String>? onImagePicked;

  const ImagePickerAvatar({
    super.key,
    required this.displayName,
    this.avatarBase64,
    this.isEditing = false,
    this.onImagePicked,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _pickImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    // Compress further to keep base64 payload small (< 100 KB target)
    final compressed = await FlutterImageCompress.compressWithFile(
      picked.path,
      minWidth: 256,
      minHeight: 256,
      quality: 75,
      format: CompressFormat.jpeg,
    );
    if (compressed == null) return;

    final base64Str = base64Encode(compressed);
    onImagePicked?.call(base64Str);
  }

  Future<ImageSource?> _showSourceDialog(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    ImageProvider? imageProvider;
    if (avatarBase64 != null && avatarBase64!.isNotEmpty) {
      try {
        imageProvider = MemoryImage(base64Decode(avatarBase64!));
      } catch (_) {
        imageProvider = null;
      }
    }

    final avatar = CircleAvatar(
      radius: 52,
      backgroundColor: scheme.primaryContainer,
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Text(
              _initials(displayName),
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: scheme.onPrimaryContainer,
              ),
            )
          : null,
    );

    if (!isEditing) return avatar;

    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Stack(
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: scheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
