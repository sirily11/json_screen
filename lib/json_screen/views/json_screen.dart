import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/converter.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:json_screen/json_screen/views/subviews/blocks/image_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/text_view.dart';

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

  /// render List of blocks
  Widget _renderBlock(Block block) {
    if (block is ImageBlock) {
      return ImageView(
        block: block,
      );
    } else if (block is TextBlock) {
      return TextView(
        block: block,
      );
    }
    return null;
  }

  /// render page
  Widget _renderPage(Page page){
   
  }


  /// render container
  Widget _renderContainer(c.Container container) {
    if (container is c.HorizontalCarousel) {}

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: []),
    );
  }
}
