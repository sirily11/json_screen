import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class TextView extends StatelessWidget {
  final TextBlock block;

  TextView({this.block});

  @override
  Widget build(BuildContext context) {
    return Text("${block.content}");
  }
}
