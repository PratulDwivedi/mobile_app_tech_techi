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
import '../utils/navigation_utils.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_button.dart';
import '../screens/search_screen.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../widgets/data_table_report_widget.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/screen_decoration_widget.dart';

class DynamicScreen extends ConsumerStatefulWidget {
  final ScreenArgsModel args;
  const DynamicScreen({super.key, required this.args});

  @override
  ConsumerState<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends ConsumerState<DynamicScreen> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormDataCollectorState> _formDataCollectorKey =
      GlobalKey<FormDataCollectorState>();
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

    if (pageSchema.bindingNamePost == null ||
        pageSchema.bindingNamePost!.isEmpty) {
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

      final parseRouteResult =
          parseRouteAndArgs(widget.args.routeName, widget.args.data);

      // Add the record ID if editing
      if (parseRouteResult.args.isNotEmpty) {
        parseRouteResult.args.forEach((key, value) {
          formData[key] = value;
        });
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
    if (pageSchema.bindingNameGet == null ||
        pageSchema.bindingNameGet!.isEmpty) {
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
    if (pageSchema.bindingNameDelete == null ||
        pageSchema.bindingNameDelete!.isEmpty) {
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
        content: const Text(
            'Are you sure you want to delete this record? This action cannot be undone.'),
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

  void openDataTableReportSection(
      BuildContext context, List<Section> sections) async {
    if (sections.isEmpty) return;

    if (sections.length == 1) {
      final section = sections.first;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(section.name)),
            body: DataTableReportWidget(
                bindingName: section.bindingName!, section: section),
          ),
        ),
      );
    } else {
      final selected = await showModalBottomSheet<Section>(
        context: context,
        builder: (context) => ListView(
          shrinkWrap: true,
          children: sections
              .map((section) => ListTile(
                    title: Text(section.name),
                    onTap: () => Navigator.of(context).pop(section),
                  ))
              .toList(),
        ),
      );
      if (selected != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(selected.name)),
              body: DataTableReportWidget(
                  bindingName: selected.bindingName!, section: selected),
            ),
          ),
        );
      }
    }
  }

  Widget _buildBottomSheet(PageSchema pageSchema) {
    final primaryColor = ref.watch(primaryColorProvider);

    final showSave = (pageSchema.pageTypeId == PageTypes.form) &&
        (pageSchema.bindingNamePost != null &&
            pageSchema.bindingNamePost!.isNotEmpty);

    // check for delete button
    final showDelete = widget.args.data.isNotEmpty &&
        (pageSchema.bindingNameDelete != null &&
            pageSchema.bindingNameDelete!.isNotEmpty);

    // If no button is visible, return SizedBox.shrink()
    if (!showSave && !showDelete) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (showSave)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AppButton(
                  label: _isSaving ? 'Saving...' : 'Save',
                  icon: _isSaving ? Icons.hourglass_empty : Icons.save,
                  color: primaryColor,
                  onPressed: _isSaving
                      ? null
                      : () {
                          _saveForm(pageSchema);
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
                  onPressed: _isSaving
                      ? null
                      : () {
                          _deleteRecord(pageSchema);
                        },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);
    final pageSchemaAsync =
        ref.watch(pageSchemaProvider(widget.args.routeName));
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
              actions: [
                if (pageSchema.pageTypeId == PageTypes.form &&
                    widget.args.data.isEmpty &&
                    pageSchema.sections.any((s) =>
                        s.childDisplayModeId ==
                            ChildDiaplayModes.dataTableReport ||
                        s.childDisplayModeId ==
                            ChildDiaplayModes.dataTableReportAdvance))
                  IconButton(
                    onPressed: () {
                      final reportSections = pageSchema.sections
                          .where((s) =>
                              s.childDisplayModeId ==
                                  ChildDiaplayModes.dataTableReport ||
                              s.childDisplayModeId ==
                                  ChildDiaplayModes.dataTableReportAdvance)
                          .toList();
                      openDataTableReportSection(context, reportSections);
                    },
                    icon: Icon(
                      Icons.search_off_outlined,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    tooltip: 'Section Data',
                  ),
                if (pageSchema.pageTypeId == PageTypes.report &&
                    (pageSchema.bindingNameGet?.isNotEmpty ?? false))
                  IconButton(
                    onPressed: () {
                      _searchData(pageSchema);
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    tooltip: 'Filter Report',
                  ),
                if (widget.args.isHome)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.pageview_sharp,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    tooltip: 'Search Page',
                  ),
                const AppBarMenu(),
              ],
            );
          },
          loading: () => AppBar(
            title: Text(
              widget.args.pageName,
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
              if (widget.args.isHome)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  tooltip: 'Search',
                ),
              const AppBarMenu(),
            ],
          ),
          error: (error, stack) => AppBar(
            title: Text(
              widget.args.pageName,
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
              if (widget.args.isHome)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  tooltip: 'Search',
                ),
              const AppBarMenu(),
            ],
          ),
        ),
      ),
      drawer: widget.args.isHome
          ? userPagesAsync.when(
              data: (pages) => userProfileAsync.when(
                data: (profile) =>
                    AppDrawer(pages: pages, userProfile: profile),
                loading: () => const Drawer(
                    child: Center(child: CircularProgressIndicator())),
                error: (error, stack) => Drawer(
                  child: Center(child: Text('Error: $error')),
                ),
              ),
              loading: () => const Drawer(
                  child: Center(child: CircularProgressIndicator())),
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
      body: ScreenDecorationWidget(
        isDarkMode: isDarkMode,
        primaryColor: primaryColor,
        child: pageSchemaAsync.when(
          data: (pageSchema) {
            if (pageSchema.pageTypeId == PageTypes.report) {
              // Use the first section for columns/controls
              final section = pageSchema.sections.isNotEmpty
                  ? pageSchema.sections.first
                  : null;

              return DataTableReportWidget(
                  bindingName: pageSchema.bindingNameGet!, section: section);
            }
            // Prefill logic
            if (widget.args.data.isNotEmpty &&
                pageSchema.bindingNameGet != null &&
                pageSchema.bindingNameGet!.isNotEmpty) {
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
                    return Center(
                        child: Text('Error loading data: \\${snapshot.error}'));
                  }
                  final result = snapshot.data;
                  Map<String, dynamic> apiData = {};
                  if (result is List &&
                      result.isNotEmpty &&
                      result.first is Map<String, dynamic>) {
                    apiData = result.first as Map<String, dynamic>;
                  } else if (result is Map<String, dynamic>) {
                    apiData = result;
                  } else if (result is List && result.isEmpty) {
                    return const Center(
                        child: Text('No data found to prefill.'));
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
                _formDataCollectorKey.currentState
                    ?.setFormData(widget.args.data);
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
          error: (error, stack) =>
              CustomErrorWidget(error: error, isDarkMode: isDarkMode),
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
      bottomSheet: pageSchemaAsync.when(
        data: (pageSchema) {
          return _buildBottomSheet(pageSchema);
        },
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}
