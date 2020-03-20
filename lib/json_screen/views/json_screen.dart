import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/converter.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

typedef void OnLinkTap(String link);
typedef void OnImageTap(String imageSrc);

class JsonScreen extends StatefulWidget {
  final List<Map<String, dynamic>> json;
  final OnLinkTap onLinkTap;
  final OnImageTap onImageTap;

  JsonScreen({@required this.json, this.onImageTap, this.onLinkTap});

  @override
  _JsonScreenState createState() => _JsonScreenState();
}

class _JsonScreenState extends State<JsonScreen> {
  List<Page> pages = [];
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    JSONConverter converter = JSONConverter(json: widget.json);
    this.pages = converter.convert();
    super.initState();
  }

  @override
  void didUpdateWidget(JsonScreen oldWidget) {
    if (oldWidget.json != widget.json) {
      JSONConverter converter = JSONConverter(json: widget.json);

      setState(() {
        this.pages = converter.convert();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = this
        .pages
        .map(
          (e) => Scrollbar(
            child: SingleChildScrollView(
              child: renderPage(e),
            ),
          ),
        )
        .toList();

    return Stack(
      children: <Widget>[
        PageView(
          children: pages,
          onPageChanged: (index) {
            _currentPageNotifier.value = index;
          },
        ),
        pages.length > 0
            ? Positioned(
                bottom: 30,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: CirclePageIndicator(
                    currentPageNotifier: _currentPageNotifier,
                    itemCount: pages.length,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
