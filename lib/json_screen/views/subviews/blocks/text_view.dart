import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class TextView extends StatelessWidget {
  final TextBlock block;
  final bool center;

  TextView({this.block, this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${block.content}",
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: center ? TextAlign.center : null,
    );
  }
}
