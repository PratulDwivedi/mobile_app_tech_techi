import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_constants.dart';
import '../providers/riverpod/service_providers.dart';
import 'data_table_card_list_widget.dart';
import '../models/page_schema.dart';

class ReportPage extends ConsumerStatefulWidget {
  final PageSchema pageSchema;
  const ReportPage({super.key, required this.pageSchema});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  @override
  Widget build(BuildContext context) {
    final dynamicPageService = ref.read(dynamicPageServiceProvider);

    // Check if this is a report page and has a bindingNameGet
    final isReport = widget.pageSchema.pageTypeId == PageTypes.report;
    final bindingName = widget.pageSchema.bindingNameGet;

    if (!isReport || bindingName == null || bindingName.isEmpty) {
      return const Center(child: Text('No data to display.'));
    }

    // Show the data using DataTableCardListWidget
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: dynamicPageService.getBindingListData(bindingName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: \\${snapshot.error}'));
              }
              final data = snapshot.data ?? [];
              // Use the first section for columns/controls
              final section = widget.pageSchema.sections.isNotEmpty
                  ? widget.pageSchema.sections.first
                  : null;
              if (section == null) {
                return const Center(child: Text('No section defined.'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: DataTableCardListWidget(section: section, data: data),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Search'),
              onPressed: () {
                // Implement search logic or open search dialog if needed
              },
            ),
          ),
        ),
      ],
    );
  }
}
