import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockTypesSelector.dart';

class ImageEditPanel extends StatefulWidget {
  final ImageBlock block;

  ImageEditPanel({@required this.block});

  @override
  _BlockEditPanelState createState() => _BlockEditPanelState();
}

class _BlockEditPanelState extends State<ImageEditPanel> {
  TextEditingController controller;
  TextEditingController srcController;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.block.content);
    srcController = TextEditingController(text: widget.block.data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller,
                onChanged: (v) {
                  WidgetProvider provider = Provider.of(context, listen: false);
                  widget.block.content = v;
                  provider.updateBlock(widget.block, widget.block);
                },
                decoration: InputDecoration(labelText: "Label"),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: srcController,
                onChanged: (v) {
                  WidgetProvider provider = Provider.of(context, listen: false);
                  widget.block.data = v;
                  provider.updateBlock(widget.block, widget.block);
                },
                decoration: InputDecoration(labelText: "Image Src"),
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
        )
      ],
    );
  }
}
