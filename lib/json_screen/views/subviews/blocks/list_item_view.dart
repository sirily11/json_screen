import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

class ListItemView extends StatelessWidget {
  final ListItemBlock block;
  final OnLinkTap onLinkTap;
  final OnImageTap onImageTap;
  ListItemView({@required this.block, this.onImageTap, this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    Widget title = renderBlock(block.title, onLinkTap, onImageTap);
    Widget subtitle = renderBlock(block.subtitle, onLinkTap, onImageTap);
    Widget leading = renderBlock(block.leading, onLinkTap, onImageTap);
    Widget ending = renderBlock(block.ending, onLinkTap, onImageTap);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        title: block.title != null ? title : null,
        trailing: block.ending != null
            ? Container(width: block.ending.width ?? 100, child: ending)
            : null,
        subtitle: block.subtitle != null ? subtitle : null,
        leading: block.leading != null
            ? Container(
                width: block.leading.width ?? 100,
                child: leading,
              )
            : null,
      ),
    );
  }
}
