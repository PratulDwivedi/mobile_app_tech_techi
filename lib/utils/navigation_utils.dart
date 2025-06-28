import 'package:flutter/foundation.dart';

Map<String, dynamic> parseRouteAndArgs(
    String defaultValue, Map<String, dynamic> record) {
  final uri =
      Uri.parse(defaultValue.startsWith('/') ? defaultValue : '/$defaultValue');
  final route = uri.path.replaceAll('/', '');
  final args = <String, dynamic>{};
  uri.queryParameters.forEach((key, value) {
    final reg = RegExp(r'\{(.+?)\}');
    final match = reg.firstMatch(value);
    if (match != null) {
      final field = match.group(1)!;
      args[key] = record[field]?.toString() ?? '';
    } else {
      args[key] = value;
    }
  });
  return {'route': route, 'args': args};
}
