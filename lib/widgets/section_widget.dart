import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../providers/riverpod/theme_provider.dart';
import 'control_widget.dart';
import 'multi_entry_form_section.dart';
import 'section_container.dart';

class SectionWidget extends ConsumerWidget {
  final Section section;
  final GlobalKey<FormState> formKey;
  final Function(String bindingName, dynamic value)? onValueChanged;
  final Map<String, dynamic> formData;

  const SectionWidget({
    super.key,
    required this.section,
    required this.formKey,
    this.onValueChanged,
    this.formData = const {},
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
    final primaryColor = ref.watch(primaryColorProvider);

    switch (section.childDisplayModeId) {
      case ChildDiaplayModes.dataTable:
        return MultiEntryFormSection(
          section: section,
          formKey: formKey,
          onValueChanged: onValueChanged,
          formData: formData,
        );
      case ChildDiaplayModes.dataTableReport:
      case ChildDiaplayModes.dataTableReportAdvance:
        // shows button instead of section in same screen
        return Container();
      case ChildDiaplayModes.googleMap:
        // Placeholder for Google Map rendering
        return SectionContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(primaryColor, section),
              const SizedBox(height: 24),
              // TODO: Replace with actual Google Map widget
              const Center(
                child: Text('Google Map rendering not implemented yet.'),
              ),
            ],
          ),
        );
      case ChildDiaplayModes.form:
      default:
        // Default: Render as form section
        return SectionContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SectionTitle(primaryColor, section),
              ...section.controls.map(
                (control) => Visibility(
                  visible:
                      control.displayModeId != ControlDisplayModes.noneHidden,
                  maintainState: true,
                  maintainAnimation: false,
                  maintainSize: false,
                  child: ControlWidget(
                    control: control,
                    formKey: formKey,
                    onValueChanged: onValueChanged,
                    formData: formData,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
