# Tech Techi Mobile App

A dynamic, configurable Flutter application with Supabase backend integration, featuring dynamic forms, reports, and real-time data management.

## 🏗️ Architecture Overview

### Tech Stack
- **Frontend**: Flutter 3.19+ with Dart
- **State Management**: Riverpod (Provider replacement)
- **Backend**: Supabase (PostgreSQL + Real-time + Auth)
- **UI Framework**: Material Design 3 with custom theming
- **Navigation**: Flutter Navigation 2.0 with custom routing
- **Testing**: Flutter Test with comprehensive widget testing

### Core Principles
- **Dynamic Configuration**: All UI components are driven by JSON schemas
- **Type Safety**: Strong typing with abstract service layers
- **Responsive Design**: Adaptive layouts for various screen sizes
- **Theme Support**: Dark/Light mode with custom color schemes
- **Accessibility**: WCAG compliant with proper semantic labels

## 📁 Project Structure

```
lib/
├── config/                 # App configuration
│   ├── app_constants.dart  # Global constants
│   └── supabase_config.dart # Supabase configuration
├── models/                 # Data models
│   ├── page_schema.dart    # Dynamic page configuration
│   ├── page_item.dart      # Navigation items
│   └── screen_args_model.dart # Screen arguments
├── providers/              # Riverpod state management
│   └── riverpod/
│       ├── data_providers.dart    # Data providers
│       ├── service_providers.dart # Service providers
│       └── theme_provider.dart    # Theme management
├── screens/                # Main application screens
│   ├── login_screen.dart   # Authentication
│   ├── dynamic_screen.dart # Dynamic page renderer
│   └── search_screen.dart  # Global search
├── services/               # Business logic layer
│   ├── auth/               # Authentication services
│   ├── dynamic_page/       # Dynamic page services
│   ├── navigation_service.dart
│   └── toast_service.dart
├── utils/                  # Utility functions
│   ├── icon_utils.dart     # Icon mapping
│   └── navigation_utils.dart # Route parsing
└── widgets/                # Reusable UI components
    ├── form_data_collector.dart
    ├── data_table_report_widget.dart
    ├── screen_decoration_widget.dart
    └── custom_error_widget.dart
```

## 🔧 Key Features & Fixes

### 1. Dynamic Page System

#### Page Types
```dart
enum PageTypes {
  form,      // Data entry forms
  report,    // Data display reports
  dashboard, // Analytics dashboard
  list       // Data listing
}
```

#### Section Types
```dart
enum ChildDisplayModes {
  form,                    // Standard form layout
  dataTable,              // Tabular data display
  dataTableReport,        // Report with filtering
  dataTableReportAdvance, // Advanced report features
  card,                   // Card-based layout
  list                    // List-based layout
}
```

### 2. Control System

#### Control Types
```dart
enum ControlTypes {
  text,           // Text input
  number,         // Numeric input
  email,          // Email validation
  password,       // Obscured input
  dropdown,       // Single select
  treeView,       // Hierarchical select
  multiSelect,    // Multiple selection
  date,           // Date picker
  datetime,       // DateTime picker
  checkbox,       // Boolean input
  radio,          // Single choice
  textarea,       // Multi-line text
  file,           // File upload
  image,          // Image upload
  hyperlink,      // Navigation link
  hyperlinkRow,   // Row-level navigation
  submit,         // Form submission
  addTableRow,    // Dynamic table row
  deleteTableRow, // Remove table row
  button          // Custom action
}
```

#### Control Display Modes
```dart
enum ControlDisplayModes {
  visible,    // Always visible
  hidden,     // Hidden but functional
  readonly,   // Display only
  noneHidden  // Completely hidden
}
```

### 3. Data Binding System

#### Binding Patterns
```dart
// Simple field binding
"bindingName": "field_name"

// Nested object binding (supports dot notation)
"bindingName": "parent.child.field"

// Array binding
"bindingName": "items[0].name"

// Computed field (formula)
"bindingName": "total_price",
"formula": "quantity * unit_price"
```

#### Formula Support
```dart
// Basic arithmetic
"formula": "field1 + field2 - field3"

// Conditional logic
"formula": "IF(status == 'active', amount, 0)"

// String operations
"formula": "CONCAT(first_name, ' ', last_name)"

// Date operations
"formula": "DATEDIFF(end_date, start_date)"
```

### 4. Service Layer Architecture

#### Abstract Service Pattern
```dart
// Abstract base class
abstract class AuthService {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getCurrentUser();
}

// Supabase implementation
class SupabaseAuthService implements AuthService {
  // Implementation details
}

// Factory pattern for easy switching
class AuthServiceFactory {
  static AuthService create() => SupabaseAuthService();
}
```

