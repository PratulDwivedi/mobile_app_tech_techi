import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/page_item.dart';
import '../../models/page_schema.dart';
import 'service_providers.dart';

// User pages provider
final userPagesProvider = FutureProvider<List<PageItem>>((ref) async {
  final service = ref.read(dynamicPageServiceProvider);
  return await service.getUserPages();
});

// Page schema provider (family provider for different route names)
final pageSchemaProvider = FutureProvider.family<PageSchema, String>((ref, routeName) async {
  final service = ref.read(dynamicPageServiceProvider);
  return await service.getPageSchema(routeName);
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final service = ref.read(authServiceProvider);
  return service.authStateChanges.map((event) => event.session?.user);
});

// User profile provider
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  
  final service = ref.read(authServiceProvider);
  return await service.getProfile(user.email!);
});

// Authentication state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final service = ref.read(authServiceProvider);
  return service.authStateChanges;
});

// User profile from shared preferences (for UI display)
final userProfileFromPrefsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // This would be implemented to load from SharedPreferences
  // For now, we'll return null and handle it in the UI
  return null;
}); 