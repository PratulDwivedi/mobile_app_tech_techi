import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'control_widget.dart';

class MultiEntryFormSection extends StatefulWidget {
  final Section section;
  final GlobalKey<FormState> formKey;
  final Function(String bindingName, dynamic value)? onValueChanged;

  const MultiEntryFormSection({
    super.key,
    required this.section,
    required this.formKey,
    this.onValueChanged,
  });

  @override
  State<MultiEntryFormSection> createState() => _MultiEntryFormSectionState();
}

class _MultiEntryFormSectionState extends State<MultiEntryFormSection> {
  final List<Map<String, dynamic>> _entries = [];
  final Map<String, dynamic> _currentEntry = {};

  void _onControlChanged(String bindingName, dynamic value) {
    setState(() {
      _currentEntry[bindingName] = value;
    });
    widget.onValueChanged?.call(bindingName, value);
  }

  void _addEntry() {
    if (widget.formKey.currentState?.validate() ?? false) {
      setState(() {
        _entries.add(Map<String, dynamic>.from(_currentEntry));
        _currentEntry.clear();
      });
      widget.formKey.currentState?.reset();
    }
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._entries.asMap().entries.map((entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(entry.value.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeEntry(entry.key),
                ),
              ),
            )),
        ...widget.section.controls.map((control) => ControlWidget(
              control: control,
              formKey: widget.formKey,
              onValueChanged: _onControlChanged,
            )),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add'),
            onPressed: _addEntry,
          ),
        ),
      ],
    );
  }
} 