import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../providers/riverpod/service_providers.dart';
import '../services/navigation_service.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';

class ReadOnlyCardSection extends ConsumerWidget {
  final Section section;

  const ReadOnlyCardSection({super.key, required this.section});

  Map<String, dynamic> _parseRouteAndArgs(String defaultValue, Map<String, dynamic> record) {
    // Example: /agent?id={id}&foo={bar}
    final uri = Uri.parse(defaultValue.startsWith('/') ? defaultValue : '/$defaultValue');
    final route = uri.path.replaceAll('/', '');
    final args = <String, dynamic>{};
    uri.queryParameters.forEach((key, value) {
      final reg = RegExp(r'\{(.+?)\}');
      final match = reg.firstMatch(value);
      if (match != null) {
        final field = match.group(1)!;
        args[key] = record[field]?.toString() ?? '';
      } else {
        args[key] = value;
      }
    });
    return {'route': route, 'args': args};
  }

  void _navigate(BuildContext context, String defaultValue, Map<String, dynamic> record) {
    final parsed = _parseRouteAndArgs(defaultValue, record);
    Navigator.of(context).pop(); // Close dialog before navigating
    NavigationService.navigateTo(parsed['route'], arguments: parsed['args']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicPageService = ref.read(dynamicPageServiceProvider);
    return FutureBuilder<List<dynamic>>(
      future: section.bindingName != null && section.bindingName!.isNotEmpty
          ? dynamicPageService.getBindingListData(section.bindingName!)
          : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text('No records found.'));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((record) {
            // Check for hyperlinkRow control
            final hyperlinkRowControls = section.controls.where((c) => c.controlTypeId == ControlTypes.hyperlinkRow).toList();
            if (hyperlinkRowControls.isNotEmpty) {
              // Render a card with a list of links
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hyperlinkRowControls.map((control) {
                      final routeTemplate = control.data?['default_value']?.toString() ?? '';
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(control.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(routeTemplate),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _navigate(context, routeTemplate, record),
                      );
                    }).toList(),
                  ),
                ),
              );
            }

            // Otherwise, render a card for the record
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () {
                  // If any control is hyperlink, navigate
                  Control? hyperlinkControl;
                  try {
                    hyperlinkControl = section.controls.firstWhere((c) => c.controlTypeId == ControlTypes.hyperlink);
                  } catch (_) {
                    hyperlinkControl = null;
                  }
                  if (hyperlinkControl != null) {
                    final routeTemplate = hyperlinkControl.data?['default_value']?.toString() ?? '';
                    if (routeTemplate.isNotEmpty) {
                      _navigate(context, routeTemplate, record);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: section.controls
                        .where((control) =>
                          control.controlTypeId != ControlTypes.addTableRow &&
                          control.controlTypeId != ControlTypes.deleteTableRow &&
                          control.controlTypeId != ControlTypes.submit &&
                          control.controlTypeId != ControlTypes.hyperlinkRow)
                        .map((control) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                control.name + ': ',
                                style: TextStyle(
                                  fontWeight: control.controlTypeId == ControlTypes.hyperlink
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: control.controlTypeId == ControlTypes.hyperlink
                                      ? Colors.blue
                                      : null,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  (record[control.bindingName]?.toString() ?? ''),
                                  style: TextStyle(
                                    fontWeight: control.controlTypeId == ControlTypes.hyperlink
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: control.controlTypeId == ControlTypes.hyperlink
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
        );
      },
    );
  }
} 