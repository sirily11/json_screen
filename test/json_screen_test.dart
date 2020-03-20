import 'package:flutter_test/flutter_test.dart';

import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/converter.dart';

void main() {
  test('init block', () {
    QuoteBlock quoteBlock = QuoteBlock(content: "abc");
    expect(quoteBlock.content, "abc");
    expect(quoteBlock.types, BlockTypes.quote);

    HeaderBlock headerBlock = HeaderBlock(content: "abc", level: 2);
    expect(headerBlock.content, "abc");
    expect(headerBlock.types, BlockTypes.header);
    expect(headerBlock.level, 2);

    ListBlock listBlock =
        ListBlock(content: "abc", children: [headerBlock, quoteBlock]);
    expect(listBlock.content, "abc");
    expect(listBlock.types, BlockTypes.list);
    expect(listBlock.children.length, 2);

    ImageBlock imageBlock = ImageBlock(content: "abc");
    expect(imageBlock.content, "abc");
    expect(imageBlock.types, BlockTypes.image);

    LinkBlock linkBlock = LinkBlock(content: "abc", data: "abcd");
    expect(linkBlock.content, "abc");
    expect(linkBlock.data, "abcd");
    expect(linkBlock.types, BlockTypes.link);
  });

  test("From JSON", () {
    var json = {"types": "image", "content": "hello"};
    Block block = Block.fromJSON(json);
    expect(block.content, "hello");
    expect(block.types, BlockTypes.image);
    expect(block.toJSON()['types'], "image");
  });

  test("From JSON 2", () {
    var json = {"types": "image", "content": "hello"};
  });

  group('Converter test', () {
    List<Map<String, dynamic>> json = [
      {
        "types": "page",
        "containers": [
          {
            "types": "container",
            "blocks": [
              {
                "types": "image",
                "content": "table",
                "data": "http://google.com"
              },
              {"types": "header", "level": 2, "content": "big header"},
              {
                "types": "list",
                "children": [
                  {"types": "text", "content": "hello"},
                  {"types": "text", "content": "hello2"}
                ]
              },
              {
                "types": "image",
                "content": "table",
                "data": "http://google.com"
              }
            ]
          },
        ]
      },
      {
        "types": "page",
        "containers": [
          {
            "types": "container",
            "blocks": [
              {
                "types": "image",
                "content": "table",
                "data": "http://google.com"
              },
              {"types": "header", "level": 2, "content": "big header"},
              {
                "types": "list",
                "children": [
                  {"types": "text", "content": "hello"},
                  {"types": "text", "content": "hello2"}
                ]
              },
              {
                "types": "image",
                "content": "table",
                "data": "http://google.com"
              }
            ]
          },
        ]
      },
    ];

    test("Parse test", () {
      JSONConverter converter = JSONConverter(json: json);
      var pages = converter.convert();
      expect(pages.length, 2);
      expect(pages[0].containers.length, 1);
      expect(pages[0].containers[0].children.length, 4);
    });
  });
}
