import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../providers/riverpod/theme_provider.dart';
import 'data_picker_dialog.dart';

class ControlWidget extends ConsumerStatefulWidget {
  final Control control;
  final GlobalKey<FormState> formKey;

  const ControlWidget({
    super.key,
    required this.control,
    required this.formKey,
  });

  @override
  ConsumerState<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends ConsumerState<ControlWidget> {
  dynamic _selectedValue; // The full item (id, name, ...)

  // Expose selected id and name for saving
  dynamic get selectedId => _selectedValue?['id'];
  String? get selectedName => _selectedValue?['name'];

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);

    switch (widget.control.controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.dropdownMultiselect:
      case ControlTypes.treeViewSingle:
      case ControlTypes.treeViewMulti:
        return _buildPopupSelector(
            context, ref, widget.control, isDarkMode, primaryColor);
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
                labelText: widget.control.name,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                prefixIcon: Icon(
                  _getIconForControlType(widget.control.controlTypeId),
                  color: primaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              keyboardType: _getKeyboardType(widget.control.controlTypeId),
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
                labelText: widget.control.name,
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
                labelText: widget.control.name,
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
                  widget.control.name,
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
                  widget.control.name,
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
                if (widget.formKey.currentState!.validate()) {
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
                widget.control.name,
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
            label: Text(widget.control.name),
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
            label: Text(widget.control.name),
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
                widget.control.name,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unsupported control type: ${widget.control.controlTypeId}',
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

  Widget _buildPopupSelector(BuildContext context, WidgetRef ref, Control control,
      bool isDarkMode, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => DataPickerDialog(control: control, selectedValue: _selectedValue),
          );
          if (result != null) {
            setState(() {
              _selectedValue = result;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                _getIconForControlType(control.controlTypeId),
                color: primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedValue != null
                      ? _selectedValue['name']
                      : control.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForControlType(int controlTypeId) {
    switch (controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.dropdownMultiselect:
        return Icons.arrow_drop_down_circle_outlined;
      case ControlTypes.treeViewSingle:
      case ControlTypes.treeViewMulti:
        return Icons.account_tree_outlined;
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
        return Icons.text_fields;
      case ControlTypes.email:
        return Icons.email;
      case ControlTypes.url:
        return Icons.link;
      case ControlTypes.phoneNumber:
        return Icons.phone;
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        return Icons.numbers;
      default:
        return Icons.input;
    }
  }

  TextInputType _getKeyboardType(int controlTypeId) {
    switch (controlTypeId) {
      case ControlTypes.email:
        return TextInputType.emailAddress;
      case ControlTypes.url:
        return TextInputType.url;
      case ControlTypes.phoneNumber:
        return TextInputType.phone;
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
} 