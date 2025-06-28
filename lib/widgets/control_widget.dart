import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../providers/riverpod/data_providers.dart';
import '../providers/riverpod/theme_provider.dart';
import 'data_picker_dialog.dart';
import 'bar_chart_widget.dart';
import 'pie_chart_widget.dart';
import 'line_chart_widget.dart';

class ControlWidget extends ConsumerStatefulWidget {
  final Control control;
  final GlobalKey<FormState> formKey;
  final Function(String bindingName, dynamic value)? onValueChanged;
  final Map<String, dynamic> formData;

  const ControlWidget({
    super.key,
    required this.control,
    required this.formKey,
    this.onValueChanged,
    required this.formData,
  });

  @override
  ConsumerState<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends ConsumerState<ControlWidget> {
  dynamic _selectedValue; // The full item (id, name, ...) or list of such maps for multi
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  @override
  void didUpdateWidget(covariant ControlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.formData != oldWidget.formData) {
      _initializeValue();
    }
  }

  void _initializeValue() {
    switch (widget.control.controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.treeViewSingle:
        // Use id and _name from formData
        final bindingName = widget.control.bindingName;
        final id = widget.formData[bindingName];
        final name = widget.formData['${bindingName}_name'];
        if (id != null) {
          _selectedValue = {'id': id, 'name': name ?? id.toString()};
        } else {
          _selectedValue = null;
        }
        break;
      case ControlTypes.dropdownMultiselect:
      case ControlTypes.treeViewMulti:
        // Use list of ids and names from formData
        final bindingName = widget.control.bindingName;
        final ids = widget.formData[bindingName];
        final names = widget.formData['${bindingName}_name'];
        List<Map<String, dynamic>> result = [];
        if (ids is List) {
          for (var i = 0; i < ids.length; i++) {
            final id = ids[i];
            final name = (names is List && names.length > i) ? names[i] : id.toString();
            result.add({'id': id, 'name': name});
          }
        } else if (ids != null) {
          result.add({'id': ids, 'name': (names is List && names.isNotEmpty) ? names[0] : ids.toString()});
        }
        _selectedValue = result;
        break;
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
      case ControlTypes.email:
      case ControlTypes.url:
      case ControlTypes.phoneNumber:
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
      case ControlTypes.password:
      case ControlTypes.textArea:
        if (!_textControllers.containsKey(widget.control.bindingName)) {
          _textControllers[widget.control.bindingName] = TextEditingController();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _textControllers[widget.control.bindingName]?.text = widget.formData[widget.control.bindingName]?.toString() ?? '';
        });
        break;
      case ControlTypes.toggleSwitch:
      case ControlTypes.checkbox:
        _selectedValue = widget.formData[widget.control.bindingName] ?? false;
        break;
      default:
        break;
    }
  }

  // Expose selected id(s) and name(s) for saving
  dynamic get selectedId {
    if (_selectedValue is List) {
      return (_selectedValue as List).map((e) => e['id']).toList();
    }
    return _selectedValue?['id'];
  }
  String? get selectedName {
    if (_selectedValue is List) {
      return (_selectedValue as List).map((e) => e['name']).join(', ');
    }
    return _selectedValue?['name'];
  }

  // Get the current form value for this control
  dynamic getFormValue() {
    switch (widget.control.controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.dropdownMultiselect:
      case ControlTypes.treeViewSingle:
      case ControlTypes.treeViewMulti:
        return selectedId;
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
      case ControlTypes.email:
      case ControlTypes.url:
      case ControlTypes.phoneNumber:
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        final controller = _textControllers[widget.control.bindingName];
        return controller?.text;
      case ControlTypes.password:
        return _textControllers[widget.control.bindingName]?.text;
      case ControlTypes.textArea:
        return _textControllers[widget.control.bindingName]?.text;
      case ControlTypes.toggleSwitch:
        return _selectedValue ?? false;
      case ControlTypes.checkbox:
        return _selectedValue ?? false;
      case ControlTypes.submit:
        return null; // Submit form
      case ControlTypes.addTableRow:
        return null; // Add table row
      case ControlTypes.deleteTableRow:
        return null; // Delete table row
      case ControlTypes.barChart:
      case ControlTypes.lineChart:
      case ControlTypes.pieChart:
        if (widget.control.bindingListRouteName == null) {
          return null; // No data
        }
        final listData = ref.watch(bindingListProvider(widget.control.bindingListRouteName!));
        return listData.when(
          data: (data) => data.isEmpty ? null : data,
          loading: () => null,
          error: (error, stack) => null,
        );
      default:
        return null; // Unsupported control type
    }
  }

  // Validate the control value
  String? validateControl() {
    switch (widget.control.controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.dropdownMultiselect:
      case ControlTypes.treeViewSingle:
      case ControlTypes.treeViewMulti:
        if (widget.control.displayModeId == ControlDisplayModes.require) {
          if (_selectedValue == null || 
              (widget.control.controlTypeId == ControlTypes.dropdownMultiselect || 
               widget.control.controlTypeId == ControlTypes.treeViewMulti)) {
            if (_selectedValue is List && (_selectedValue as List).isEmpty) {
              return '${widget.control.name} is required';
            }
          }
        }
        break;
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
      case ControlTypes.email:
      case ControlTypes.url:
      case ControlTypes.phoneNumber:
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
      case ControlTypes.password:
      case ControlTypes.textArea:
        final controller = _textControllers[widget.control.bindingName];
        return _validate(widget.control, controller?.text);
    }
    return null;
  }

  // Notify parent of value change
  void _notifyValueChange(dynamic value) {
    // For dropdown/tree controls, set both id and name
    if (widget.control.controlTypeId == ControlTypes.dropdown ||
        widget.control.controlTypeId == ControlTypes.treeViewSingle ||
        widget.control.controlTypeId == ControlTypes.dropdownMultiselect ||
        widget.control.controlTypeId == ControlTypes.treeViewMulti) {
      if (value == null) {
        widget.onValueChanged?.call(widget.control.bindingName, null);
        widget.onValueChanged?.call('${widget.control.bindingName}_name', null);
      } else if (value is List) {
        // Multi-select: list of maps
        final ids = value.map((e) => e['id']).toList();
        final names = value.map((e) => e['name']).toList();
        widget.onValueChanged?.call(widget.control.bindingName, ids);
        widget.onValueChanged?.call('${widget.control.bindingName}_name', names);
      } else if (value is Map) {
        widget.onValueChanged?.call(widget.control.bindingName, value['id']);
        widget.onValueChanged?.call('${widget.control.bindingName}_name', value['name']);
      }
    } else {
      widget.onValueChanged?.call(widget.control.bindingName, value);
    }
  }

  @override
  void dispose() {
    _textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);

    Widget buildLabel() {
      return Row(
        children: [
          Text(
            widget.control.name,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 14
            ),
          ),
          if (widget.control.displayModeId == ControlDisplayModes.require)
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 14)),
        ],
      );
    }

    switch (widget.control.controlTypeId) {
      case ControlTypes.dropdown:
      case ControlTypes.dropdownMultiselect:
      case ControlTypes.treeViewSingle:
      case ControlTypes.treeViewMulti:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel(),
              const SizedBox(height: 4),
              _buildPopupSelector(
                context, ref, widget.control, isDarkMode, primaryColor),
            ],
          ),
        );
      case ControlTypes.alphaNumeric:
      case ControlTypes.alphaOnly:
      case ControlTypes.email:
      case ControlTypes.url:
      case ControlTypes.phoneNumber:
      case ControlTypes.integer:
      case ControlTypes.decimal:
      case ControlTypes.currency:
        // Initialize controller if not exists
        if (!_textControllers.containsKey(widget.control.bindingName)) {
          _textControllers[widget.control.bindingName] = TextEditingController();
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel(),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _textControllers[widget.control.bindingName],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
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
                  validator: (value) => _validate(widget.control, value),
                  onChanged: (value) => _notifyValueChange(value),
                ),
              ),
            ],
          ),
        );
      case ControlTypes.password:
        // Initialize controller if not exists
        if (!_textControllers.containsKey(widget.control.bindingName)) {
          _textControllers[widget.control.bindingName] = TextEditingController();
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel(),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _textControllers[widget.control.bindingName],
                  obscureText: true,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
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
                  validator: (value) => _validate(widget.control, value),
                  onChanged: (value) => _notifyValueChange(value),
                ),
              ),
            ],
          ),
        );
      case ControlTypes.textArea:
        // Initialize controller if not exists
        if (!_textControllers.containsKey(widget.control.bindingName)) {
          _textControllers[widget.control.bindingName] = TextEditingController();
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabel(),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _textControllers[widget.control.bindingName],
                  maxLines: 4,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
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
                  validator: (value) => _validate(widget.control, value),
                  onChanged: (value) => _notifyValueChange(value),
                ),
              ),
            ],
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
                value: _selectedValue ?? false,
                onChanged: (bool value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  _notifyValueChange(value);
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
      case ControlTypes.barChart:
      case ControlTypes.lineChart:
      case ControlTypes.pieChart:
        if (widget.control.bindingListRouteName == null) {
          return const Text('No data');
        }
        final listData = ref.watch(bindingListProvider(widget.control.bindingListRouteName!));
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: listData.when(
            data: (data) {
              if (data.isEmpty) {
                return const Text('No chart data');
              }
              Widget chart;
              if (widget.control.controlTypeId == ControlTypes.barChart) {
                chart = BarChartWidget(data: data, title: widget.control.name);
              } else if (widget.control.controlTypeId == ControlTypes.lineChart) {
                chart = LineChartWidget(data: data, title: widget.control.name);
              } else if (widget.control.controlTypeId == ControlTypes.pieChart) {
                chart = PieChartWidget(data: data, title: widget.control.name);
              } else {
                chart = const Text('Unsupported chart type');
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: chart,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
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
    return InkWell(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => DataPickerDialog(control: control, selectedValue: _selectedValue),
        );
        if (result != null) {
          setState(() {
            _selectedValue = result;
          });
          _notifyValueChange(_selectedValue); // Pass the full map or list of maps
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
                    ? (_selectedValue is List
                        ? (_selectedValue as List).map((e) => e['name']).join(', ')
                        : _selectedValue['name'])
                    : "",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
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

  String? _validate(Control control, String? value) {
    // Check if field is required
    if (control.displayModeId == ControlDisplayModes.require) {
      if (value == null || value.trim().isEmpty) {
        return '${control.name} is required';
      }
    }

    // If value is empty and not required, it's valid
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    // Type-specific validation
    switch (control.controlTypeId) {
      case ControlTypes.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case ControlTypes.url:
        final urlRegex = RegExp(r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');
        if (!urlRegex.hasMatch(value)) {
          return 'Please enter a valid URL';
        }
        break;
      case ControlTypes.phoneNumber:
        final phoneRegex = RegExp(r'^[\+]?[1-9][\d]{0,15}$');
        if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
          return 'Please enter a valid phone number';
        }
        break;
      case ControlTypes.integer:
        if (int.tryParse(value) == null) {
          return 'Please enter a valid integer';
        }
        break;
      case ControlTypes.decimal:
      case ControlTypes.currency:
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
      case ControlTypes.alphaOnly:
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return 'Please enter only letters';
        }
        break;
    }

    return null;
  }
} 