### 5. State Management (Riverpod)

#### Provider Structure
```dart
// Service providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceFactory.create();
});

// Data providers
final userProfileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getCurrentUser();
});

// Theme providers
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
```

## 📋 Sample Schemas

### 1. Form Page Schema
```json
{
  "id": "user_registration",
  "name": "User Registration",
  "pageTypeId": "form",
  "bindingNamePost": "create_user",
  "bindingNameGet": "get_user",
  "sections": [
    {
      "id": "personal_info",
      "name": "Personal Information",
      "childDisplayModeId": "form",
      "controls": [
        {
          "id": "first_name",
          "name": "First Name",
          "controlTypeId": "text",
          "bindingName": "first_name",
          "displayModeId": "visible",
          "validation": {
            "required": true,
            "minLength": 2,
            "maxLength": 50
          }
        },
        {
          "id": "email",
          "name": "Email Address",
          "controlTypeId": "email",
          "bindingName": "email",
          "displayModeId": "visible",
          "validation": {
            "required": true,
            "pattern": "^[^@]+@[^@]+\\.[^@]+$"
          }
        },
        {
          "id": "department",
          "name": "Department",
          "controlTypeId": "dropdown",
          "bindingName": "department_id",
          "displayModeId": "visible",
          "data": {
            "rpc_name": "get_departments",
            "value_field": "id",
            "display_field": "name"
          }
        }
      ]
    }
  ]
}
```

### 2. Report Page Schema
```json
{
  "id": "sales_report",
  "name": "Sales Report",
  "pageTypeId": "report",
  "bindingNameGet": "get_sales_data",
  "sections": [
    {
      "id": "sales_data",
      "name": "Sales Data",
      "childDisplayModeId": "dataTableReport",
      "controls": [
        {
          "id": "product_name",
          "name": "Product",
          "controlTypeId": "text",
          "bindingName": "product.name",
          "displayModeId": "visible"
        },
        {
          "id": "quantity",
          "name": "Quantity",
          "controlTypeId": "number",
          "bindingName": "quantity",
          "displayModeId": "visible"
        },
        {
          "id": "total_amount",
          "name": "Total Amount",
          "controlTypeId": "number",
          "bindingName": "total_amount",
          "displayModeId": "visible",
          "formula": "quantity * unit_price"
        },
        {
          "id": "view_details",
          "name": "View Details",
          "controlTypeId": "hyperlinkRow",
          "bindingName": "id",
          "displayModeId": "visible",
          "data": {
            "default_value": "/sales/details/{id}",
            "item_icon": "visibility",
            "item_color": "#2196F3"
          }
        }
      ]
    }
  ]
}
```

### 3. Dashboard Page Schema
```json
{
  "id": "dashboard",
  "name": "Dashboard",
  "pageTypeId": "dashboard",
  "sections": [
    {
      "id": "summary_cards",
      "name": "Summary",
      "childDisplayModeId": "card",
      "controls": [
        {
          "id": "total_sales",
          "name": "Total Sales",
          "controlTypeId": "number",
          "bindingName": "total_sales",
          "displayModeId": "visible",
          "data": {
            "rpc_name": "get_sales_summary",
            "format": "currency"
          }
        }
      ]
    },
    {
      "id": "sales_chart",
      "name": "Sales Trend",
      "childDisplayModeId": "chart",
      "controls": [
        {
          "id": "chart_data",
          "name": "Chart",
          "controlTypeId": "chart",
          "bindingName": "chart_data",
          "displayModeId": "visible",
          "data": {
            "rpc_name": "get_sales_chart_data",
            "chart_type": "line",
            "x_axis": "date",
            "y_axis": "amount"
          }
        }
      ]
    }
  ]
}
```

## 🔄 Dynamic Controls

### 1. Dropdown Control
```json
{
  "controlTypeId": "dropdown",
  "bindingName": "category_id",
  "data": {
    "rpc_name": "get_categories",
    "value_field": "id",
    "display_field": "name",
    "searchable": true,
    "multiple": false
  }
}
```

### 2. Tree View Control
```json
{
  "controlTypeId": "treeView",
  "bindingName": "department_id",
  "data": {
    "rpc_name": "get_department_tree",
    "value_field": "id",
    "display_field": "name",
    "parent_field": "parent_id",
    "searchable": true,
    "multiple": false
  }
}
```

