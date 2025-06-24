import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../providers/riverpod/service_providers.dart';

class ReadOnlyCardSection extends ConsumerWidget {
  final Section section;

  const ReadOnlyCardSection({super.key, required this.section});

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
          children: data.map((record) => Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: section.controls.map((control) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        control.name + ': ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          (record[control.bindingName]?.toString() ?? ''),
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          )).toList(),
        );
      },
    );
  }
} 