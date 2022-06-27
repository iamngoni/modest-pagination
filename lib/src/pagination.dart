import 'package:flutter/material.dart';
import 'package:handy_extensions/handy_extensions.dart';

class ModestPagination<T> extends StatefulWidget {
  const ModestPagination({
    Key? key,
    required this.items,
    this.innerPaginationCount = 8,
    this.outerPaginationCount = 10,
  }) : super(key: key);

  final List<T> items;
  final int innerPaginationCount;
  final int outerPaginationCount;

  @override
  State<ModestPagination<T>> createState() => _ModestPaginationState<T>();
}

class _ModestPaginationState<T> extends State<ModestPagination<T>> {

  final PageController innerPageController = PageController(initialPage: 0);
  final PageController outerPageController = PageController(initialPage: 0);

  List<List<T>>? innerItems;
  List<List<List<T>>>? outerItems;


  @override
  void initState() {
    innerItems = widget.items.partition(chunkSize: widget.innerPaginationCount)
        as List<List<T>>;
    outerItems = innerItems?.partition(chunkSize: widget.outerPaginationCount)
        as List<List<List<T>>>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
