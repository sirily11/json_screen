import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';

typedef void OnTypeSelect(BlockTypes types);

class BlockTypesSelector extends StatelessWidget {
  final OnTypeSelect select;
  final BlockTypes selectedType;
  final Block block;

  BlockTypesSelector({this.select, this.selectedType, this.block});

  /// transform block into new [types]
  Block getNewBlock(BlockTypes types, Block block) {
    switch (types) {
      case BlockTypes.text:
        return TextBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.image:
        return ImageBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.quote:
        return QuoteBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.table:
        return TableBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.list:
        return ListBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.header:
        return HeaderBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.link:
        return LinkBlock.copyWith(content: block.content, label: block.label);
      case BlockTypes.newline:
        return NewLineBlock();
      default:
        return TextBlock.copyWith(content: block.content, label: block.label);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BlockTypes>(
      value: selectedType,
      onChanged: (v) {
        if (select != null) {
          WidgetProvider provider = Provider.of(context, listen: false);
          select(v);
          var newBlock = getNewBlock(v, block);
          provider.updateBlock(newBlock, block);
        }
      },
      items: BlockTypes.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.toString()),
            ),
          )
          .toList(),
    );
  }
}
