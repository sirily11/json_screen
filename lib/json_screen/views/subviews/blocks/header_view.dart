import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class HeaderView extends StatelessWidget {
  final HeaderBlock block;

  HeaderView({this.block});

  TextStyle _headerStyle(BuildContext context) {
    if (block.level == 4) {
      return Theme.of(context).textTheme.headline4;
    } else if (block.level == 5) {
      return Theme.of(context).textTheme.headline5;
    } else if (block.level == 6) {
      return Theme.of(context).textTheme.headline6;
    }
    return Theme.of(context).textTheme.headline3;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${block.content}",
      style: _headerStyle(context),
    );
  }
}
