import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import '../providers/riverpod/service_providers.dart';
import 'data_table_card_list_widget.dart';
import 'skeleton_card_widget.dart';

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
          return SkeletonCardListWidget(
            cardCount: 3,
            fieldCount: widget.section.controls.length,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        } else {
          final data = snapshot.data ?? [];
          return DataTableCardListWidget(
            section: widget.section,
            data: data,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          );
        }
      },
    );
  }
}
