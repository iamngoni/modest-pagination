import 'package:flutter/material.dart';
import 'package:handy_extensions/handy_extensions.dart';

class ModestPagination<T> extends StatefulWidget {
  /// ModestPagination
  ///
  /// Simple to use pagination component you can include in your code for fast
  /// results

  /// The list with items of type [T] to be paginated
  /// e.g. paginating a list of countries
  final List<T> items;

  /// A function that returns the widget to be displayed for each item in the
  /// list [items]. E.g. if your list of items is List<int> then your function
  /// has to take an integer as the parameter type -> [Widget Function(int element)]
  final Widget Function(T element) childWidget;

  /// Number of items for be listed on each page on either the [GridView] or the
  /// [ListView]
  final int itemsPerPage;

  /// Number of pages to be shown per sheet e.g. each sheet by default will show
  /// 6 pages i.e. from 1-6 and sheet 2 will display 7-12
  final int pagesPerSheet;

  /// Color of the icons that control the scrolling between pages in a sheet
  final Color pagesControllerIconsColor;

  /// Color of the icons that control the scrolling between sheets
  final Color sheetsControllerIconsColor;

  /// Size of the icons that control scrolling between pages
  /// These are the icons that are inside and can hide when the current page is
  /// the first or last one in that sheet
  final double pagesControllerIconsSize;

  /// Size of the icons that control scrolling between sheets.
  /// These are the icons that are seen at the end
  final double sheetsControllerIconsSize;

  /// Color of the active index in a sheet
  final Color activeTextColor;

  /// Color of the other inactive indexes in a sheet.
  /// This will help show which page is currently active and can help in switching
  /// pages
  final Color inactiveTextColor;

  /// Text size of the active index in a sheet
  final double activeTextSize;

  /// Text size of the other inactive indexes in a sheet. Making this different
  /// from the [activeTextSize] will help show difference between current page
  /// and the other pages
  final double inactiveTextSize;

  /// Choose between using [ListView] or [GridView] for displaying data. By default
  /// this will use [ListView]. For [GridView] this will use [GridView.count]
  final bool useListView;

  /// Number of items to be displayed across each other in a row like view i.e.
  /// if you choose to use it instead
  /// of the [ListView]
  final int gridViewCrossAxisCount;

  /// Cross Axis Spacing for the [GridView] i.e. if you choose to use it instead
  /// of the [ListView]
  final double gridViewCrossAxisSpacing;

  /// Main Axis Spacing for the [GridView] i.e. if you choose to use it instead
  /// of the [ListView]
  final double gridViewMainAxisSpacing;

  /// Child Aspect Ratio for the [GridView] i.e. if you choose to use it instead
  /// of the [ListView]
  final double gridViewChildAspectRatio;

  const ModestPagination({
    super.key,
    this.pagesControllerIconsColor = const Color(0xFF00595F),
    this.sheetsControllerIconsColor = const Color(0xFF00595F),
    this.activeTextColor = const Color(0xFF00595F),
    this.inactiveTextColor = const Color(0xFF00595F),
    this.useListView = true,
    this.itemsPerPage = 8,
    this.pagesPerSheet = 6,
    this.pagesControllerIconsSize = 24,
    this.sheetsControllerIconsSize = 24,
    this.activeTextSize = 16,
    this.inactiveTextSize = 16,
    this.gridViewCrossAxisCount = 2,
    this.gridViewCrossAxisSpacing = 10,
    this.gridViewMainAxisSpacing = 10,
    this.gridViewChildAspectRatio = 1,
    required this.items,
    required this.childWidget,
  });

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
    innerItems =
        widget.items.partition(chunkSize: widget.itemsPerPage) as List<List<T>>;
    outerItems = innerItems?.partition(chunkSize: widget.pagesPerSheet)
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
                          crossAxisSpacing: widget.gridViewCrossAxisSpacing,
                          mainAxisSpacing: widget.gridViewMainAxisSpacing,
                          childAspectRatio: widget.gridViewChildAspectRatio,
                          children: i.map((T element) {
                            return widget.childWidget(element);
                          }).toList(),
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
                      color: widget.sheetsControllerIconsColor,
                      size: widget.sheetsControllerIconsSize,
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
                          color: widget.pagesControllerIconsColor,
                          size: widget.pagesControllerIconsSize,
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
                              "${(outerIndex * widget.pagesPerSheet) + (pageIndex + 1)}",
                              style: TextStyle(
                                color: index == pageIndex
                                    ? widget.activeTextColor
                                    : widget.inactiveTextColor,
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
                        color: widget.pagesControllerIconsColor,
                        size: widget.pagesControllerIconsSize,
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
                      color: widget.sheetsControllerIconsColor,
                      size: widget.sheetsControllerIconsSize,
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
