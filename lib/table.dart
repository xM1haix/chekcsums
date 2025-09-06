import "dart:math";

import "package:chekcsums/extensions.dart";
import "package:chekcsums/sorting_data.dart";
import "package:flutter/material.dart";

class CustomTable<T> extends StatefulWidget {
  const CustomTable({
    required this.header,
    required this.data,
    required this.sort,
    required this.element,
    super.key,
  });
  final T header;
  final List<T> data;
  final List<SortingData<T>> sort;
  final List<String> Function(T) element;
  @override
  State<CustomTable<T>> createState() => _CustomTableState<T>();
}

class _CustomTableState<T> extends State<CustomTable<T>> {
  late final _h = widget.header;
  late final List<T> _data = widget.data;
  late final List<double> _minWidth;
  late final _columnWidth = List.generate(
    widget.element(_h).length,
    (x) => widget.element(_h)[x].width() + 50,
  );
  final _div = const Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: VerticalDivider(thickness: 3, width: 3, color: Colors.white),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            children: List.generate(
              widget.element(_h).length,
              (j) => Row(
                children: [
                  SizedBox(
                    width: _columnWidth[j],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.element(_h)[j],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (j + 1 < widget.element(_h).length)
                    GestureDetector(
                      onDoubleTap: () => _doubleTapMin(j),
                      onHorizontalDragUpdate: (x) => _resize(j, x),
                      child: _div,
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, i) {
              return SizedBox(
                height: 30,
                child: Row(
                  children: List.generate(widget.element(_data[i]).length, (j) {
                    return Row(
                      children: [
                        SizedBox(
                          width: _columnWidth[j],
                          child: Text(
                            widget.element(_data[i])[j],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (j + 1 < widget.element(_data[i]).length) _div,
                      ],
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _doubleTapMin(int j) => setState(() => _columnWidth[j] = _minWidth[j]);

  void _init() {
    for (var i = 0; i < _data.length; i++) {
      for (var j = 0; j < widget.element(_data[i]).length; j++) {
        _columnWidth[j] = max(
          _columnWidth[j],
          widget.element(_data[i])[j].width(),
        );
      }
    }
    _minWidth = _columnWidth.map((e) => e).toList();
  }

  void _resize(int j, DragUpdateDetails x) {
    setState(() {
      _columnWidth[j] += x.primaryDelta!;
      _columnWidth[j] = max(_columnWidth[j], widget.element(_h)[j].width());
    });
  }
}
