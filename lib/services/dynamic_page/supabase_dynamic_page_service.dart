import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/page_item.dart';
import '../../models/page_schema.dart';
import 'dynamic_page_service.dart';

class SupabaseDynamicPageService implements DynamicPageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<PageSchema> getPageSchema(String routeName) async {
    try {
      final response = await _supabase.rpc('fn_get_page_schema',
          params: {'p_route_name': routeName, 'p_platform_id': 22});
      return PageSchema.fromJson(response);
    } catch (e) {
      // Mute linting warning for print statement in a catch block
      // ignore: avoid_print
      print('Error fetching page schema: $e');
      throw Exception('Failed to load page schema for route: $routeName');
    }
  }

  @override
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
      // Mute linting warning for print statement in a catch block
      // ignore: avoid_print
      print('Error fetching user pages: $e');
      throw Exception(
          'Failed to load user pages. Please check Supabase function permissions and logs.');
    }
  }
} 