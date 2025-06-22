import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/config/app_constants.dart';
import 'package:mobile_app_tech_techi/models/page_item.dart';
import 'package:mobile_app_tech_techi/models/page_schema.dart';
import 'package:mobile_app_tech_techi/providers/theme_provider.dart';
import 'package:mobile_app_tech_techi/services/auth_service.dart';
import 'package:mobile_app_tech_techi/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class DynamicScreen extends StatefulWidget {
  final String routeName;
  const DynamicScreen({super.key, required this.routeName});

  @override
  State<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends State<DynamicScreen> {
  final AuthService _authService = AuthService();
  late Future<PageSchema> _pageSchemaFuture;
  late Future<List<PageItem>> _userPagesFuture;
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1; // Start at 1 since 0 is home

  @override
  void initState() {
    super.initState();
    _pageSchemaFuture = _authService.getPageSchema(widget.routeName);
    _userPagesFuture = _authService.getUserPages();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.routeName.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
          ),
        ),
        child: FutureBuilder<PageSchema>(
          future: _pageSchemaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No page schema found.',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final pageSchema = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: pageSchema.sections
                      .map((section) => _buildSection(context, section))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<List<PageItem>>(
        future: _userPagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }
          return CustomBottomNavigationBar(
            pages: snapshot.data!,
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, Section section) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.primaryColor;

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
          // Section Header
          Container(
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
          ),
          const SizedBox(height: 24),
          ...section.controls
              .map((control) => _buildControlWidget(context, control))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildControlWidget(BuildContext context, Control control) {
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
                if (_formKey.currentState!.validate()) {
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