### 3. Multi-Select Control
```json
{
  "controlTypeId": "multiSelect",
  "bindingName": "tags",
  "data": {
    "rpc_name": "get_tags",
    "value_field": "id",
    "display_field": "name",
    "searchable": true,
    "multiple": true
  }
}
```

## 🎨 UI Components

### 1. Screen Decoration Widget
```dart
ScreenDecorationWidget(
  isDarkMode: isDarkMode,
  primaryColor: primaryColor,
  child: YourContent(),
)
```

### 2. Form Data Collector
```dart
FormDataCollector(
  key: _formDataCollectorKey,
  pageSchema: pageSchema,
  formKey: _formKey,
  child: YourFormContent(),
)
```

### 3. Data Table Report Widget
```dart
DataTableReportWidget(
  bindingName: pageSchema.bindingNameGet!,
  section: section,
)
```

## 🔐 Authentication & Authorization

### Login Flow
1. User enters credentials
2. Validation occurs client-side
3. Supabase authentication
4. User profile loading
5. Navigation to home screen

### Route Guards
```dart
// Protected routes require authentication
if (!isAuthenticated) {
  return LoginScreen();
}
```

## 🧪 Testing Strategy

### Widget Tests
```dart
testWidgets('Login screen validation', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: LoginScreen()),
    ),
  );
  
  // Test validation logic
  expect(find.text('Please enter a valid email'), findsOneWidget);
});
```

### Service Tests
```dart
test('Auth service login', () async {
  final authService = SupabaseAuthService();
  final result = await authService.login('test@example.com', 'password');
  expect(result['success'], isTrue);
});
```

## 🚀 Deployment

### Build Commands
```bash
# Development
flutter run

# Production build
flutter build apk --release
flutter build ios --release

# Web build
flutter build web --release
```

### Environment Configuration
```dart
// config/supabase_config.dart
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
```

## 🔧 Common Issues & Solutions

### 1. Widget Not Found in Tests
**Problem**: Widgets not rendering in test environment
**Solution**: Wrap widgets in proper providers and wait for async operations
```dart
await tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(home: YourWidget()),
  ),
);
await tester.pumpAndSettle(); // Wait for async operations
```

### 2. Expanded Widget Errors
**Problem**: Expanded widget outside Flex container
**Solution**: Wrap in Row/Column
```dart
Row(
  children: [
    Expanded(child: YourWidget()),
  ],
)
```

### 3. Navigation Issues
**Problem**: Route not found or navigation fails
**Solution**: Ensure proper route registration and parameter passing
```dart
// Use NavigationService for consistent navigation
NavigationService.navigateTo('/route', arguments: data);
```

### 4. State Management Issues
**Problem**: State not updating or providers not working
**Solution**: Ensure proper provider scope and dependency injection
```dart
// Wrap app in ProviderScope
ProviderScope(
  child: MyApp(),
)
```

## 📚 API Reference

### Supabase RPC Functions
```sql
-- Get user pages
CREATE OR REPLACE FUNCTION get_user_pages(user_id UUID)
RETURNS TABLE (
  id TEXT,
  name TEXT,
  route_name TEXT,
  icon TEXT,
  parent_id TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT p.id, p.name, p.route_name, p.icon, p.parent_id
  FROM pages p
  JOIN user_page_permissions upp ON p.id = upp.page_id
  WHERE upp.user_id = get_user_pages.user_id
  ORDER BY p.sort_order;
END;
$$ LANGUAGE plpgsql;
```

### Dynamic Page Functions
```sql
-- Get page schema
CREATE OR REPLACE FUNCTION get_page_schema(page_route TEXT)
RETURNS JSON AS $$
BEGIN
  RETURN (
    SELECT json_build_object(
      'id', p.id,
      'name', p.name,
      'pageTypeId', p.page_type_id,
      'bindingNameGet', p.binding_name_get,
      'bindingNamePost', p.binding_name_post,
      'bindingNameDelete', p.binding_name_delete,
      'sections', p.sections
    )
    FROM pages p
    WHERE p.route_name = get_page_schema.page_route
  );
END;
$$ LANGUAGE plpgsql;
```

## 🤝 Contributing

### Development Workflow
1. Create feature branch
2. Implement changes with tests
3. Run test suite: `flutter test`
4. Submit pull request
5. Code review and merge

### Code Standards
- Follow Dart/Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features
- Update documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the documentation
2. Search existing issues
3. Create new issue with detailed description
4. Include error logs and reproduction steps

---

**Note**: This documentation serves as a comprehensive guide for understanding, maintaining, and extending the Tech Techi mobile application. It should be updated whenever significant changes are made to the system architecture or functionality.
