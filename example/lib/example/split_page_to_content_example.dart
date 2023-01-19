import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const SplitPageToContentExample());
}

const _ratioA4 = 1.414;

class SplitPageToContentExample extends StatefulWidget {
  const SplitPageToContentExample({Key? key}) : super(key: key);

  @override
  State<SplitPageToContentExample> createState() => _SplitPageToContentExampleState();
}

class _SplitPageToContentExampleState extends State<SplitPageToContentExample> {
  int? activePage;

  double splitFraction = .3;

  var splitAxis = SplitAxis.left_right;

  bool isPagesFirst = true;

  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;

    final pagesFraction = isPagesFirst ? splitFraction : 1 - splitFraction;

    final pagesSize = splitAxis.isLeftRight //
        ? Size(windowSize.width * pagesFraction, windowSize.height)
        : Size(windowSize.width, windowSize.height * pagesFraction);

    final pagePadding = splitAxis.isLeftRight //
        ? EdgeInsets.all(pagesSize.width * .1)
        : EdgeInsets.all(pagesSize.height * .1);

    final pageSize = splitAxis.isLeftRight //
        ? useValue(
            pagesSize.width - pagePadding.horizontal,
            (v) => Size(
              v + pagePadding.horizontal,
              (v * _ratioA4) + pagePadding.vertical,
            ),
          )
        : useValue(
            pagesSize.height - pagePadding.vertical,
            (v) => Size(
              (v / _ratioA4) + pagePadding.horizontal,
              v + pagePadding.vertical,
            ),
          );

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: RowOrColumn(
          axis: windowSize.aspectRatio > 1 ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: ListGenerator.seperated(
            builder: (b, _) => b,
            seperator: const SizedBox.square(dimension: 10),
            list: [
              FloatingActionButton(
                onPressed: () => setState(() => splitAxis = splitAxis.next),
                child: splitAxis.isLeftRight
                    ? const Icon(Icons.horizontal_distribute)
                    : const Icon(Icons.vertical_distribute),
              ),
              FloatingActionButton(
                onPressed: () => setState(() => isPagesFirst = !isPagesFirst),
                child: isPagesFirst //
                    ? const Icon(Icons.looks_one)
                    : const Icon(Icons.looks_two),
              ),
            ],
          ),
        ),
        body: SplitPageToContent(
          splitAxis: splitAxis,
          isPagesFirst: isPagesFirst,
          splitFraction: splitFraction,
          splitFractionOnUpdate: (splitFraction) => setState(() => this.splitFraction = splitFraction),
          splitFractionKey: _key,
          pageCount: 100,
          pageExtent: splitAxis.isLeftRight ? pageSize.height : pageSize.width,
          pageActiveIndex: activePage,
          pageOnTap: (i) => setState(() => activePage = (i == activePage ? null : i)),
          pageBuild: (i) => _builder(i, activePage == i ? pagePadding * .5 : pagePadding),
          //  pageScrollController: , // TODO add other example where center of the scroll becomes active, using decorated scrollable
          contentBuild: () => activePage == null ? Container() : _builder(activePage!, pagePadding),
        ),
      ),
    );
  }

  Widget _builder(int i, EdgeInsets padding) => Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: 1 / _ratioA4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: activePage != i
                  ? null
                  : const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                        offset: Offset(1, 1),
                      )
                    ],
            ),
            child: Center(
              child: AutoSizeText(
                text: "$i",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      );
}
