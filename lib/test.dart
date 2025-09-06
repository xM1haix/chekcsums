import "package:file_selector/file_selector.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class GetDirectoryPage extends StatelessWidget {
  GetDirectoryPage({super.key});
  final bool _isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Open a text file")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _isIOS ? null : () => _getDirectoryPath(context),
              child: const Text("Press to ask user to choose a directory."),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirectoryPath(BuildContext context) async {
    const confirmButtonText = "Choose";
    final directoryPath = await getDirectoryPath(
      confirmButtonText: confirmButtonText,
    );
    if (directoryPath == null) {
      return;
    }
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => TextDisplay(directoryPath),
      );
    }
  }
}

/// Widget that displays a text file in a dialog
class TextDisplay extends StatelessWidget {
  /// Default Constructor
  const TextDisplay(this.directoryPath, {super.key});

  /// Directory path
  final String directoryPath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selected Directory"),
      content: Scrollbar(
        child: SingleChildScrollView(child: Text(directoryPath)),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
