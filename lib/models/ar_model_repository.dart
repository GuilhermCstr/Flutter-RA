import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ARModelRepository {
  Future<String> copyAssetToDocuments(String fileName) async {
    final docDir = await getApplicationDocumentsDirectory();
    final filePath = '${docDir.path}/$fileName';
    final file = File(filePath);

    if (!await file.exists()) {
      final assetBytes = await rootBundle.load('assets/$fileName');
      final buffer = assetBytes.buffer;
      await file.writeAsBytes(
        buffer.asUint8List(assetBytes.offsetInBytes, assetBytes.lengthInBytes),
      );
    }

    return filePath;
  }
}