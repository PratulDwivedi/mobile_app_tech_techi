import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/app_constants.dart';
import '../../models/page_item.dart';
import '../../models/page_schema.dart';
import 'dynamic_page_service.dart';

class SupabaseDynamicPageService implements DynamicPageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<PageSchema> getPageSchema(String routeName) async {
    try {
      final response = await _supabase.rpc(ApiRoutes.pageSchema,
          params: {'p_route_name': routeName, 'p_platform_id': 22});
      return PageSchema.fromJson(response["data"]);
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
          .rpc(ApiRoutes.userPages, params: {'p_platform_id': 22});
      final List<dynamic> data = response["data"] as List<dynamic>;
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

  @override
  Future<List<dynamic>> getBindingListData(String functionName) async {
    try {
      final response = await _supabase.rpc(functionName);
      return response["data"] as List<dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching binding list data from $functionName: $e');

      // Provide more specific error messages
      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        throw Exception(
            'Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception(
            'Request timeout: The server took too long to respond. Please try again.');
      } else if (e.toString().contains('unauthorized') ||
          e.toString().contains('401')) {
        throw Exception(
            'Unauthorized: You are not authorized to access this data. Please log in again.');
      } else if (e.toString().contains('not found') ||
          e.toString().contains('404')) {
        throw Exception('Data not found: The requested data is not available.');
      } else if (e.toString().contains('function') ||
          e.toString().contains('procedure')) {
        throw Exception(
            'Server error: The data function is not available or has an error.');
      } else {
        throw Exception('Failed to load data. Please try again later.');
      }
    }
  }

  @override
  Future<dynamic> postFormData(
      String functionName, Map<String, dynamic> formData) async {
    try {
      // Prefix each key with 'p_'
      final Map<String, dynamic> prefixedParams = {
        for (final entry in formData.entries) 'p_${entry.key}': entry.value
      };
      // ignore: avoid_print
      print('Posting form data to $functionName: $prefixedParams');
      final response =
          await _supabase.rpc(functionName, params: prefixedParams);
      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Error posting form data to $functionName: $e');
      throw Exception('Failed to post form data: $e');
    }
  }
}
