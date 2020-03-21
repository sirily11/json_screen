import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/home/left/pageCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget Builder"),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: PageCardList(
              pages: provider.pages,
            ),
          ),
          Expanded(
            child: JsonScreen(
              pages: provider.pages,
            ),
          )
        ],
      ),
    );
  }
}
