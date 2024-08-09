import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'file_data.dart';
import 'future.dart';
import 'sorting_data.dart';
import 'table.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _selectedDirectory;
  Future<List<FileData>>? _future;

  Future<void> _pickDirectory() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      setState(() {
        _selectedDirectory = directoryPath;
        _future = getFolderStructure(directoryPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedDirectory ?? 'No folder selected'),
        actions: [
          IconButton(
            onPressed: _pickDirectory,
            icon: const Icon(Icons.drive_file_move_outlined),
          ),
        ],
      ),
      body: _future == null
          ? const Center(
              child: Text(
                'No folder selected',
              ),
            )
          : CustomFutureBuilder(
              future: _future!,
              success: (x) => CustomTable(
                header: FileData.header(),
                data: x,
                element: (e) => [
                  e.path,
                  e.formatFileSize(),
                ],
                sort: <SortingData<FileData>>[
                  SortingData(
                    onASC: (a, b) => a.path.compareTo(b.path),
                    onDESC: (a, b) => b.path.compareTo(a.path),
                  ),
                  SortingData(
                    onASC: (a, b) => a.size.compareTo(b.size),
                    onDESC: (a, b) => b.size.compareTo(a.size),
                  ),
                ],
              ),
            ),
    );
  }
}
