import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/models/page_item.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/providers/theme_provider.dart';
import 'package:mobile_app_tech_techi/services/dynamic_page/dynamic_page_service.dart';
import 'package:mobile_app_tech_techi/widgets/app_bar_menu.dart';
import 'package:mobile_app_tech_techi/widgets/bottom_navigation_bar.dart';
import 'package:mobile_app_tech_techi/widgets/section_widget.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DynamicScreen extends StatefulWidget {
  final String routeName;
  const DynamicScreen({super.key, required this.routeName});

  @override
  State<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends State<DynamicScreen> {
  final _dynamicPageService = DynamicPageService.instance;
  late Future<PageSchema> _pageSchemaFuture;
  late Future<List<PageItem>> _userPagesFuture;
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1; // Start at 1 since 0 is home

  @override
  void initState() {
    super.initState();
    _pageSchemaFuture = _dynamicPageService.getPageSchema(widget.routeName);
    _userPagesFuture = _dynamicPageService.getUserPages();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<PageSchema>(
          future: _pageSchemaFuture,
          builder: (context, snapshot) {
            String title = widget.routeName.replaceAll('_', ' ').toUpperCase();
            int? pageTypeId;
            if (snapshot.hasData) {
              title = snapshot.data!.name;
              pageTypeId = snapshot.data!.pageTypeId;
            }
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
                    icon: const Icon(LucideIcons.save),
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
                    icon: const Icon(LucideIcons.search),
                    tooltip: 'Search',
                    onPressed: () {
                      // TODO: Implement search/view logic
                    },
                  ),
                const AppBarMenu(),
              ],
            );
          },
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
        child: FutureBuilder<PageSchema>(
          future: _pageSchemaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
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
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
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
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No page schema found.',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final pageSchema = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: pageSchema.sections
                      .map((section) => SectionWidget(section: section, formKey: _formKey))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<List<PageItem>>(
        future: _userPagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }
          return CustomBottomNavigationBar(
            pages: snapshot.data!,
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
          );
        },
      ),
    );
  }
} 