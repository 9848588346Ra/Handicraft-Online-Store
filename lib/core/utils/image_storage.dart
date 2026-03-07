import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies a picked image to app's permanent storage so it persists across
/// app restarts and is available to all users (not tied to admin session).
/// Returns the new persistent file path, or null on failure.
Future<String?> copyToPersistentStorage(String sourcePath) async {
  try {
    final sourceFile = File(sourcePath);
    if (!sourceFile.existsSync()) return null;

    final dir = await getApplicationDocumentsDirectory();
    final productImagesDir = Directory(p.join(dir.path, 'product_images'));
    if (!await productImagesDir.exists()) {
      await productImagesDir.create(recursive: true);
    }

    final ext = p.extension(sourcePath).isEmpty ? '.jpg' : p.extension(sourcePath);
    final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}$ext';
    final destPath = p.join(productImagesDir.path, fileName);
    final destFile = await sourceFile.copy(destPath);
    return destFile.path;
  } catch (_) {
    return null;
  }
}
