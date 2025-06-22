import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/page_item.dart';
import '../models/page_schema.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Get user pages
  Future<List<PageItem>> getUserPages() async {
    try {
      final response = await _supabase
          .rpc('fn_get_user_pages', params: {'p_platform_id': 22});
      final List<dynamic> data = response as List<dynamic>;
      List<PageItem> pages =
          data.map((item) => PageItem.fromJson(item)).toList();
      pages.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return pages;
    } catch (e) {
      print('Error fetching user pages: $e');
      throw Exception('Failed to load user pages. Please check Supabase function permissions and logs.');
    }
  }

  // Get page schema
  Future<PageSchema> getPageSchema(String routeName) async {
    try {
      final response = await _supabase
          .rpc('fn_get_page_schema', params: {'p_route_name': routeName, 'p_platform_id': 22});
      return PageSchema.fromJson(response);
    } catch (e) {
      print('Error fetching page schema: $e');
      throw Exception('Failed to load page schema for route: $routeName');
    }
  }
} 