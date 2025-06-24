import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../providers/riverpod/theme_provider.dart';
import 'control_widget.dart';
import 'multi_entry_form_section.dart';
import 'read_only_card_section.dart';

class SectionWidget extends ConsumerWidget {
  final Section section;
  final GlobalKey<FormState> formKey;
  final Function(String bindingName, dynamic value)? onValueChanged;

  const SectionWidget({
    super.key,
    required this.section,
    required this.formKey,
    this.onValueChanged,
  });

  Widget SectionTitle(primaryColor, Section section) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        section.name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);

    switch (section.childDisplayModeId) {
      case ChildDiaplayModes.dataTable:
        return MultiEntryFormSection(
          section: section,
          formKey: formKey,
          onValueChanged: onValueChanged,
        );
      case ChildDiaplayModes.dataTableReport:
      case ChildDiaplayModes.dataTableReportAdvance:
        //return ReadOnlyCardSection(section: section);
        return Container();
      case ChildDiaplayModes.googleMap:
        // Placeholder for Google Map rendering
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(primaryColor, section),
              const SizedBox(height: 24),
              // TODO: Replace with actual Google Map widget
              const Center(
                  child: Text('Google Map rendering not implemented yet.')),
            ],
          ),
        );
      case ChildDiaplayModes.form:
      default:
        // Default: Render as form section
        return Container(
          margin: const EdgeInsets.only(bottom: 80),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SectionTitle(primaryColor, section),
              ...section.controls.map((control) =>
                  ControlWidget(
                    control: control, 
                    formKey: formKey,
                    onValueChanged: onValueChanged,
                  )),
            ],
          ),
        );
    }
  }
}
