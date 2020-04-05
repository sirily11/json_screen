import 'package:json_screen/json_screen.dart';

enum ContainerTypes { container, horizontal, story, form, timeline, list }

/// Base Container
class Container<T extends Block> {
  ContainerTypes types = ContainerTypes.container;

  /// Blocks
  List<T> children = [];

  Container({this.children, this.types});

  /// return type of the container
  factory Container.fromJSON(Map<String, dynamic> json) {
    ContainerTypes t = ContainerTypes.values.firstWhere(
      (element) => element.toString() == "ContainerTypes." + json['types'],
      orElse: () => null,
    );
    return Container(types: t);
  }

  factory Container.copyWith({List<T> children}) =>
      Container(children: children, types: ContainerTypes.container);

  toJSON() {
    return {
      "types": types.toString().replaceFirst("ContainerTypes.", ""),
      "blocks": children.map((e) => e.toJSON()).toList()
    };
  }
}

/// Horizontal Carousel Container
class HorizontalCarousel<T extends Block> extends Container {
  ContainerTypes types = ContainerTypes.horizontal;
  HorizontalCarousel({List<T> children, ContainerTypes types})
      : super(children: children, types: types);

  factory HorizontalCarousel.copyWith({List<T> children}) =>
      HorizontalCarousel(children: children);
}

/// Timeline container
class TimelineContainer<T extends Block> extends Container {
  ContainerTypes types = ContainerTypes.timeline;
  TimelineContainer({List<T> children, ContainerTypes types})
      : super(children: children, types: types);

  factory TimelineContainer.copyWith({List<T> children}) =>
      TimelineContainer(children: children);
}

class StoryContainer<T extends Block> extends Container {
  ContainerTypes types = ContainerTypes.story;
  double height;
  double width;
  StoryContainer(
      {List<T> children, ContainerTypes types, this.height = 300, this.width})
      : super(children: children, types: types);

  factory StoryContainer.copyWith({List<T> children}) =>
      StoryContainer(children: children);
}

class ListViewContainer extends Container {
  final ContainerTypes types = ContainerTypes.list;
  final List<ListItemBlock> children;

  ListViewContainer({this.children}) : super(children: children) {
    if (!(children is List<ListItemBlock>)) {
      throw Exception("Children should be list item block");
    }
  }
}

class FormContainer extends Container {
  ContainerTypes types = ContainerTypes.form;
  List<Block> children = [];

  /// JSON Schema for form
  List<dynamic> schema;

  /// submit url
  String url;

  /// Submit method. For example, POST, PATCH
  String method;

  double height;

  double width;

  FormContainer(
      {this.schema,
      this.url,
      this.method,
      this.height = 300.0,
      this.width = 300.0,
      this.children})
      : super(children: children);

  factory FormContainer.fromJSON(Map<String, dynamic> json) => FormContainer(
      method: json['method'],
      url: json['url'],
      schema: json['schema'],
      height: json['height'],
      width: json['width']);

  @override
  toJSON() {
    return {"method": this.method, "url": this.url, "schema": this.schema};
  }
}
