import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/container.dart';
import 'package:json_screen/json_screen/models/page.dart';

abstract class Converter {
  /// convert data into pages
  List<Page> convert();
}

/// A JSON converter which can convert json
/// into pages.
class JSONConverter implements Converter {
  /// json data
  List<dynamic> json;

  JSONConverter({this.json});

  @override
  List<Page> convert() {
    List<Page> pages = [];
    for (var j in json) {
      var containers = this._convertContainer(j['containers']);
      var page = Page.fromJSON(j);

      switch (page.types) {
        case PageTypes.page:
          pages.add(Page(containers: containers));
          break;
      }
    }

    return pages;
  }

  /// Convert containers json
  List<Container> _convertContainer(List<dynamic> containerJSON) {
    List<Container> containers = [];

    for (var j in containerJSON) {
      var blocks = this._convertBlock(j['blocks']);
      var container = Container.fromJSON(j);
      switch (container.types) {
        case ContainerTypes.container:
          containers.add(Container(children: blocks, types: container.types));
          break;
        case ContainerTypes.horizontal:
          containers.add(HorizontalCarousel(children: blocks));
          break;
      }
    }
    return containers;
  }

  /// convert json into blocks
  List<Block> _convertBlock(List<dynamic> blockJSON) {
    List<Block> blocks = [];
    for (var j in blockJSON) {
      Block block = Block.fromJSON(j);
      switch (block.types) {
        case BlockTypes.text:
          blocks.add(TextBlock.fromJSON(j));
          // add new line if end with \n
          if (block.content.endsWith("\n")) {
            blocks.add(NewLineBlock());
          }
          break;
        case BlockTypes.image:
          blocks.add(ImageBlock.fromJSON(j));
          break;
        case BlockTypes.quote:
          blocks.add(QuoteBlock.fromJSON(j));
          blocks.add(NewLineBlock());
          break;
        case BlockTypes.table:
          List<Block> columns = this._convertBlock(j['columns']);
          List<List<Block>> rows = (j['rows'] as List<List>)
              .map((e) => this._convertBlock(e))
              .toList();
          blocks.add(
            TableBlock(columns: columns, rows: rows, content: block.content),
          );
          blocks.add(NewLineBlock());
          break;
        case BlockTypes.list:
          List<Block> children = this._convertBlock(j['children'] ?? []);
          blocks.add(ListBlock(children: children, content: block.content));
          break;
        case BlockTypes.header:
          blocks.add(HeaderBlock.fromJSON(j));
          blocks.add(NewLineBlock());
          break;
        case BlockTypes.link:
          blocks.add(LinkBlock.fromJSON(j));
          break;
      }
    }

    return blocks;
  }
}
