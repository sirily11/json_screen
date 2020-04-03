import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/container.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:xml/xml.dart' as xmlParser;

abstract class Converter {
  /// convert data into pages
  List<Page> convert();
}

class XMLConverter implements Converter {
  /// json data
  String xml;

  XMLConverter({this.xml});

  /// Convert containers xml
  List<Container> _convertContainer(List<xmlParser.XmlNode> xmlNodes) {
    for(var node in xmlNodes){
      if(node.)
    }
  }

  /// convert json into blocks
  List<Block> _convertBlock(List<xmlParser.XmlNode> xmlNodes) {
    
  }

  @override
  List<Page<Container<Block>>> convert() {
    final document = xmlParser.parse(xml);
    List<Page> pages = [];
    for (var page in document.children) {
      var containers = this._convertContainer(page.children);
      pages.add(Page(containers: containers));
    }
  }
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
      var blocks = this._convertBlock(j['blocks'] ?? []);
      var container = Container.fromJSON(j);
      switch (container.types) {
        case ContainerTypes.container:
          containers.add(Container(children: blocks, types: container.types));
          break;
        case ContainerTypes.horizontal:
          containers.add(HorizontalCarousel(children: blocks));
          break;
        case ContainerTypes.story:
          double height = j['height'];
          double width = j['width'];
          containers.add(
              StoryContainer(children: blocks, width: width, height: height));
          break;
        case ContainerTypes.form:
          containers.add(FormContainer.fromJSON(j));
          break;
        case ContainerTypes.timeline:
          containers
              .add(TimelineContainer(children: blocks, types: container.types));
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
          if (block.content?.endsWith("\n") ?? false) {
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
          ListStyles styles = ListBlock.getStyles(j);
          List<Block> children = this._convertBlock(j['children'] ?? []);
          blocks.add(
            ListBlock(
                children: children, content: block.content, styles: styles),
          );
          break;
        case BlockTypes.header:
          blocks.add(HeaderBlock.fromJSON(j));
          blocks.add(NewLineBlock());
          break;
        case BlockTypes.link:
          blocks.add(LinkBlock.fromJSON(j));
          break;
        case BlockTypes.web:
          blocks.add(WebViewBlock.fromJSON(j));
          break;
        case BlockTypes.newline:
          blocks.add(NewLineBlock());
          break;
      }
    }

    return blocks;
  }
}
