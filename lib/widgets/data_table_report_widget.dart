import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod/service_providers.dart';
import 'data_table_card_view_widget.dart';
import '../models/page_schema.dart';

class DataTableReportWidget extends ConsumerStatefulWidget {
  final String bindingName;
  final Section? section;
  const DataTableReportWidget(
      {super.key, required this.bindingName, this.section});

  @override
  ConsumerState<DataTableReportWidget> createState() =>
      _DataTableReportWidgetState();
}

class _DataTableReportWidgetState extends ConsumerState<DataTableReportWidget> {
  @override
  Widget build(BuildContext context) {
    final dynamicPageService = ref.read(dynamicPageServiceProvider);

    if (widget.bindingName.isEmpty) {
      return const Center(child: Text('No data to display.'));
    }
    if (widget.section == null) {
      return const Center(child: Text('No section defined.'));
    }
    // Show the data using DataTableCardListWidget
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: dynamicPageService.getBindingListData(widget.bindingName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: \\${snapshot.error}'));
              }
              final data = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: DataTableCardViewWidget(
                    section: widget.section!, data: data),
              );
            },
          ),
        ),
      ],
    );
  }
}
