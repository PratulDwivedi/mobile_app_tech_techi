import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/app_constants.dart';
import 'auth_service.dart';
import '../dynamic_page/api_helper.dart';

class CustomAuthService implements AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final authResponse = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authResponse.user != null) {
      try {
        final profileResponse = await getProfile(email);
        return {
          'authResponse': authResponse,
          'profile': profileResponse,
        };
      } catch (e) {
        print('Error fetching user profile: $e');
        return {
          'authResponse': authResponse,
          'profile': null,
        };
      }
    }

    return {
      'authResponse': authResponse,
      'profile': null,
    };
  }

  @override
  Future<Map<String, dynamic>> getProfile(String email) async {
    try {
      final response = await ApiHelper.get('profile', params: {'email': email});
      if (response is List && response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Invalid profile response format');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
