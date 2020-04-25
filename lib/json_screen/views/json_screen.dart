import 'package:flutter/material.dart' hide Page;
import 'package:json_screen/json_screen/models/converter.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

typedef Future<void> OnLinkTap(String link);
typedef Future<void> OnImageTap(String imageSrc);

class JsonScreen extends StatefulWidget {
  final List<dynamic> json;
  final List<Page> pages;

  /// Default is json. You can choose use XmlConverter or JSONConverter
  /// If you use this parameter, you can ignore the json field
  final Converter converter;
  final OnLinkTap onLinkTap;
  final OnImageTap onImageTap;

  /// Base image url.
  /// If the conver is defined, then this field will have no effect
  final String baseURL;

  JsonScreen({
    this.json,
    this.onImageTap,
    this.onLinkTap,
    this.pages,
    this.converter,
    this.baseURL,
  });

  @override
  _JsonScreenState createState() => _JsonScreenState();
}

class _JsonScreenState extends State<JsonScreen> {
  List<Page> pages = [];
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    if (widget.json != null) {
      print("convert json");
      Converter converter = widget.converter ??
          JSONConverter(
            json: widget.json,
            baseURL: widget.baseURL,
          );
      this.pages = converter.convert();
    } else if (widget.pages != null) {
      this.pages = widget.pages;
    } else {
      throw Exception("JSON or Pages must be provided");
    }

    super.initState();
  }

  @override
  void didUpdateWidget(JsonScreen oldWidget) {
    if (widget.json != null && oldWidget.json != widget.json) {
      JSONConverter converter = widget.converter ??
          JSONConverter(json: widget.json, baseURL: widget.baseURL);
      setState(() {
        this.pages = converter.convert();
      });
    } else if (widget.pages != null && oldWidget.pages != widget.pages) {
      setState(() {
        this.pages = widget.pages;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: this.pages.length,
            itemBuilder: (context, index) {
              return Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: SingleChildScrollView(
                    key: Key("page-$index"),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: renderPage(this.pages[index], context,
                          widget.onLinkTap, widget.onImageTap),
                    ),
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              _currentPageNotifier.value = index;
            },
          ),
          pages.length > 0
              ? Positioned(
                  bottom: 30,
                  width: cons.maxWidth,
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
    });
  }
}
