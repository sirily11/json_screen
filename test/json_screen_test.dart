import 'package:flutter_test/flutter_test.dart';

import 'package:json_screen/json_screen.dart';

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
}
