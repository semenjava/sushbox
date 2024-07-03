import 'dart:convert';
import 'dart:developer' as developer;

void dd(dynamic data) {
  String formattedData;

  try {
    formattedData = jsonEncode(data);
  } catch (e) {
    formattedData = 'Error formatting data: $e';
  }

  developer.log(formattedData, name: 'DD_LOG');

  throw Exception('Execution stopped by dd.');
}
