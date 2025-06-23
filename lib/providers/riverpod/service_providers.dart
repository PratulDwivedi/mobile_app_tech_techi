import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth/auth_service.dart';
import '../../services/dynamic_page/dynamic_page_service.dart';

// Service providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

final dynamicPageServiceProvider = Provider<DynamicPageService>((ref) {
  return DynamicPageService.instance;
}); 