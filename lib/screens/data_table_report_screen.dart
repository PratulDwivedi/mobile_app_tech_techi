import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/page_schema.dart';
import '../providers/riverpod/theme_provider.dart';
import '../widgets/data_table_report_widget.dart';
import '../widgets/screen_decoration_widget.dart';

class DataTableReportScreen extends ConsumerStatefulWidget {
  final Section section;
  const DataTableReportScreen({super.key, required this.section});

  @override
  ConsumerState<DataTableReportScreen> createState() =>
      _DataTableReportScreenState();
}

class _DataTableReportScreenState extends ConsumerState<DataTableReportScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            widget.section.name,
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
        ),
      ),
      body: ScreenDecorationWidget(
        isDarkMode: isDarkMode,
        primaryColor: primaryColor,
        child: DataTableReportWidget(
            bindingName: widget.section.bindingName!, section: widget.section),
      ),
    );
  }
}
