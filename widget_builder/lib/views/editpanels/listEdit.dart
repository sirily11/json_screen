import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockTypesSelector.dart';
import 'package:widget_builder/views/home/popup/addItemDialog.dart';

class ListEditPanel extends StatefulWidget {
  final ListBlock block;

  ListEditPanel({@required this.block});

  @override
  _BlockEditPanelState createState() => _BlockEditPanelState();
}

class _BlockEditPanelState extends State<ListEditPanel> {
  ListStyles styles;

  @override
  void initState() {
    super.initState();
  }

  Widget buildListItem(List<Block> blocks) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: blocks.length,
      itemBuilder: (c, i) {
        return ListTile(
          title: Text("List Item"),
          subtitle: Text(blocks[i].content),
          trailing: IconButton(
            onPressed: () {
              WidgetProvider provider = Provider.of(context, listen: false);
              widget.block.children.remove(blocks[i]);
              provider.updateBlock(widget.block, widget.block);
            },
            tooltip: "Delete list item",
            icon: Icon(Icons.delete),
          ),
        );
      },
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
            Text("List Type:"),
            Container(
              child: DropdownButton<ListStyles>(
                value: widget.block.styles,
                onChanged: (v) {
                  widget.block.styles = v;
                  WidgetProvider provider = Provider.of(context, listen: false);
                  provider.updateBlock(widget.block, widget.block);
                },
                items: ListStyles.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.toString(),
                        ),
                      ),
                    )
                    .toList(),
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
        buildListItem(widget.block.children),
        Center(
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => AddItemWidget(
                  title: "Add new list item",
                  onTextSubmit: (v) {
                    WidgetProvider provider =
                        Provider.of(context, listen: false);
                    widget.block.children.add(TextBlock(content: v));
                    provider.updateBlock(widget.block, widget.block);
                  },
                ),
              );
            },
            tooltip: "Add list item",
            icon: Icon(Icons.add_circle),
          ),
        ),
      ],
    );
  }
}
