// import 'package:flutter/material.dart';

// abstract class TableData {
//   final bool _isHeader;
//   final String text;

//   const TableData({required this.text, bool isHeader = false})
//       : _isHeader = isHeader;

//   static TableData getHeader() => throw "Header not defined";

//   bool get isHeader => _isHeader;
// }

// class ABC extends TableData {
//   ABC({super.isHeader = false, required super.text});

//   @override
//   static TableData getHeader() => ABC(text: 'Header', isHeader: true);
// }

// class CustomTableWidget<T extends TableData> extends StatefulWidget {
//   final List<T> data;

//   const CustomTableWidget({
//     super.key,
//     required this.data,
//   });

//   @override
//   State<CustomTableWidget<T>> createState() => _CustomTableWidgetState<T>();
// }

// class _CustomTableWidgetState<T extends TableData>
//     extends State<CustomTableWidget<T>> {
//   @override
//   Widget build(BuildContext context) {
//     final headerData = T.getHeader(); // Use static method to get the header

//     return Column(
//       children: [
//         Text(headerData.text), // Display header text
//         Expanded(
//           child: ListView.builder(
//             itemCount: widget.data.length,
//             itemBuilder: (context, i) => Text(
//               widget.data[i].text,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }