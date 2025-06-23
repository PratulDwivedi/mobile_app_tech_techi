import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/providers/riverpod/data_providers.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';

class DataPickerDialog extends ConsumerStatefulWidget {
  final Control control;
  final dynamic selectedValue; // id, item, or list of ids/items for multi

  const DataPickerDialog({super.key, required this.control, this.selectedValue});

  @override
  ConsumerState<DataPickerDialog> createState() => _DataPickerDialogState();
}

class _DataPickerDialogState extends ConsumerState<DataPickerDialog> {
  String _search = '';
  Set<dynamic> _multiSelectedIds = {};
  Set<Map<String, dynamic>> _multiSelectedItems = {};

  @override
  void initState() {
    super.initState();
    // For multi-select, initialize selected ids and items
    if (_isMultiSelect) {
      if (widget.selectedValue is List) {
        _multiSelectedItems = Set.from((widget.selectedValue as List).map((e) => e is Map ? e : {'id': e, 'name': ''}));
        _multiSelectedIds = Set.from(_multiSelectedItems.map((e) => e['id']));
      } else if (widget.selectedValue != null) {
        final item = widget.selectedValue is Map ? widget.selectedValue : {'id': widget.selectedValue, 'name': ''};
        _multiSelectedItems = {item};
        _multiSelectedIds = {item['id']};
      }
    }
  }

  bool get _isMultiSelect =>
      widget.control.controlTypeId == ControlTypes.dropdownMultiselect ||
      widget.control.controlTypeId == ControlTypes.treeViewMulti;

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
                  if (widget.control.controlTypeId == ControlTypes.dropdown) {
                    return _buildDropdownList(context, data);
                  } else if (widget.control.controlTypeId == ControlTypes.dropdownMultiselect) {
                    return _buildDropdownMultiList(context, data);
                  } else if (widget.control.controlTypeId == ControlTypes.treeViewSingle) {
                    return _buildTreeView(context, data, false);
                  } else if (widget.control.controlTypeId == ControlTypes.treeViewMulti) {
                    return _buildTreeView(context, data, true);
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
        if (_isMultiSelect)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_multiSelectedItems.toList());
            },
            child: const Text('Done'),
          ),
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

  Widget _buildDropdownMultiList(BuildContext context, List<dynamic> data) {
    final filtered = data.where((item) =>
      item['name'].toString().toLowerCase().contains(_search)).toList();
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isChecked = _multiSelectedIds.contains(item['id']);
        return ListTile(
          leading: Checkbox(
            value: isChecked,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _multiSelectedIds.add(item['id']);
                  _multiSelectedItems.add({'id': item['id'], 'name': item['name']});
                } else {
                  _multiSelectedIds.remove(item['id']);
                  _multiSelectedItems.removeWhere((e) => e['id'] == item['id']);
                }
              });
            },
          ),
          title: Text(item['name']),
          onTap: () {
            setState(() {
              final checked = !_multiSelectedIds.contains(item['id']);
              if (checked) {
                _multiSelectedIds.add(item['id']);
                _multiSelectedItems.add({'id': item['id'], 'name': item['name']});
              } else {
                _multiSelectedIds.remove(item['id']);
                _multiSelectedItems.removeWhere((e) => e['id'] == item['id']);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildTreeView(BuildContext context, List<dynamic> data, bool multi) {
    final filtered = _search.isEmpty
        ? data
        : data.where((item) =>
            item['name'].toString().toLowerCase().contains(_search) ||
            (item['children'] as List?)?.any((child) => child['name'].toString().toLowerCase().contains(_search)) == true
          ).toList();
    final selectedId = widget.selectedValue is Map ? widget.selectedValue['id'] : widget.selectedValue;
    return ListView(
      children: filtered.map((item) => _buildTreeNode(context, item, multi, selectedId)).toList(),
    );
  }

  Widget _buildTreeNode(BuildContext context, dynamic item, bool multi, dynamic selectedId, {int depth = 0}) {
    final children = item['children'] as List<dynamic>? ?? [];
    final isLeaf = children.isEmpty;
    final isChecked = _multiSelectedIds.contains(item['id']);
    final isSelected = item['id'] == selectedId;
    final padding = EdgeInsets.only(left: 16.0 * depth);

    if (multi) {
      if (isLeaf) {
        return ListTile(
          leading: Checkbox(
            value: isChecked,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _multiSelectedIds.add(item['id']);
                  _multiSelectedItems.add({'id': item['id'], 'name': item['name']});
                } else {
                  _multiSelectedIds.remove(item['id']);
                  _multiSelectedItems.removeWhere((e) => e['id'] == item['id']);
                }
              });
            },
          ),
          title: Padding(
            padding: padding,
            child: Text(item['name']),
          ),
          onTap: () {
            setState(() {
              final checked = !_multiSelectedIds.contains(item['id']);
              if (checked) {
                _multiSelectedIds.add(item['id']);
                _multiSelectedItems.add({'id': item['id'], 'name': item['name']});
              } else {
                _multiSelectedIds.remove(item['id']);
                _multiSelectedItems.removeWhere((e) => e['id'] == item['id']);
              }
            });
          },
        );
      } else {
        return ExpansionTile(
          title: Padding(
            padding: padding,
            child: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          children: children.map((child) => _buildTreeNode(context, child, multi, selectedId, depth: depth + 1)).toList(),
        );
      }
    } else {
      if (isLeaf) {
        return ListTile(
          title: Padding(
            padding: padding,
            child: Text(item['name']),
          ),
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
          onTap: () {
            Navigator.of(context).pop(item);
          },
        );
      } else {
        return ExpansionTile(
          title: Padding(
            padding: padding,
            child: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          children: children.map((child) => _buildTreeNode(context, child, multi, selectedId, depth: depth + 1)).toList(),
        );
      }
    }
  }
} 