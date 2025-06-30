import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/app_config.dart';
import 'custom_auth_service.dart';
import 'supabase_auth_service.dart';

abstract class AuthService {
  // Factory method to get the concrete implementation
  static AuthService get instance {
    if (appConfig.serviceType == ServiceType.supabase) {
      return SupabaseAuthService();
    } else {
      return CustomAuthService();
    }
  }

  User? get currentUser;
  Stream<AuthState> get authStateChanges;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> getProfile(String email);

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);
}
