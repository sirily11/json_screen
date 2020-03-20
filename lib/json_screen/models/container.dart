import 'package:json_screen/json_screen.dart';

enum ContainerTypes { container, horizontal }

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

  toJSON() {
    return {
      "types": types.toString().replaceFirst("ContainerTypes.", ""),
      "blocks": children.map((e) => e.toJSON()).toList()
    };
  }
}

/// Horizontal Carousel Container
class HorizontalCarousel<T extends Block> extends Container {
  HorizontalCarousel({List<T> children, ContainerTypes types})
      : super(children: children, types: types);
}
