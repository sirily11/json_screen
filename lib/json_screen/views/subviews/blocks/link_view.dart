import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

class LinkView extends StatelessWidget {
  final OnLinkTap onLinkTap;
  final LinkBlock block;

  LinkView({this.onLinkTap, this.block});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.onLinkTap != null) {
          onLinkTap(block.data);
        }
      },
      child: Text(
        "${block.content}",
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }
}
