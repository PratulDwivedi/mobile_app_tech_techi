import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/widgets/app_bar_menu.dart';
import 'package:mobile_app_tech_techi/widgets/bottom_navigation_bar.dart';
import 'package:mobile_app_tech_techi/widgets/form_data_collector.dart';
import '../models/screen_args_model.dart';
import '../providers/riverpod/theme_provider.dart';
import '../providers/riverpod/data_providers.dart';
import '../providers/riverpod/service_providers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_button.dart';
import '../screens/search_screen.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../widgets/data_table_report_dialog.dart';


class DynamicScreen extends ConsumerStatefulWidget {
  final ScreenArgsModel args;
  const DynamicScreen({super.key, required this.args});

  @override
  ConsumerState<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends ConsumerState<DynamicScreen> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormDataCollectorState> _formDataCollectorKey = GlobalKey<FormDataCollectorState>();
  int _currentIndex = 1; // Start at 1 since 0 is home
  bool _isSaving = false;

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _saveForm(PageSchema pageSchema) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix validation errors before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (pageSchema.bindingNamePost == null || pageSchema.bindingNamePost!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No save function configured for this form.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final formData = _formDataCollectorKey.currentState?.getFormData() ?? {};
      
      // Add the record ID if editing
      if (widget.args.data['id'] != null && widget.args.data['id']!.isNotEmpty) {
        formData['id'] = widget.args.data['id'];
      }

      // Filter formData to only include allowed binding names (exclude _name fields and buttons)
      final allowedBindingNames = <String>{};
      for (final section in pageSchema.sections) {
        for (final control in section.controls) {
          // Exclude button controls (adjust controlTypeId as needed)
          if (control.controlTypeId == ControlTypes.submit ||
              control.controlTypeId == ControlTypes.addTableRow ||
              control.controlTypeId == ControlTypes.deleteTableRow) continue;
          // Exclude _name fields (display only)
          if (control.bindingName.endsWith('_name')) continue;
          allowedBindingNames.add(control.bindingName);
        }
      }
      final filteredFormData = <String, dynamic>{};
      formData.forEach((key, value) {
        if (allowedBindingNames.contains(key)) {
          filteredFormData[key] = value;
        }
      });

      // ignore: avoid_print
      print('Saving filtered form data: $filteredFormData');

      final dynamicPageService = ref.read(dynamicPageServiceProvider);
      final result = await dynamicPageService.postFormData(
        pageSchema.bindingNamePost!,
        filteredFormData,
      );

      // ignore: avoid_print
      print('Save result: $result');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Form saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form data after successful save
        _formDataCollectorKey.currentState?.clearFormData();
        _formKey.currentState?.reset();
        setState(() {
          _formDataCollectorKey = GlobalKey<FormDataCollectorState>();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error saving form: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _searchData(PageSchema pageSchema) async {
    if (pageSchema.bindingNameGet == null || pageSchema.bindingNameGet!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No search function configured for this report.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final formData = _formDataCollectorKey.currentState?.getFormData() ?? {};
      
      // ignore: avoid_print
      print('Searching with data: $formData');

      final dynamicPageService = ref.read(dynamicPageServiceProvider);
      final result = await dynamicPageService.postFormData(
        pageSchema.bindingNameGet!,
        formData,
      );

      // ignore: avoid_print
      print('Search result: $result');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Search completed!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error searching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteRecord(PageSchema pageSchema) async {
    if (pageSchema.bindingNameDelete == null || pageSchema.bindingNameDelete!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No delete function configured for this record.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
    
      // ignore: avoid_print
      print('Deleting record: $widget.args.data');

      final dynamicPageService = ref.read(dynamicPageServiceProvider);
      final result = await dynamicPageService.postFormData(
        pageSchema.bindingNameDelete!,
        widget.args.data,
      );

      // ignore: avoid_print
      print('Delete result: $result');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Record deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back after successful delete
        Navigator.of(context).pop();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting record: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting record: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);
    final pageSchemaAsync = ref.watch(pageSchemaProvider(widget.args.routeName));
    final userPagesAsync = ref.watch(userPagesProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: pageSchemaAsync.when(
          data: (pageSchema) {
            String title = pageSchema.name;
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
              actions: const [AppBarMenu()],
            );
          },
          loading: () => AppBar(
            title: Text(
              widget.args.routeName.replaceAll('_', ' ').toUpperCase(),
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
              widget.args.routeName.replaceAll('_', ' ').toUpperCase(),
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
      drawer: widget.args.isHome
          ? userPagesAsync.when(
              data: (pages) => userProfileAsync.when(
                data: (profile) => AppDrawer(pages: pages, userProfile: profile),
                loading: () => const Drawer(child: Center(child: CircularProgressIndicator())),
                error: (error, stack) => Drawer(
                  child: Center(child: Text('Error: $error')),
                ),
              ),
              loading: () => const Drawer(child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => Drawer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: $error'),
                  ),
                ),
              ),
            )
          : null,
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
          data: (pageSchema) {
            // Prefill logic
            if (widget.args.data.isNotEmpty && pageSchema.bindingNameGet != null && pageSchema.bindingNameGet!.isNotEmpty) {
              // Need to fetch data from API
              return FutureBuilder<dynamic>(
                future: ref.read(dynamicPageServiceProvider).postFormData(
                  pageSchema.bindingNameGet!,
                  widget.args.data,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading data: \\${snapshot.error}'));
                  }
                  final result = snapshot.data;
                  Map<String, dynamic> apiData = {};
                  if (result is List && result.isNotEmpty && result.first is Map<String, dynamic>) {
                    apiData = result.first as Map<String, dynamic>;
                  } else if (result is Map<String, dynamic>) {
                    apiData = result;
                  } else if (result is List && result.isEmpty) {
                    return const Center(child: Text('No data found to prefill.'));
                  }
                  // Set form data
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _formDataCollectorKey.currentState?.setFormData(apiData);
                  });
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: FormDataCollector(
                        key: _formDataCollectorKey,
                        pageSchema: pageSchema,
                        formKey: _formKey,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  );
                },
              );
            } else if (widget.args.data.isNotEmpty) {
              // Just prefill with args.data
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _formDataCollectorKey.currentState?.setFormData(widget.args.data);
              });
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: FormDataCollector(
                  key: _formDataCollectorKey,
                  pageSchema: pageSchema,
                  formKey: _formKey,
                  child: const SizedBox.shrink(),
                ),
              ),
            );
          },
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
      bottomNavigationBar: widget.args.isHome
          ? userPagesAsync.when(
              data: (pages) => CustomBottomNavigationBar(
                pages: pages,
                currentIndex: _currentIndex,
                onTap: _onBottomNavTap,
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            )
          : null,
      floatingActionButton: widget.args.isHome
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 8,
              child: const Icon(Icons.search),
            )
          : null,
      bottomSheet: pageSchemaAsync.when(
        data: (pageSchema) {
          final pageTypeId = pageSchema.pageTypeId;
          final showSave = pageTypeId == PageTypes.form;
          final showSearch = pageTypeId == PageTypes.report && (pageSchema.bindingNameGet?.isNotEmpty ?? false);
          final showDelete = widget.args.data['id'] != null &&
              widget.args.data['id']!.isNotEmpty &&
              pageSchema.bindingNameDelete!.isNotEmpty;

          // Check if any section is a report/advance
          final hasDataTableReport = pageSchema.sections.any((s) =>
            s.childDisplayModeId == ChildDiaplayModes.dataTableReport ||
            s.childDisplayModeId == ChildDiaplayModes.dataTableReportAdvance);

          // If no button is visible, return SizedBox.shrink()
          if (!showSave && !showSearch && !showDelete && !hasDataTableReport) {
            return const SizedBox.shrink();
          }

          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (hasDataTableReport)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppButton(
                        label: 'Search',
                        icon: Icons.search,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: double.infinity,
                                child: DataTableReportDialog(
                                  sections: pageSchema.sections.where((s) =>
                                    s.childDisplayModeId == ChildDiaplayModes.dataTableReport ||
                                    s.childDisplayModeId == ChildDiaplayModes.dataTableReportAdvance
                                  ).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (showSave)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppButton(
                        label: _isSaving ? 'Saving...' : 'Save',
                        icon: _isSaving ? Icons.hourglass_empty : Icons.save,
                        color: primaryColor,
                        onPressed: _isSaving ? null : () {
                          _saveForm(pageSchema);
                        },
                      ),
                    ),
                  ),
                if (showSearch)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppButton(
                        label: 'Search',
                        icon: Icons.search,
                        color: primaryColor,
                        onPressed: _isSaving ? null : () {
                          _searchData(pageSchema);
                        },
                      ),
                    ),
                  ),
                if (showDelete)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppButton(
                        label: 'Delete',
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: _isSaving ? null : () {
                          _deleteRecord(pageSchema);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}
