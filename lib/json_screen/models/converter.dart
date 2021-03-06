import 'dart:convert';

import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/container.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:xml/xml.dart' as xmlParser;

import 'container.dart';
import 'container.dart';

abstract class Converter {
  /// convert data into pages
  List<Page> convert();
}

class XMLConverter implements Converter {
  /// json data
  String xml;

  /// base url for image
  final String baseURL;

  XMLConverter({this.xml, this.baseURL});

  /// Convert containers xml
  List<Container> _convertContainer(List<xmlParser.XmlNode> xmlNodes) {
    List<Container> containers = [];
    for (var node in xmlNodes) {
      var blocks = this._convertBlock(node.children, true);

      if (node is xmlParser.XmlElement) {
        var width = double.tryParse(node.getAttribute("width") ?? "");
        var height = double.tryParse(node.getAttribute("height") ?? "");
        bool center = node.getAttribute("center") == "true" ? true : false;

        switch (node.name.local) {
          case "list-container":
            var listItemNode = node.findElements("list-item").toList();
            var items = this
                ._convertBlock(listItemNode, false)
                .map((e) => e as ListItemBlock)
                .toList();
            containers.add(ListViewContainer(children: items));
            break;

          case "container":
            containers.add(Container(
              children: blocks,
              types: ContainerTypes.container,
              center: center,
            ));
            break;
          case "timeline":
            containers.add(
              TimelineContainer(
                  children: blocks, types: ContainerTypes.timeline),
            );
            break;
          case "horizontal":
            containers.add(HorizontalCarousel(
              children: blocks,
              height: height,
              width: width,
            ));
            break;
          case "form":
            var schema = JsonDecoder().convert(node.text);
            var url = node.getAttribute("url");
            var method = node.getAttribute("method");

            containers.add(
              FormContainer(
                schema: schema,
                url: url,
                method: method,
                height: height,
                width: width,
                children: blocks,
              ),
            );
            break;
          case "story":
            var height = node.getAttribute("height");
            var width = node.getAttribute("width");

            containers.add(
              StoryContainer(
                children: blocks,
                height: double.tryParse(height ?? ""),
                width: double.tryParse(width ?? ""),
              ),
            );
            break;
        }
      }
    }
    return containers;
  }

  /// convert json into blocks
  List<Block> _convertBlock(
      List<xmlParser.XmlNode> xmlNodes, bool autoNewline) {
    List<Block> blocks = [];
    for (var node in xmlNodes) {
      if (node is xmlParser.XmlElement) {
        String content = node.text;
        String label = node.getAttribute("label");
        String data = node.getAttribute("data");
        String h = node.getAttribute("height");
        String w = node.getAttribute("width");
        double height = h != null ? double.tryParse(h) : null;
        double width = w != null ? double.tryParse(w) : null;

        switch (node.name.local) {
          case "list-item":
            var leadingNode = node.findElements("list-leading").length > 0
                ? node.findElements("list-leading").first
                : null;
            var endingNode = node.findElements("list-ending").length > 0
                ? node.findElements("list-ending").first
                : null;
            var titleNode = node.findElements("list-title").length > 0
                ? node.findElements("list-title").first
                : null;
            var subtitleNode = node.findElements("list-subtitle").length > 0
                ? node.findElements("list-subtitle").first
                : null;

            Block leading = this
                        ._convertBlock(leadingNode?.children ?? [], false)
                        .length >
                    0
                ? this._convertBlock(leadingNode?.children ?? [], false).first
                : null;

            Block ending =
                this._convertBlock(endingNode?.children ?? [], false).length > 0
                    ? this
                        ._convertBlock(endingNode?.children ?? [], false)
                        .first
                    : null;

            Block title =
                this._convertBlock(titleNode?.children ?? [], false).length > 0
                    ? this._convertBlock(titleNode?.children ?? [], false).first
                    : null;
            Block subtitle = this
                        ._convertBlock(subtitleNode?.children ?? [], false)
                        .length >
                    0
                ? this._convertBlock(subtitleNode?.children ?? [], false).first
                : null;

            blocks.add(
              ListItemBlock(
                height: height,
                width: width,
                title: title,
                ending: ending,
                leading: leading,
                subtitle: subtitle,
              ),
            );
            break;

          case "text":
            blocks.add(
              TextBlock(
                content: node.text,
                label: label,
                height: height,
                width: width,
              ),
            );

            break;

          case "image":
            blocks.add(
              ImageBlock(
                label: label,
                data: data,
                content: content,
                height: height,
                width: width,
                baseURL: baseURL,
              ),
            );
            break;

          case "countdown":
            String abosulute = node.getAttribute("absolute");
            blocks.add(
              CountDownBlock(
                label: label,
                data: data,
                content: content,
                absolute: abosulute == "true" ? true : false,
              ),
            );
            if (autoNewline) blocks.add(NewLineBlock());
            break;

          case "header":
            int level = int.tryParse(node.getAttribute("level"));
            blocks.add(
              HeaderBlock(
                content: content,
                label: label,
                level: level,
                height: height,
                width: width,
              ),
            );
            if (autoNewline) blocks.add(NewLineBlock());
            break;

          case "link":
            blocks.add(
              LinkBlock(content: content, data: data, label: label),
            );
            break;

          case "quote":
            blocks.add(QuoteBlock(content: content, label: label));
            break;

          case "newline":
            blocks.add(NewLineBlock());
            break;

          case "divider":
            blocks.add(DividerBlock());
            break;

          case "list":
            var style = node.getAttribute("style");
            ListStyles listStyle = ListStyles.ordered;
            if (style == "unordered") {
              listStyle = ListStyles.unordered;
            }
            List<Block> children =
                this._convertBlock(node.children ?? [], false);
            blocks.add(
              ListBlock(
                  children: children,
                  content: content,
                  label: label,
                  styles: listStyle),
            );
            break;

          case "table":
            List<Block> columns = this._convertBlock(
              node.findElements("column").first?.children,
              false,
            );
            List<List<Block>> rows = (node.findElements("row").toList())
                .map((e) => this._convertBlock(e.children, false))
                .toList();
            String content = node.findAllElements("header").length > 0
                ? node.findAllElements("header").first.text
                : null;
            blocks.add(
              TableBlock(
                content: content,
                label: label,
                columns: columns,
                rows: rows,
              ),
            );
            break;
        }
      }
    }
    return blocks;
  }

