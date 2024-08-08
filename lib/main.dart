import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const FolderPickerExample(),
    );
  }
}

class FolderPickerExample extends StatefulWidget {
  const FolderPickerExample({super.key});

  @override
  State<FolderPickerExample> createState() => _FolderPickerExampleState();
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

class _FolderPickerExampleState extends State<FolderPickerExample> {
  String? selectedDirectory;
  Future<List<FileData>>? _future;
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

  Future<void> pickDirectory() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      setState(() {
        selectedDirectory = directoryPath;
        _future = getFolderStructure(directoryPath);
      });
    }
  }

  final double _ratio = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDirectory ?? 'No folder selected'),
        actions: [
          ElevatedButton(
            onPressed: pickDirectory,
            child: const Text('Pick Folder'),
          ),
        ],
      ),
      body: _future != null
          ? CustomFutureBuilder(
              future: _future!,
              success: (x) => Column(
                children: [
                  TableRow(
                    ratio: 2,
                    aspect: false,
                    fileData: FileData.header(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: x.length,
                      itemBuilder: (context, i) => TableRow(
                        ratio: 2,
                        fileData: x[i],
                        aspect: i.isEven,
                      ),
                    ),
                  )
                ],
              ),
            )
          : const Center(
              child: Text(
                'No folder selected',
              ),
            ),
    );
  }
}

class TableRow extends StatelessWidget {
  final FileData fileData;
  final bool aspect;
  final double ratio;
  final void Function()? sortName, sortSize;
  const TableRow({
    required this.aspect,
    required this.ratio,
    required this.fileData,
    this.sortName,
    this.sortSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fileData.header ? 100 : 50,
      color: aspect ? const Color(0xFF000000) : const Color(0xFF121212),
      child: Row(
        children: [
          Expanded(
            flex: ratio.toInt(),
            child: InkWell(
              onTap: sortName,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  fileData.path,
                  style: TextStyle(
                    fontSize: fileData.header ? 30 : null,
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: sortSize,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  fileData.formatFileSize(),
                  style: TextStyle(
                    fontSize: fileData.header ? 30 : null,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T x) success;
  const CustomFutureBuilder(
      {required this.future, required this.success, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => snapshot.hasData
          ? success(snapshot.data as T)
          : Center(
              child: snapshot.hasError
                  ? Text(
                      snapshot.error.toString(),
                    )
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
