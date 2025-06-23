import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/widgets/app_bar_menu.dart';
import 'package:mobile_app_tech_techi/widgets/bottom_navigation_bar.dart';
import 'package:mobile_app_tech_techi/widgets/section_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/riverpod/theme_provider.dart';
import '../providers/riverpod/data_providers.dart';

class DynamicScreen extends ConsumerStatefulWidget {
  final String routeName;
  const DynamicScreen({super.key, required this.routeName});

  @override
  ConsumerState<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends ConsumerState<DynamicScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1; // Start at 1 since 0 is home

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);
    final pageSchemaAsync = ref.watch(pageSchemaProvider(widget.routeName));
    final userPagesAsync = ref.watch(userPagesProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: pageSchemaAsync.when(
          data: (pageSchema) {
            String title = pageSchema.name;
            int? pageTypeId = pageSchema.pageTypeId;
            
            return AppBar(
              title: Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              actions: [
                if (pageTypeId == PageTypes.form)
                  IconButton(
                    icon: Icon(LucideIcons.save, color: primaryColor),
                    tooltip: 'Save',
                    onPressed: () {
                      // TODO: Implement save logic
                      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                        // Save form
                      }
                    },
                  ),
                if (pageTypeId == PageTypes.report)
                  IconButton(
                    icon: Icon(LucideIcons.search, color: primaryColor),
                    tooltip: 'Search',
                    onPressed: () {
                      // TODO: Implement search/view logic
                    },
                  ),
                const AppBarMenu(),
              ],
            );
          },
          loading: () => AppBar(
            title: Text(
              widget.routeName.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            actions: const [AppBarMenu()],
          ),
          error: (error, stack) => AppBar(
            title: Text(
              widget.routeName.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            actions: const [AppBarMenu()],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
          ),
        ),
        child: pageSchemaAsync.when(
          data: (pageSchema) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: pageSchema.sections
                    .map((section) => SectionWidget(section: section, formKey: _formKey))
                    .toList(),
              ),
            ),
          ),
          loading: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          error: (error, stack) => Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: userPagesAsync.when(
        data: (pages) => CustomBottomNavigationBar(
          pages: pages,
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
} 