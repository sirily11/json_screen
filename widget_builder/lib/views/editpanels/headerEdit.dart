import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockTypesSelector.dart';

class HeaderEditPanel extends StatefulWidget {
  final HeaderBlock block;

  HeaderEditPanel({@required this.block});

  @override
  _HeaderEditPanelState createState() => _HeaderEditPanelState();
}

class _HeaderEditPanelState extends State<HeaderEditPanel> {
  TextEditingController controller;
  TextEditingController headerLevelController;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.block.content);
    headerLevelController = TextEditingController(
      text: widget.block.level.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: controller,
                onChanged: (v) {
                  WidgetProvider provider = Provider.of(context, listen: false);
                  widget.block.content = v;
                  provider.updateBlock(widget.block, widget.block);
                },
                decoration: InputDecoration(labelText: "Block Content"),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: headerLevelController,
                autovalidate: true,
                validator: (v) {
                  int value = int.tryParse(v);
                  if (value == null) {
                    return "Value invaild";
                  } else if (value > 6 || value < 0) {
                    return "Value should within the range 0-6";
                  }
                  return null;
                },
                onChanged: (v) {
                  WidgetProvider provider = Provider.of(context, listen: false);
                  widget.block.level = int.tryParse(v);
                  provider.updateBlock(widget.block, widget.block);
                },
                decoration: InputDecoration(labelText: "Header level"),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: widget.block.label,
                onChanged: (v) {
                  WidgetProvider provider = Provider.of(context, listen: false);
                  widget.block.label = v;
                  provider.updateBlock(widget.block, widget.block);
                },
                decoration: InputDecoration(labelText: "Block Label"),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Blcok Types"),
            Container(
                child: BlockTypesSelector(
              block: widget.block,
              select: (t) {
                widget.block.types = t;
              },
              selectedType: widget.block.types,
            ))
          ],
        ),
      ],
    );
  }
}
