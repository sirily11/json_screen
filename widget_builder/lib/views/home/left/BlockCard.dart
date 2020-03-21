import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockEdit.dart';
import 'package:widget_builder/views/editpanels/headerEdit.dart';
import 'package:widget_builder/views/editpanels/imageEdit.dart';
import 'package:widget_builder/views/editpanels/linkEdit.dart';
import 'package:widget_builder/views/editpanels/listEdit.dart';
import 'package:widget_builder/views/editpanels/quoteEdit.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:widget_builder/views/editpanels/tableEdit.dart';

class BlockCard extends StatelessWidget {
  final Block block;
  final c.Container container;

  BlockCard({@required this.block, @required this.container});

  Widget _renderBlockEdit() {
    if (block is HeaderBlock) {
      return HeaderEditPanel(
        block: block,
      );
    } else if (block is LinkBlock) {
      return LinkEditPanel(
        block: block,
      );
    } else if (block is QuoteBlock) {
      return QuoteEditPanel(
        block: block,
      );
    } else if (block is ImageBlock) {
      return ImageEditPanel(
        block: block,
      );
    } else if (block is ListBlock) {
      return ListEditPanel(
        block: block,
      );
    } else if (block is TableBlock) {
      return TableEditPanel(
        block: block,
      );
    }
    return BlockEditPanel(
      block: block,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: ExpansionTile(
        title: Text(
          "${block.types.toString()}",
        ),
        subtitle: Text("${block.content}"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 20, right: 40),
            child: Row(
              children: <Widget>[
                Expanded(flex: 15, child: _renderBlockEdit()),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        tooltip: "Move Block Up",
                        onPressed: () {
                          provider.moveBlockUp(block);
                        },
                        icon: Icon(Icons.keyboard_arrow_up),
                      ),
                      IconButton(
                        tooltip: "Move Block Down",
                        onPressed: () {
                          provider.moveBlockDown(block);
                        },
                        icon: Icon(Icons.keyboard_arrow_down),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                tooltip: "Delete block",
                onPressed: () {
                  provider.removeBlock(block, container);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          )
        ],
      ),
    );
  }
}
