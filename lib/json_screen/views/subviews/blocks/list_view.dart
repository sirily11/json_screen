import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

class ListViewView extends StatelessWidget {
  final ListBlock block;
  final OnLinkTap onLinkTap;
  final OnImageTap onImageTap;

  ListViewView({this.block, this.onLinkTap, this.onImageTap});

  Widget _renderUnorderedList(Block block) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: block.content != null ? "- " : ""),
          WidgetSpan(child: renderBlock(block, onLinkTap, onImageTap))
        ],
      ),
    );
  }

  Widget _renderOrderedList(Block block, int index) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: block.content != null ? "${index + 1}. " : ""),
          WidgetSpan(child: renderBlock(block, onLinkTap, onImageTap))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: block.children.length,
        itemBuilder: (context, index) {
          switch (block.styles) {
            case ListStyles.ordered:
              return _renderOrderedList(block.children[index], index);

            default:
              return _renderUnorderedList(block.children[index]);
          }
        },
      ),
    );
  }
}
