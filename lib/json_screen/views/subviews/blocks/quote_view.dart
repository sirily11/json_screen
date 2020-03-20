import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class QuoteView extends StatelessWidget {
  final QuoteBlock block;

  QuoteView({this.block});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryTextTheme.headline6.color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            block.content,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}
