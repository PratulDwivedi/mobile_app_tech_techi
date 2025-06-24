import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/widgets/section_widget.dart';

class FormDataCollector extends StatefulWidget {
  final PageSchema pageSchema;
  final GlobalKey<FormState> formKey;
  final Widget child;

  const FormDataCollector({
    super.key,
    required this.pageSchema,
    required this.formKey,
    required this.child,
  });

  @override
  State<FormDataCollector> createState() => FormDataCollectorState();
}

class FormDataCollectorState extends State<FormDataCollector> {
  final Map<String, dynamic> _formData = {};

  void _onValueChanged(String bindingName, dynamic value) {
    setState(() {
      _formData[bindingName] = value;
    });
  }

  Map<String, dynamic> getFormData() {
    return Map.from(_formData);
  }

  void setFormData(Map<String, dynamic> data) {
    setState(() {
      _formData.clear();
      _formData.addAll(data);
    });
  }

  void clearFormData() {
    setState(() {
      _formData.clear();
    });
  }

  // Validate all controls in the form
  bool validateForm() {
    bool isValid = true;
    
    // Validate text form fields using the form key
    if (widget.formKey.currentState != null) {
      isValid = widget.formKey.currentState!.validate();
    }
    
    // Additional validation for dropdown controls can be added here
    // by accessing the control keys and calling their validate methods
    
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.pageSchema.sections
          .map((section) => SectionWidget(
                section: section,
                formKey: widget.formKey,
                onValueChanged: _onValueChanged,
              ))
          .toList(),
    );
  }
} 