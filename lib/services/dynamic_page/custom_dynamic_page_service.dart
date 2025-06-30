import '../../models/page_item.dart';
import '../../models/page_schema.dart';
import 'dynamic_page_service.dart';
import 'api_helper.dart';

class CustomDynamicPageService implements DynamicPageService {
  @override
  Future<PageSchema> getPageSchema(String routeName) async {
    try {
      final response = await ApiHelper.get(
        'schema/$routeName',
      );
      return PageSchema.fromJson(response);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching page schema: $e');
      throw Exception('Failed to load page schema for route: $routeName');
    }
  }

  @override
  Future<List<PageItem>> getUserPages() async {
    try {
      final response = await ApiHelper.get('userPages');
      final List<dynamic> data = response as List<dynamic>;
      List<PageItem> pages =
          data.map((item) => PageItem.fromJson(item)).toList();
      pages.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return pages;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user pages: $e');
      throw Exception(
          'Failed to load user pages. Please check API function permissions and logs.');
    }
  }

  @override
  Future<List<dynamic>> getBindingListData(String functionName) async {
    try {
      final response = await ApiHelper.get(functionName);
      return response as List<dynamic>;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching binding list data from $functionName: $e');
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
      final response = await ApiHelper.post(functionName, formData);
      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Error posting form data to $functionName: $e');
      throw Exception('Failed to post form data: $e');
    }
  }
}
