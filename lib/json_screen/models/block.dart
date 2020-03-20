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
  link
}

class Block {
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

  HeaderBlock({this.level, this.content}) : super(content: content);

  factory HeaderBlock.fromJSON(Map<String, dynamic> json) {
    return HeaderBlock(content: json['content'], level: json['level']);
  }
}

class ListBlock extends Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.list;

  List<Block> children = [];

  ListBlock({this.content, this.children}) : super(content: content);

  @override
  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "types": types.toString().replaceFirst("BlockTypes.", ""),
      "children": children.map((e) => e.toJSON())
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

  factory LinkBlock.fromJSON(Map<String, dynamic> json) {
    return LinkBlock(content: json['content'], data: json['data']);
  }
}

class NewLineBlock extends TextBlock {
  @override
  String content = "\n";
}

class QuoteBlock extends Block {
  @override
  BlockTypes types = BlockTypes.quote;

  QuoteBlock({String content}) : super(content: content);

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
      : super(content: content);

  toJSON() {
    return {
      "content": content,
      "columns": columns.map((e) => e.toJSON()).toList(),
      "rows": rows.map((e) => e.map((el) => el.toJSON()).toList()).toList()
    };
  }
}
