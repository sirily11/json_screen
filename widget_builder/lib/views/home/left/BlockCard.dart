import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/blockEdit.dart';
import 'package:widget_builder/views/editpanels/headerEdit.dart';
import 'package:widget_builder/views/editpanels/linkEdit.dart';
import 'package:widget_builder/views/editpanels/quoteEdit.dart';

class BlockCard extends StatelessWidget {
  final Block block;

  BlockCard({@required this.block});

  Widget _renderBlockEdit() {
    if (block is HeaderBlock) {
      return HeaderEditPanel(
        block: block,
      );
    } else if (block is LinkEditPanel) {
      return LinkEditPanel(
        block: block,
      );
    } else if (block is QuoteBlock) {
      return QuoteEditPanel(
        block: block,
      );
    } else if (block is ImageBlock) {
      return QuoteEditPanel(
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
        title: Text(block.types.toString()),
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
          )
        ],
      ),
    );
  }
}
