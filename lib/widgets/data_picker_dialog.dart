import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/providers/riverpod/data_providers.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';

class DataPickerDialog extends ConsumerStatefulWidget {
  final Control control;
  final dynamic selectedValue; // Should be id or item map

  const DataPickerDialog({super.key, required this.control, this.selectedValue});

  @override
  ConsumerState<DataPickerDialog> createState() => _DataPickerDialogState();
}

class _DataPickerDialogState extends ConsumerState<DataPickerDialog> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    if (widget.control.bindingListRouteName == null) {
      return const AlertDialog(
        title: Text('Error'),
        content: Text('Binding list route name is not defined.'),
      );
    }
    final listData = ref.watch(bindingListProvider(widget.control.bindingListRouteName!));

    return AlertDialog(
      title: Text('Select ${widget.control.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _search = val.trim().toLowerCase()),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: listData.when(
                data: (data) {
                  if (widget.control.controlTypeId == ControlTypes.dropdown ||
                      widget.control.controlTypeId == ControlTypes.dropdownMultiselect) {
                    return _buildDropdownList(context, data);
                  } else if (widget.control.controlTypeId == ControlTypes.treeViewSingle ||
                      widget.control.controlTypeId == ControlTypes.treeViewMulti) {
                    return _buildTreeView(context, data);
                  }
                  return const Text('Unsupported control type for dialog.');
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildDropdownList(BuildContext context, List<dynamic> data) {
    final filtered = data.where((item) =>
      item['name'].toString().toLowerCase().contains(_search)).toList();
    final selectedId = widget.selectedValue is Map ? widget.selectedValue['id'] : widget.selectedValue;
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isSelected = item['id'] == selectedId;
        return ListTile(
          title: Text(item['name']),
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
          onTap: () {
            Navigator.of(context).pop(item);
          },
        );
      },
    );
  }

  Widget _buildTreeView(BuildContext context, List<dynamic> data) {
    final filtered = _search.isEmpty
        ? data
        : data.where((item) =>
            item['name'].toString().toLowerCase().contains(_search) ||
            (item['children'] as List?)?.any((child) => child['name'].toString().toLowerCase().contains(_search)) == true
          ).toList();
    final selectedId = widget.selectedValue is Map ? widget.selectedValue['id'] : widget.selectedValue;
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final children = item['children'] as List<dynamic>? ?? [];
        if (children.isEmpty) {
          final isSelected = item['id'] == selectedId;
          return ListTile(
            title: Text(item['name']),
            selected: isSelected,
            selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              Navigator.of(context).pop(item);
            },
          );
        }
        return ExpansionTile(
          title: Text(item['name']),
          children: children.map((child) {
            final isSelected = child['id'] == selectedId;
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(child['name']),
              ),
              selected: isSelected,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                Navigator.of(context).pop(child);
              },
            );
          }).toList(),
        );
      },
    );
  }
} 