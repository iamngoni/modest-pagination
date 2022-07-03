import 'package:flutter/material.dart';
import 'package:handy_extensions/handy_extensions.dart';
import 'package:modest_pagination/src/type_defs.dart';

class ModestPagination<T> extends StatefulWidget {
  const ModestPagination({
    super.key,
    required this.items,
    required this.childWidget,
    this.innerPaginationCount = 8,
    this.outerPaginationCount = 10,
    this.innerIconsColor = const Color(0xFF00595F),
    this.outerIconsColor = const Color(0xFF00595F),
    this.innerIconsSize = 24,
    this.outerIconsSize = 24,
    this.activeIndexColor = const Color(0xFF00595F),
    this.inactiveIndexColor = const Color(0xFF00595F),
    this.activeTextSize = 16,
    this.inactiveTextSize = 16,
    this.useListView = true,
    this.gridViewCrossAxisCount = 2,
  });

  final List<T> items;
  final ChildWidget childWidget;
  final int innerPaginationCount;
  final int outerPaginationCount;
  final Color innerIconsColor;
  final Color outerIconsColor;
  final double innerIconsSize;
  final double outerIconsSize;
  final Color activeIndexColor;
  final Color inactiveIndexColor;
  final double activeTextSize;
  final double inactiveTextSize;
  final bool useListView;
  final int gridViewCrossAxisCount;

  @override
  State<ModestPagination<T>> createState() => _ModestPaginationState<T>();
}

class _ModestPaginationState<T> extends State<ModestPagination<T>> {
  final PageController innerPageController = PageController(initialPage: 0);
  final PageController outerPageController = PageController(initialPage: 0);

  int index = 0;

  List<List<T>>? innerItems;
  List<List<List<T>>>? outerItems;
  List<int>? outerIndexes;

  @override
  void initState() {
    innerItems = widget.items.partition(chunkSize: widget.innerPaginationCount)
        as List<List<T>>;
    outerItems = innerItems?.partition(chunkSize: widget.outerPaginationCount)
        as List<List<List<T>>>;
    outerIndexes = Iterable<int>.generate(outerItems!.length).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: outerPageController,
      children: outerIndexes!.map((int outerIndex) {
        List<List<T>> currentItems = outerItems![outerIndex];
        int totalPages = currentItems.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: innerPageController,
                children: currentItems.map((List<T> i) {
                  return widget.useListView
                      ? ListView(
                          children: i.map((T element) {
                            return widget.childWidget(element);
                          }).toList(),
                        )
                      : GridView.count(
                          crossAxisCount: widget.gridViewCrossAxisCount,
                        );
                }).toList(),
              ),
            ),
            Container(
              width: context.width,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      outerPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      innerPageController.jumpToPage(0);
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Icon(
                      Icons.fast_rewind_rounded,
                      color: widget.outerIconsColor,
                      size: widget.outerIconsSize,
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: InkWell(
                      onTap: () {
                        setState(() {
                          index != 0 ? index-- : 0;
                        });
                        innerPageController.jumpToPage(index);
                      },
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.play_arrow,
                          color: widget.innerIconsColor,
                          size: widget.innerIconsSize,
                        ),
                      ),
                    ),
                    secondChild: const SizedBox.shrink(),
                    crossFadeState: index != 0
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        totalPages,
                        (pageIndex) => InkWell(
                          onTap: () {
                            setState(() {
                              index = pageIndex;
                            });
                            innerPageController.jumpToPage(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "${(outerIndex * widget.outerPaginationCount) + (pageIndex + 1)}",
                              style: TextStyle(
                                color: index == pageIndex
                                    ? widget.activeIndexColor
                                    : widget.inactiveIndexColor,
                                fontWeight: index == pageIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: index == pageIndex
                                    ? widget.activeTextSize
                                    : widget.inactiveTextSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: InkWell(
                      onTap: () {
                        setState(() {
                          index != totalPages - 1 ? index++ : index = 0;
                        });
                        innerPageController.jumpToPage(index);
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color: widget.innerIconsColor,
                        size: widget.innerIconsSize,
                      ),
                    ),
                    secondChild: const SizedBox.shrink(),
                    crossFadeState: index != totalPages - 1
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                  InkWell(
                    onTap: () {
                      outerPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      innerPageController.jumpToPage(0);
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Icon(
                      Icons.fast_forward_rounded,
                      color: widget.outerIconsColor,
                      size: widget.outerIconsSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }).toList(),
    );
  }
}
