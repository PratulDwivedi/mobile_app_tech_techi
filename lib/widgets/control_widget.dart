import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ControlWidget extends StatelessWidget {
  final Control control;
  final GlobalKey<FormState> formKey;

  const ControlWidget({
    super.key,
    required this.control,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    switch (control.controlTypeId) {
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
      case ControlTypes.email:
      case ControlTypes.url:
      case ControlTypes.phoneNumber:
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: control.name,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                prefixIcon: Icon(
                  _getIconForControlType(control.controlTypeId),
                  color: primaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              keyboardType: _getKeyboardType(control.controlTypeId),
            ),
          ),
        );
      case ControlTypes.password:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              obscureText: true,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: control.name,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        );
      case ControlTypes.textArea:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              maxLines: 4,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: control.name,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: primaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        );
      case ControlTypes.toggleSwitch:
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.toggle_on,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  control.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: false, // Need to manage state
                onChanged: (bool value) {
                  // Need to manage state
                },
                activeColor: primaryColor,
              ),
            ],
          ),
        );
      case ControlTypes.checkbox:
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_box_outline_blank,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  control.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Checkbox(
                value: false, // Need to manage state
                onChanged: (bool? value) {
                  // Need to manage state
                },
                activeColor: primaryColor,
              ),
            ],
          ),
        );
      case ControlTypes.submit:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Submit form
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                control.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      case ControlTypes.addTableRow:
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: Text(control.name),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
      case ControlTypes.deleteTableRow:
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.remove_circle_outline),
            label: Text(control.name),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
      default:
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                control.name,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unsupported control type: ${control.controlTypeId}',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
    }
  }

  IconData _getIconForControlType(int controlTypeId) {
    switch (controlTypeId) {
      case ControlTypes.email:
        return Icons.email_outlined;
      case ControlTypes.url:
        return Icons.link;
      case ControlTypes.phoneNumber:
        return Icons.phone;
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        return Icons.numbers;
      case ControlTypes.alphaOnly:
        return Icons.text_fields;
      case ControlTypes.alphaNumeric:
        return Icons.text_format;
      default:
        return Icons.edit;
    }
  }

  TextInputType _getKeyboardType(int controlTypeId) {
    if (controlTypeId == ControlTypes.email) {
      return TextInputType.emailAddress;
    }
    if (controlTypeId == ControlTypes.url) {
      return TextInputType.url;
    }
    if (controlTypeId == ControlTypes.phoneNumber) {
      return TextInputType.phone;
    }
    if (controlTypeId == ControlTypes.integer ||
        controlTypeId == ControlTypes.decimal ||
        controlTypeId == ControlTypes.currency) {
      return const TextInputType.numberWithOptions(decimal: true);
    }
    return TextInputType.text;
  }
} 