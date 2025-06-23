import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import '../providers/riverpod/data_providers.dart';
import '../providers/riverpod/theme_provider.dart';
import 'data_picker_dialog.dart';
import 'package:fl_chart/fl_chart.dart';

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
  dynamic _selectedValue; // The full item (id, name, ...) or list of such maps for multi

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
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (widget.control.displayModeId == ControlDisplayModes.require)
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
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
                ),
              ),
            ],
          ),
        );
      case ControlTypes.password:
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
                ),
              ),
            ],
          ),
        );
      case ControlTypes.textArea:
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
              if (data == null || data.isEmpty) {
                return const Text('No chart data');
              }
              Widget chart;
              if (widget.control.controlTypeId == ControlTypes.barChart) {
                chart = _buildBarChart(data, widget.control.name);
              } else if (widget.control.controlTypeId == ControlTypes.lineChart) {
                chart = _buildLineChart(data, widget.control.name);
              } else if (widget.control.controlTypeId == ControlTypes.pieChart) {
                chart = _buildPieChart(data, widget.control.name);
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
    // Implement validation logic based on the control type
    return null; // Placeholder return, actual implementation needed
  }

  Widget _buildBarChart(List<dynamic> data, String title) {
    final barColors = [Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.red, Colors.teal, Colors.amber];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: [
                for (int i = 0; i < data.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (data[i]['value'] as num).toDouble(),
                        color: barColors[i % barColors.length],
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (value == 0) text = '0';
                      else if (value >= 1000) text = '${(value ~/ 1000)}K';
                      else text = value.toInt().toString();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(text, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            for (int i = 0; i < data.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 12, height: 12, color: barColors[i % barColors.length]),
                  const SizedBox(width: 4),
                  Text(data[i]['name'].toString(), style: const TextStyle(fontSize: 12)),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineChart(List<dynamic> data, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (int i = 0; i < data.length; i++)
                      FlSpot(i.toDouble(), (data[i]['value'] as num).toDouble()),
                  ],
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (value == 0) text = '0';
                      else if (value >= 1000) text = '${(value ~/ 1000)}K';
                      else text = value.toInt().toString();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(text, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      String text = (idx >= 0 && idx < data.length) ? data[idx]['name'].toString() : '';
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(text, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(List<dynamic> data, String title) {
    final pieColors = [Colors.pink, Colors.red, Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.teal, Colors.amber];
    final total = data.fold<num>(0, (sum, item) => sum + (item['value'] as num));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: [
                for (int i = 0; i < data.length; i++)
                  PieChartSectionData(
                    value: (data[i]['value'] as num).toDouble(),
                    color: pieColors[i % pieColors.length],
                    title: '',
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            for (int i = 0; i < data.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 12, height: 12, color: pieColors[i % pieColors.length]),
                  const SizedBox(width: 4),
                  Text(
                    '${data[i]['name']} (${((data[i]['value'] as num) / total * 100).toStringAsFixed(1)}%)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
} 