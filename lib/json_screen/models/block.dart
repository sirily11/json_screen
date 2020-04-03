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

  /// optional label. Use this for timeline container
  String label;

  /// Type of the block
  BlockTypes types;

  /// Content of the block
  String content;

  Block({this.types, this.content, this.label});

  factory Block.fromJSON(Map<String, dynamic> json) {
    BlockTypes t = BlockTypes.values.firstWhere(
      (element) => element.toString() == "BlockTypes.${json['types']}",
      orElse: () => null,
    );

    return Block(content: json['content'], types: t);
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", ""),
      "label": label
    };
  }
}

class DataBlock extends Block {
  @override
  String label;

  /// Block's data
  String data;

  DataBlock({this.data, String content, this.label})
      : super(content: content, label: label);

  @override
  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", ""),
      "data": data,
      "label": label
    };
  }
}

class TextBlock extends Block {
  @override
  String content;

  final BlockTypes types = BlockTypes.text;

  @override
  String label;

  TextBlock({this.content, this.label}) : super(content: content, label: label);

  factory TextBlock.copyWith({String content, String label}) {
    return TextBlock(content: content, label: label);
  }

  factory TextBlock.fromJSON(Map<String, dynamic> json) {
    if ((json['content'] as String)?.endsWith("\n") ?? false) {
      String content = json['content'];

      return TextBlock(
          content: content.substring(0, content.length - 1),
          label: json['label']);
    }

    return TextBlock(
        content: (json['content'] as String), label: json['label']);
  }
}

class ImageBlock extends DataBlock {
  /// Image content. For example, label of the image
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.image;

  @override
  String label;

  ImageBlock({this.content, String data, this.label})
      : super(content: content, data: data, label: label);

  factory ImageBlock.copyWith({String content, String data, String label}) {
    return ImageBlock(content: content, data: data, label: label);
  }

  factory ImageBlock.fromJSON(Map<String, dynamic> json) {
    return ImageBlock(
        content: json['content'], data: json['data'], label: json['label']);
  }
}

class HeaderBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.header;

  @override
  String label;

  /// Header level. For example header 1
  int level;

  HeaderBlock({this.level = 3, this.content, this.label})
      : super(content: content, label: label);

  factory HeaderBlock.copyWith({String content, String label}) {
    return HeaderBlock(content: content, label: label);
  }

  factory HeaderBlock.fromJSON(Map<String, dynamic> json) {
    return HeaderBlock(
        content: json['content'], level: json['level'], label: json['label']);
  }

  @override
  Map<String, dynamic> toJSON() {
    return {"content": content, "level": level, "label": "label"};
  }
}

class ListBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.list;

  @override
  String label;

  ListStyles styles = ListStyles.unordered;

  List<Block> children = [];

  ListBlock({this.content, this.children, this.styles, this.label})
      : super(content: content, label: label) {
    if (this.children == null) {
      this.children = [];
    }
    if (this.styles == null) {
      this.styles = ListStyles.unordered;
    }
  }

  factory ListBlock.copyWith(
      {String content, ListStyles styles, String label}) {
    return ListBlock(content: content, styles: styles, label: label);
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
      "children": children.map((e) => e.toJSON()).toList(),
      "styles": styles.toString().replaceFirst("ListStyles.", ""),
      "label": label
    };
  }
}

class LinkBlock extends DataBlock {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.link;

  @override
  String label;

  /// Link data
  @override
  String data;

  LinkBlock({this.content, this.data, this.label})
      : super(data: data, content: content, label: label);

  factory LinkBlock.copyWith({String content, String data, String label}) {
    return LinkBlock(content: content, data: data, label: label);
  }

  factory LinkBlock.fromJSON(Map<String, dynamic> json) {
    return LinkBlock(
        content: json['content'], data: json['data'], label: json['label']);
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

  @override
  String label;

  QuoteBlock({String content, this.label})
      : super(content: content, label: label);

  factory QuoteBlock.copyWith({String content, String label}) {
    return QuoteBlock(content: content, label: label);
  }

  factory QuoteBlock.fromJSON(Map<String, dynamic> json) {
    return QuoteBlock(content: json['content'], label: json['label']);
  }
}

class TableBlock extends Block {
  @override
  BlockTypes types = BlockTypes.table;

  @override
  String label;

  /// Header
  List<Block> columns = [];

  /// rows
  List<List<Block>> rows = [];

  TableBlock({String content, this.columns, this.rows, this.label})
      : super(content: content, label: label) {
    if (this.columns == null) {
      this.columns = [];
    }
    if (this.rows == null) {
      this.rows = [];
    }
  }

  factory TableBlock.copyWith({String content, String label}) {
    return TableBlock(content: content, columns: [], rows: [], label: label);
  }

  toJSON() {
    return {
      "content": content,
      "columns": columns.map((e) => e.toJSON()).toList(),
      "rows": rows.map((e) => e.map((el) => el.toJSON()).toList()).toList(),
      "label": label
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
