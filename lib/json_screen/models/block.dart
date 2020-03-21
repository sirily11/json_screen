import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/converter.dart';

enum BlockTypes {
  text,

  /// Image component
  image,

  /// block quote
  quote,

  /// table
  table,

  /// list of contents
  list,

  /// header
  header,

  /// link component
  link,

  web,

  newline
}

enum ListStyles { unordered, ordered }

class Block {
  String id = DateTime.now().toIso8601String();

  /// Type of the block
  BlockTypes types;

  /// Content of the block
  String content;

  Block({this.types, this.content});

  factory Block.fromJSON(Map<String, dynamic> json) {
    BlockTypes t = BlockTypes.values.firstWhere(
      (element) => element.toString() == "BlockTypes." + json['types'],
      orElse: () => null,
    );

    return Block(content: json['content'], types: t);
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", "")
    };
  }
}

class DataBlock extends Block {
  /// Block's data
  String data;

  DataBlock({this.data, String content}) : super(content: content);

  @override
  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", ""),
      "data": data
    };
  }
}

class TextBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.text;

  TextBlock({this.content}) : super(content: content);

  factory TextBlock.copyWith({String content}) {
    return TextBlock(content: content);
  }

  factory TextBlock.fromJSON(Map<String, dynamic> json) {
    if ((json['content'] as String).endsWith("\n")) {
      String content = json['content'];

      return TextBlock(content: content.substring(0, content.length - 1));
    }

    return TextBlock(content: (json['content'] as String));
  }
}

class ImageBlock extends DataBlock {
  /// Image content. For example, label of the image
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.image;

  ImageBlock({this.content, String data}) : super(content: content, data: data);

  factory ImageBlock.copyWith({String content, String data}) {
    return ImageBlock(content: content, data: data);
  }

  factory ImageBlock.fromJSON(Map<String, dynamic> json) {
    return ImageBlock(content: json['content'], data: json['data']);
  }
}

class HeaderBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.header;

  /// Header level. For example header 1
  int level;

  HeaderBlock({this.level = 3, this.content}) : super(content: content);

  factory HeaderBlock.copyWith({String content}) {
    return HeaderBlock(content: content);
  }

  factory HeaderBlock.fromJSON(Map<String, dynamic> json) {
    return HeaderBlock(content: json['content'], level: json['level']);
  }
}

class ListBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.list;

  ListStyles styles = ListStyles.unordered;

  List<Block> children = [];

  ListBlock({this.content, this.children, this.styles})
      : super(content: content) {
    if (this.children == null) {
      this.children = [];
    }
  }

  factory ListBlock.copyWith({String content, ListStyles styles}) {
    return ListBlock(content: content, styles: styles);
  }

  static ListStyles getStyles(Map<String, dynamic> json) {
    ListStyles s = ListStyles.values.firstWhere(
      (element) => element.toString() == "ListStyles." + "${json['styles']}",
      orElse: () => ListStyles.unordered,
    );
    return s;
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", ""),
      "children": children.map((e) => e.toJSON()),
      "styles": styles.toString().replaceFirst("ListStyles.", "")
    };
  }
}

class LinkBlock extends DataBlock {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.link;

  /// Link data
  @override
  String data;

  LinkBlock({this.content, this.data}) : super(data: data, content: content);

  factory LinkBlock.copyWith({String content, String data}) {
    return LinkBlock(content: content, data: data);
  }

  factory LinkBlock.fromJSON(Map<String, dynamic> json) {
    return LinkBlock(content: json['content'], data: json['data']);
  }
}

class NewLineBlock extends Block {
  @override
  BlockTypes types = BlockTypes.newline;
  @override
  String content = "\n";
}

class QuoteBlock extends Block {
  @override
  BlockTypes types = BlockTypes.quote;

  QuoteBlock({String content}) : super(content: content);

  factory QuoteBlock.copyWith({String content}) {
    return QuoteBlock(content: content);
  }

  factory QuoteBlock.fromJSON(Map<String, dynamic> json) {
    return QuoteBlock(content: json['content']);
  }
}

class TableBlock extends Block {
  @override
  BlockTypes types = BlockTypes.table;

  /// Header
  List<Block> columns = [];

  /// rows
  List<List<Block>> rows = [];

  TableBlock({String content, this.columns, this.rows})
      : super(content: content) {
    if (this.columns == null) {
      this.columns = [];
    }
    if (this.rows == null) {
      this.rows = [];
    }
  }

  factory TableBlock.copyWith({String content}) {
    return TableBlock(content: content, columns: [], rows: []);
  }

  toJSON() {
    return {
      "content": content,
      "columns": columns.map((e) => e.toJSON()).toList(),
      "rows": rows.map((e) => e.map((el) => el.toJSON()).toList()).toList()
    };
  }
}

class WebViewBlock extends DataBlock {
  @override
  BlockTypes types = BlockTypes.web;

  WebViewBlock({String content, String data})
      : super(content: content, data: data);

  factory WebViewBlock.fromJSON(Map<String, dynamic> json) {
    return WebViewBlock(content: json['content'], data: json['data']);
  }
}
