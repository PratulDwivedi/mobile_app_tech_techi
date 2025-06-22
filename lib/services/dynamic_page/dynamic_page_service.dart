import '../../models/page_schema.dart';
import '../../models/page_item.dart';
import 'supabase_dynamic_page_service.dart';

abstract class DynamicPageService {
  // Factory method to get the concrete implementation
  static DynamicPageService get instance => SupabaseDynamicPageService();

  Future<PageSchema> getPageSchema(String routeName);
  Future<List<PageItem>> getUserPages();
} 