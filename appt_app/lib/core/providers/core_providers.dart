import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(secureStorageProvider);
  return createDioClient(storage, onUnauthorized: () {
    // Handled by AuthNotifier watching token state
  });
});
