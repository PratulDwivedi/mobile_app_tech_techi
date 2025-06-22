import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_auth_service.dart';

abstract class AuthService {
  // Factory method to get the concrete implementation
  static AuthService get instance => SupabaseAuthService();

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