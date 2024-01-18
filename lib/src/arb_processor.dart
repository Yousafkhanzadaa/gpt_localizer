// lib/src/arb_processor.dart

import 'dart:convert';
import 'dart:io';

class ArbProcessor {
  Future<Map<String, dynamic>> readArbFile(String filePath) async {
    var fileString = await File(filePath).readAsString();
    return json.decode(fileString);
  }

  Future<void> writeArbFile(
      String filePath, Map<String, dynamic> content) async {
    var fileString = json.encode(content);
    await File(filePath).writeAsString(fileString);
  }
}
