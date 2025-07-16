# Tech Techi Mobile App - AI Agent Instructions

## Project Overview
This is a Flutter mobile application with a dynamic UI system driven by JSON schemas and Supabase backend integration. Key architectural patterns and workflows are documented below.

## Architecture Patterns

### Dynamic UI System
- All screens are configured via JSON schemas defined in `lib/models/page_schema.dart`
- Pages can be forms, reports, dashboards, or lists (see `PageTypes` enum)
- UI sections use different display modes defined in `ChildDisplayModes` enum
- Form controls (text, number, dropdown, etc.) are configured via `ControlTypes` enum

### State Management
- Uses Riverpod for state management (`lib/providers/riverpod/`)
- Service providers are in `service_providers.dart`
- Data providers are in `data_providers.dart`
- Theme management handled in `theme_provider.dart`

### Data Flow
1. JSON schemas define page structure and behavior
2. `DynamicScreen` widget (`lib/screens/dynamic_screen.dart`) renders pages
3. Data collection happens through `FormDataCollector` widget
4. Services in `lib/services/` handle business logic
5. Supabase handles data persistence and real-time updates

## Development Workflows

### Setup & Configuration
```bash
flutter pub get  # Install dependencies
flutter pub run build_runner build  # Generate code if needed
```

### Environment Setup
1. Copy `.env.example` to `.env`
2. Update Supabase credentials in `lib/config/supabase_config.dart`
3. Firebase setup needed for notifications (see `lib/firebase/`)

### Common Development Tasks
- Add new page: Create JSON schema and add route in navigation_service.dart
- Add new control: Extend ControlTypes enum and update form_data_collector.dart
- Add new service: Create in services/ and register in service_providers.dart

## Key Files & Components
- `lib/models/page_schema.dart` - Core schema definitions
- `lib/widgets/form_data_collector.dart` - Main form handling
- `lib/services/dynamic_page/` - Page rendering logic
- `lib/providers/riverpod/` - State management
- `lib/config/app_constants.dart` - Global configuration

## Integration Points
- Supabase: Authentication and data storage
- Firebase: Push notifications
- Material Design 3: UI theming and components
- Flutter Navigation 2.0: Routing system

## Conventions
- Use named routes for navigation
- Follow Material Design 3 guidelines for UI
- Keep page schemas in separate JSON files
- Use service layer for business logic
- Implement error handling at service level
