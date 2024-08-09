import 'dart:io';

Future<List<FileData>> getFolderStructure(String path) async {
  List<FileData> files = [];
  try {
    var entities = await Directory(path)
        .list(recursive: true, followLinks: false)
        .toList();
    for (var entity in entities) {
      if (entity is File) {
        var fileStat = await entity.stat();
        files.add(FileData(
          path: entity.path,
          size: fileStat.size,
        ));
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  return files;
}

class FileData {
  String formatFileSize() {
    if (header) return 'SIZE';
    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double newSize = size.toDouble();
    int unitIndex = 0;
    while (newSize >= 1024 && unitIndex < units.length - 1) {
      newSize /= 1024;
      unitIndex++;
    }

    return '${newSize.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  final int size;
  final String path;
  final bool header;
  const FileData({
    required this.size,
    required this.path,
    this.header = false,
  });
  factory FileData.header() => const FileData(
        size: 0,
        path: 'PATH',
        header: true,
      );
}
