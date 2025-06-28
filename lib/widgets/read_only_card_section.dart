import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../providers/riverpod/service_providers.dart';
import '../services/navigation_service.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../utils/navigation_utils.dart';

class DataTableReportSectionWidget extends ConsumerStatefulWidget {
  final Section section;
  const DataTableReportSectionWidget({super.key, required this.section});

  @override
  ConsumerState<DataTableReportSectionWidget> createState() =>
      _DataTableReportSectionWidgetState();
}

class _DataTableReportSectionWidgetState
    extends ConsumerState<DataTableReportSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final dynamicPageService = ref.read(dynamicPageServiceProvider);
    return FutureBuilder<List<dynamic>>(
      future: widget.section.bindingName != null &&
              widget.section.bindingName!.isNotEmpty
          ? dynamicPageService.getBindingListData(widget.section.bindingName!)
          : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final data = snapshot.data ?? [];
        return DataTableCardListWidget(section: widget.section, data: data);
      },
    );
  }
}

class DataTableCardListWidget extends StatefulWidget {
  final Section section;
  final List<dynamic> data;
  const DataTableCardListWidget(
      {super.key, required this.section, required this.data});

  @override
  State<DataTableCardListWidget> createState() =>
      _DataTableCardListWidgetState();
}

class _DataTableCardListWidgetState extends State<DataTableCardListWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _recordMatchesSearch(Map<String, dynamic> record) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    return record.values.any(
        (value) => value?.toString().toLowerCase().contains(query) ?? false);
  }

  void _navigate(
      BuildContext context, String defaultValue, Map<String, dynamic> record) {
    final parsed = parseRouteAndArgs(defaultValue, record);
    Navigator.of(context).pop();
    NavigationService.navigateTo(parsed['route'], arguments: parsed['args']);
  }

  @override
  Widget build(BuildContext context) {
    final filteredData =
        widget.data.where((record) => _recordMatchesSearch(record)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        if (filteredData.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('No records found.')),
          )
        else
          ...filteredData.map((record) {
            final hyperlinkRowControls = widget.section.controls
                .where((c) => c.controlTypeId == ControlTypes.hyperlinkRow)
                .toList();
            if (hyperlinkRowControls.isNotEmpty) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hyperlinkRowControls.map((control) {
                      final routeTemplate =
                          control.data?['default_value']?.toString() ?? '';
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(control.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(routeTemplate),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _navigate(context, routeTemplate, record),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () {
                  Control? hyperlinkControl;
                  try {
                    hyperlinkControl = widget.section.controls.firstWhere(
                        (c) => c.controlTypeId == ControlTypes.hyperlink);
                  } catch (_) {
                    hyperlinkControl = null;
                  }
                  if (hyperlinkControl != null) {
                    final routeTemplate =
                        hyperlinkControl.data?['default_value']?.toString() ??
                            '';
                    if (routeTemplate.isNotEmpty) {
                      _navigate(context, routeTemplate, record);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.section.controls
                        .where((control) =>
                            control.controlTypeId != ControlTypes.addTableRow &&
                            control.controlTypeId !=
                                ControlTypes.deleteTableRow &&
                            control.controlTypeId != ControlTypes.submit &&
                            control.controlTypeId != ControlTypes.hyperlinkRow)
                        .map((control) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    control.name + ': ',
                                    style: TextStyle(
                                      fontWeight: control.controlTypeId ==
                                              ControlTypes.hyperlink
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: control.controlTypeId ==
                                              ControlTypes.hyperlink
                                          ? Colors.blue
                                          : null,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (record[control.bindingName]
                                              ?.toString() ??
                                          ''),
                                      style: TextStyle(
                                        fontWeight: control.controlTypeId ==
                                                ControlTypes.hyperlink
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: control.controlTypeId ==
                                                ControlTypes.hyperlink
                                            ? Colors.blue
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
