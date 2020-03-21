import 'package:json_screen/json_screen.dart';

enum ContainerTypes { container, horizontal, story }

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
