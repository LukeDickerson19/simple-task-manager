import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  static Future<void> saveFile(String filePath, String value) async {
    String fullFilePath = await StorageManager.getFullPath(filePath);
    File file = File(fullFilePath);
    await createDirectory(file.parent.path);
    await file.writeAsBytes(utf8.encode(value));
  }

  static Future<void> createFile(String filePath) async {
    String fullDirectoryPath = await StorageManager.getFullPath(filePath);
    await File(fullDirectoryPath).create(recursive: true);
  }

  static Future<String?> readFile(String filePath) async {
    String fullFilePath = await StorageManager.getFullPath(filePath);
    if (!(await StorageManager.fileExists(fullFilePath))) {
      return null;
    }
    Uint8List bytes = await File(fullFilePath).readAsBytes();
    return utf8.decode(bytes);
  }

  static Future<bool> deleteFile(String filePath) async {
    String fullFilePath = await StorageManager.getFullPath(filePath);
    try {
      File(fullFilePath).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> fileExists(String filePath) async {
    String fullFilePath = await StorageManager.getFullPath(filePath);
    return await File(fullFilePath).exists();
  }

  static Future<bool> directoryExists(String directoryPath) async {
    String fullDirectoryPath = await StorageManager.getFullPath(directoryPath);
    return await Directory(fullDirectoryPath).exists();
  }

  static Future<void> createDirectory(String directoryPath) async {
    String fullDirectoryPath = await StorageManager.getFullPath(directoryPath);
    await Directory(fullDirectoryPath).create(recursive: true);
  }

  static Future<bool> deleteDirectory(String directoryPath) async {
    String directoryFullPath = await StorageManager.getFullPath(directoryPath);
    try {
      Directory(directoryFullPath).delete(recursive: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getFullPath(String path) async {
    final Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    return path.startsWith(applicationDirectory.path)
        ? path
        : "${applicationDirectory.path}/$path";
  }
}
