import 'package:json_screen/json_screen/models/container.dart';

enum PageTypes { page, vertical }

class Page<T extends Container> {
  PageTypes types = PageTypes.page;
  /// Containers within the page
  List<T> containers = [];

  Page({this.containers, this.types});

  factory Page.fromJSON(Map<String, dynamic> json) {
    PageTypes t = PageTypes.values.firstWhere(
      (element) => element.toString() == "PageTypes." + json['types'],
      orElse: () => null,
    );

    return Page(types: t);
  }

  toJSON() {
    return {
      "types": types.toString().replaceFirst("pageTypes", ""),
      "containers": containers.map((e) => e.toJSON()).toList()
    };
  }
}

class VerticalPage<T> extends Page {
  PageTypes types = PageTypes.page;

  VerticalPage({List<Container> containers}) : super(containers: containers);

  toJSON() {
    return {
      "types": types.toString().replaceFirst("pageTypes.  ", ""),
      "containers": containers.map((e) => e.toJSON()).toList()
    };
  }
}
