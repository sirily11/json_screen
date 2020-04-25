import 'package:json_screen/json_screen.dart';

enum ContainerTypes { container, horizontal, story, form, timeline, list }

/// Base Container
class Container<T extends Block> {
  ContainerTypes types = ContainerTypes.container;
  double height;
  double width;
  bool center;

  /// Blocks
  List<T> children = [];

  Container({
    this.children,
    this.types,
    this.height,
    this.width,
    this.center = false,
  });

  /// return type of the container
  factory Container.fromJSON(Map<String, dynamic> json) {
    ContainerTypes t = ContainerTypes.values.firstWhere(
      (element) => element.toString() == "ContainerTypes." + json['types'],
      orElse: () => null,
    );
    return Container(
      types: t,
      height: json['height'],
      width: json['width'],
      center: json['center'] ?? false,
    );
  }

  factory Container.copyWith(
          {List<T> children, bool center, double width, double height}) =>
      Container(
        children: children,
        types: ContainerTypes.container,
        center: center,
        width: width,
        height: height,
      );

  toJSON() {
    return {
      "types": types.toString().replaceFirst("ContainerTypes.", ""),
      "height": height,
      "width": width,
      "center": center,
      "blocks": children.map((e) => e.toJSON()).toList(),
    };
  }
}

/// Horizontal Carousel Container
class HorizontalCarousel<T extends Block> extends Container {
  ContainerTypes types = ContainerTypes.horizontal;
  double height;
  double width;
  HorizontalCarousel(
      {List<T> children, ContainerTypes types, this.width, this.height})
      : super(children: children, types: types, height: height, width: width);

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
