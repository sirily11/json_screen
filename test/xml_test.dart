import 'package:flutter_test/flutter_test.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/converter.dart';

void main() {
  group("Test basic xml parsing", () {
    var xml = '''<?xml version="1.0"?>
  <page> 
    <container>
      <header level="2">Hello</header>
      <text>Hello</text>
    </container>
  </page>
  ''';
    test("Parse xml", () {
      var page = XMLConverter(xml: xml).convert();
      expect(page.length, 1);
      expect(page[0].containers.length, 1);
      expect(page[0].containers[0].children.length, 2);
      expect(page[0].containers[0].children[0].types, BlockTypes.header);
      expect(page[0].containers[0].children[0].content, "Hello");
    });
  });
}