  @override
  List<Page<Container<Block>>> convert() {
    final document = xmlParser.parse(xml);
    List<Page> pages = [];
    for (var page in document.findAllElements("page")) {
      var containers = this._convertContainer(page.children);
      pages.add(Page(containers: containers));
    }
    return pages;
  }
}

/// A JSON converter which can convert json
/// into pages.
class JSONConverter implements Converter {
  /// json data
  final List<dynamic> json;
  final String baseURL;

  JSONConverter({this.json, this.baseURL});

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
      double height = j['height'];
      double width = j['width'];
      switch (container.types) {
        case ContainerTypes.container:
          containers.add(
            Container(
              children: blocks,
              types: container.types,
              center: container.center,
              width: container.width,
              height: container.height,
            ),
          );
          break;
        case ContainerTypes.horizontal:
          containers.add(HorizontalCarousel(
            children: blocks,
            height: height,
            width: width,
          ));
          break;
        case ContainerTypes.story:
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
        case ContainerTypes.list:
          containers.add(
            ListViewContainer(
              children: blocks.map((e) => e as ListItemBlock).toList(),
            ),
          );
          break;
      }
    }
    return containers;
  }

  /// convert json into blocks
  List<Block> _convertBlock(List<dynamic> blockJSON) {
    List<Block> blocks = [];
    if (blockJSON == null || (blockJSON.length > 0 && blockJSON[0] == null)) {
      return [];
    }
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
          blocks.add(ImageBlock.fromJSON(j, baseURL: baseURL));
          break;
        case BlockTypes.quote:
          blocks.add(QuoteBlock.fromJSON(j));
          blocks.add(NewLineBlock());
          break;
        case BlockTypes.table:
          List<Block> columns = this._convertBlock(j['columns']);
          List rows = (j['rows']).map((e) => this._convertBlock(e)).toList();
          blocks.add(
            TableBlock(
              columns: columns,
              rows: rows.map((e) => e as List<Block>).toList(),
              content: block.content,
            ),
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
        case BlockTypes.countdown:
          blocks.add(CountDownBlock.fromJSON(j));
          break;
        case BlockTypes.listItem:
          Block leading = this._convertBlock([j['leading']]).length > 0
              ? this._convertBlock(j['leading']).first
              : null;
          Block ending = this._convertBlock([j['ending']]).length > 0
              ? this._convertBlock([j['ending']]).first
              : null;
          Block title = this._convertBlock([j['title']]).length > 0
              ? this._convertBlock([j['title']]).first
              : null;
          Block subtitle = this._convertBlock([j['subtitle']]).length > 0
              ? this._convertBlock([j['subtitle']]).first
              : null;
          blocks.add(
            ListItemBlock(
              height: block.height,
              width: block.width,
              leading: leading,
              ending: ending,
              title: title,
              subtitle: subtitle,
            ),
          );
          break;
        case BlockTypes.divider:
          blocks.add(DividerBlock());
          break;
      }
    }

    return blocks;
  }
}
