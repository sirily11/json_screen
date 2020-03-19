import 'dart:io';

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

abstract class Block {
  /// Type of the block
  BlockTypes types;

  /// Content of the block
  String content;
}

abstract class DataBlock extends Block {
  /// Block's data
  String data;
}

class TextBlock implements Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.text;

  TextBlock({this.content});
}

class ImageBlock implements DataBlock {
  /// Image content. For example, label of the image
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.image;

  /// Image data, image source
  @override
  String data;

  ImageBlock({this.content, this.data});
}

class HeaderBlock implements Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.header;

  /// Header level. For example header 1
  int level;

  HeaderBlock({this.level, this.content});
}

class ListBlock implements Block {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.list;

  List<Block> children = [];

  ListBlock({this.content, this.children});
}

class LinkBlock implements DataBlock {
  @override
  String content;

  @override
  BlockTypes types = BlockTypes.link;

  /// Link data
  @override
  String data;

  LinkBlock({this.content, this.data});
}

class NewLineBlock extends TextBlock {
  @override
  String content = "\n";
}

class QuoteBlock extends TextBlock {
  @override
  BlockTypes types = BlockTypes.quote;

  QuoteBlock({String content}) : super(content: content);
}
