import 'package:flutter_test/flutter_test.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/container.dart';
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
      expect(page[0].containers[0].children.length, 3);
      expect(page[0].containers[0].children[0].types, BlockTypes.header);
      expect(page[0].containers[0].children[0].content, "Hello");
    });
  });

  group("Test list parsing", () {
    var xml = '''<?xml version="1.0"?>
  <page> 
    <container>
      <list>
        <text>list 1</text>
        <text>list 2</text>
        <link>link 3</link>
      </list>
    </container>
  </page>
  ''';
    test("Parse xml", () {
      var page = XMLConverter(xml: xml).convert();
      expect(page.length, 1);
      expect(page[0].containers.length, 1);
      expect(page[0].containers[0].children.length, 1);
      expect(page[0].containers[0].children[0].types, BlockTypes.list);
      List<Block> listElement =
          (page[0].containers[0].children[0] as ListBlock).children;
      expect(listElement.length, 3);
    });
  });

  group("Test list parsing", () {
    var xml = '''<?xml version="1.0"?>
  <page> 
    <container>
     <table>
    <column>
        <text>col 1</text>
        <text>col 2</text>
    </column>
    <row>
        <text>1</text>
        <text>2</text>
    </row>
    <row>
        <text>1</text>
        <text>2</text>
    </row>
    <row>
        <text>1</text>
        <text>2</text>
    </row>
</table>
    </container>
  </page>
  ''';

    var listContainerXML = '''<page>
    <list-container>
        <list-item>
            <list-leading>
                <text>hello</text>
            </list-leading>
            <list-ending>
                <text>hello</text>
            </list-ending>
            <list-title>
                <text>hello</text>
            </list-title>
            <list-subtitle>
                <text>hello</text>
            </list-subtitle>
        </list-item>
    </list-container>
</page>
  ''';
    test("Parse xml", () {
      var page = XMLConverter(xml: xml).convert();
      expect(page.length, 1);
      expect(page[0].containers.length, 1);
      expect(page[0].containers[0].children.length, 1);
      expect(page[0].containers[0].children[0].types, BlockTypes.table);
      TableBlock tableBlock = page[0].containers[0].children[0];
      expect(tableBlock.columns.length, 2);
      expect(tableBlock.rows.length, 3);
    });

    test("Parse list container", () {
      var page = XMLConverter(xml: listContainerXML).convert();
      ListViewContainer listContainer = page[0].containers[0];
      expect(page.length, 1);
      expect(listContainer.types, ContainerTypes.list);
      expect(listContainer.children.length, 1);
      expect(listContainer.children[0].leading.content, "hello");
      expect(listContainer.children[0].ending.content, "hello");
      expect(listContainer.children[0].title.content, "hello");
      expect(listContainer.children[0].subtitle.content, "hello");
    });

    test("Parse list container 2", () {
      var xml = '''<page>
    <list-container>
        <list-item>
            <list-title>
                <text>hello</text>
            </list-title>
            <list-subtitle>
                <text>hello</text>
            </list-subtitle>
        </list-item>
    </list-container>
</page>
  ''';
      var page = XMLConverter(xml: xml).convert();
      ListViewContainer listContainer = page[0].containers[0];
      expect(listContainer.children[0].leading, null);
      expect(listContainer.children[0].ending, null);
      expect(listContainer.children[0].title.content, "hello");
      expect(listContainer.children[0].subtitle.content, "hello");
    });

    test("Parse list container 3", () {
      var xml = '''<page>
    <list-container>
        <list-item>
            <list-title>
            </list-title>
        </list-item>
    </list-container>
</page>
  ''';
      var page = XMLConverter(xml: xml).convert();
      ListViewContainer listContainer = page[0].containers[0];
      expect(listContainer.children[0].title, null);
    });
  });
}
