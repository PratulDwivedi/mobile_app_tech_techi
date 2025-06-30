import '../../config/app_config.dart';
import '../../models/page_schema.dart';
import '../../models/page_item.dart';
import 'custom_dynamic_page_service.dart';
import 'supabase_dynamic_page_service.dart';

abstract class DynamicPageService {
  // Factory method to get the concrete implementation
  static DynamicPageService get instance {
    if (appConfig.serviceType == ServiceType.supabase) {
      return SupabaseDynamicPageService();
    } else {
      return CustomDynamicPageService();
    }
  }

  Future<PageSchema> getPageSchema(String routeName);
  Future<List<PageItem>> getUserPages();
  Future<List<dynamic>> getBindingListData(String functionName);
  Future<dynamic> postFormData(
      String functionName, Map<String, dynamic> formData);
}
