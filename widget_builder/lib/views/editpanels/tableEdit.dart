import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockTypesSelector.dart';
import 'package:widget_builder/views/home/popup/addItemDialog.dart';

class TableEditPanel extends StatefulWidget {
  final TableBlock block;

  TableEditPanel({@required this.block});

  @override
  _TableEditPanelState createState() => _TableEditPanelState();
}

class _TableEditPanelState extends State<TableEditPanel> {
  ListStyles styles;

  @override
  void initState() {
    super.initState();
  }

  Widget buildRows(List<List<Block>> blocks) {
    WidgetProvider provider = Provider.of(context, listen: false);
    List<Widget> w = blocks
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ExpansionTile(
              title: Text("Row"),
              trailing: IconButton(
                tooltip: "Delete row",
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.block.rows.remove(e);
                  provider.updateBlock(widget.block, widget.block);
                },
              ),
              children: e
                  .map(
                    (el) => ListTile(
                      title: Text("Row"),
                      subtitle: Text(el.content),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
        .toList();
    List<Widget> widgets = [
      ...w,
      IconButton(
        tooltip: "Add Row",
        onPressed: () {
          showDialog(
            context: context,
            builder: (c) => AddMultipleItemWidget(
              title: "Add Row",
              titles: widget.block.columns.map((e) => e.content).toList(),
              onTextSubmit: (v) {
                widget.block.rows.add(
                  v.map((e) => TextBlock(content: e)).toList(),
                );
                provider.updateBlock(widget.block, widget.block);
              },
            ),
          );
        },
        icon: Icon(Icons.add),
      ),
    ];

    return ExpansionTile(
      title: Text("Table Rows"),
      children: widgets,
    );
  }

  Widget buildColumn(List<Block> blocks) {
    List<Widget> w = blocks
        .map(
          (e) => ListTile(
            title: Text("Column"),
            subtitle: Text(e.content),
          ),
        )
        .toList();
    List<Widget> widgets = [
      ...w,
      IconButton(
        tooltip: "Add Column",
        onPressed: () {
          WidgetProvider provider = Provider.of(context, listen: false);
          showDialog(
            context: context,
            builder: (c) => AddItemWidget(
              title: "Add Column",
              onTextSubmit: (v) {
                widget.block.columns.add(TextBlock(content: v));
                provider.updateBlock(widget.block, widget.block);
              },
            ),
          );
        },
        icon: Icon(Icons.add),
      ),
    ];

    return ExpansionTile(
      title: Text("Table Colums"),
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
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
        buildColumn(widget.block.columns),
        buildRows(widget.block.rows)
      ],
    );
  }
}
