import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../services/navigation_service.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../utils/icon_utils.dart';
import '../utils/navigation_utils.dart';
import 'dart:math';

class DataTableCardListWidget extends StatefulWidget {
  final Section section;
  final List<dynamic> data;
  final int pageSize;
  const DataTableCardListWidget(
      {super.key,
      required this.section,
      required this.data,
      this.pageSize = 20});

  @override
  State<DataTableCardListWidget> createState() =>
      _DataTableCardListWidgetState();
}

class _DataTableCardListWidgetState extends State<DataTableCardListWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int _currentMax = 0;

  @override
  void initState() {
    super.initState();
    _currentMax = widget.pageSize;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_currentMax < _filteredData.length) {
        setState(() {
          _currentMax =
              (_currentMax + widget.pageSize).clamp(0, _filteredData.length);
        });
      }
    }
  }

  List<dynamic> get _filteredData {
    final filtered =
        widget.data.where((record) => _recordMatchesSearch(record)).toList();
    return filtered;
  }

  bool _recordMatchesSearch(Map<String, dynamic> record) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    return record.values.any(
        (value) => value?.toString().toLowerCase().contains(query) ?? false);
  }

  void _navigate(
      BuildContext context, String defaultValue, Map<String, dynamic> record) {
    final parseRouteResult = parseRouteAndArgs(defaultValue, record);
    Navigator.of(context).pop();
    NavigationService.navigateTo(parseRouteResult.routeName,
        arguments: parseRouteResult.args);
  }

  bool isActionControl(Control control) {
    // Add all action controlTypeIds here (hyperlink, transfer, etc.)
    return control.controlTypeId == ControlTypes.hyperlink ||
        control.controlTypeId == ControlTypes.hyperlinkRow;
  }

  // Helper to get nested value from a map using dot notation
  Object? getNestedValue(Map<String, dynamic> map, String? path) {
    if (map.isEmpty || path == null || path.isEmpty) return null;
    var keys = path.split('.');
    dynamic value = map;
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        return null;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredData;
    final totalCount = filteredData.length;
    final pageSize = widget.pageSize;
    final currentPage = (_currentMax / pageSize).ceil();
    final start = totalCount == 0 ? 0 : ((currentPage - 1) * pageSize + 1);
    final end = min(_currentMax, totalCount);
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
                          _currentMax = widget.pageSize;
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
                _currentMax = widget.pageSize;
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: end,
              itemBuilder: (context, index) {
                final record = filteredData[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Render all non-hidden, non-action controls as label-value rows, only if value is not empty
                        ...widget.section.controls
                            .where((control) =>
                                control.displayModeId !=
                                    ControlDisplayModes.noneHidden &&
                                !isActionControl(control))
                            .map((control) {
                          final value =
                              getNestedValue(record, control.bindingName);
                          if (value == null || value.toString().isEmpty)
                            return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${control.name}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    value.toString(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        // Render all action controls as icon+label buttons at the end
                        if (widget.section.controls
                            .any((c) => isActionControl(c)))
                          Row(
                            children: widget.section.controls
                                .where((control) =>
                                    control.displayModeId !=
                                        ControlDisplayModes.noneHidden &&
                                    isActionControl(control))
                                .map((control) {
                              final routeTemplate =
                                  control.data?['default_value']?.toString() ??
                                      '';
                              final iconData =
                                  getIconFromString(control.data?['item_icon']);
                              final iconColor =
                                  hexToColor(control.data?['item_color']);
                              return TextButton.icon(
                                icon: Icon(iconData, color: iconColor),
                                label: Text(control.name),
                                style: TextButton.styleFrom(
                                  foregroundColor: iconColor,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () =>
                                    _navigate(context, routeTemplate, record),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Showing $start to $end of $totalCount entries'),
        ),
      ],
    );
  }
}
