enum AppEnv { local, staging, production }

enum ServiceType { supabase, custom }

class AppConfig {
  final String appName;
  final String appVersion;
  final String buildDate;
  final String webSiteUrl;
  final String apiBaseUrl;
  final String localKey;
  final ServiceType serviceType;

  const AppConfig({
    required this.appName,
    required this.appVersion,
    required this.buildDate,
    required this.webSiteUrl,
    required this.apiBaseUrl,
    required this.localKey,
    required this.serviceType,
  });
}

const Map<String, AppConfig> configs = {
  "dev-supabase": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://tpgyuqvncljnuyrohqre.supabase.co',
    localKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwZ3l1cXZuY2xqbnV5cm9ocXJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4NDIxMTMsImV4cCI6MjA2MzQxODExM30.7FbAYzOpsJ7sNGM-2H5kzy5zQLN-SgO2KcRCtTiJu60',
    serviceType: ServiceType.supabase,
  ),
  "staging-supabase": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://tpgyuqvncljnuyrohqre.supabase.co',
    localKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwZ3l1cXZuY2xqbnV5cm9ocXJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4NDIxMTMsImV4cCI6MjA2MzQxODExM30.7FbAYzOpsJ7sNGM-2H5kzy5zQLN-SgO2KcRCtTiJu60',
    serviceType: ServiceType.supabase,
  ),
  "production-supabase": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://tpgyuqvncljnuyrohqre.supabase.co',
    localKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwZ3l1cXZuY2xqbnV5cm9ocXJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4NDIxMTMsImV4cCI6MjA2MzQxODExM30.7FbAYzOpsJ7sNGM-2H5kzy5zQLN-SgO2KcRCtTiJu60',
    serviceType: ServiceType.supabase,
  ),
  "dev-custom": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://api.tech-techi.com',
    localKey: '',
    serviceType: ServiceType.custom,
  ),
  "staging-custom": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://api.tech-techi.com',
    localKey: '',
    serviceType: ServiceType.custom,
  ),
  "production-custom": AppConfig(
    appName: 'Tech Techi',
    appVersion: '0.0.1',
    buildDate: '2024-06-14',
    webSiteUrl: 'https://tech-techi.com',
    apiBaseUrl: 'https://api.tech-techi.com',
    localKey: '',
    serviceType: ServiceType.custom,
  ),
};

// Dynamic environment selection using --dart-define=APP_ENV=dev-supabase  or staging-supabase or production-supabase
// Dynamic environment selection using --dart-define=APP_ENV=dev-custom  or staging-custom or production-custom

const String appEnvString =
    String.fromEnvironment('APP_ENV', defaultValue: 'dev-supabase');

final AppConfig appConfig = configs[appEnvString]!;
