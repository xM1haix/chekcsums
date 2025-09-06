import "dart:io";

import "package:flutter/material.dart";

Future<List<FileData>> getFolderStructure(String path) async {
  final files = <FileData>[];
  try {
    final entities =
        await Directory(
          path,
        ).list(recursive: true, followLinks: false).toList();
    for (final entity in entities) {
      if (entity is File) {
        final fileStat = entity.statSync();
        files.add(FileData(path: entity.path, size: fileStat.size));
      }
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return files;
}

class FileData {
  const FileData({required this.size, required this.path, this.header = false});

  factory FileData.header() =>
      const FileData(size: 0, path: "PATH", header: true);
  final int size;
  final String path;
  final bool header;
  String formatFileSize() {
    if (header) {
      return "SIZE";
    }
    const units = <String>["B", "KB", "MB", "GB", "TB"];
    var newSize = size.toDouble();
    var unitIndex = 0;
    while (newSize >= 1024 && unitIndex < units.length - 1) {
      newSize /= 1024;
      unitIndex++;
    }

    return "${newSize.toStringAsFixed(2)} ${units[unitIndex]}";
  }
}
