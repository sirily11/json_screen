import 'package:json_screen/json_screen/models/container.dart';

enum PageTypes { page }

class Page<T extends Container> {
  PageTypes types = PageTypes.page;

  /// Containers within the page
  List<T> containers = [];

  Page({this.containers, this.types}) {
    if (this.types == null) {
      this.types = PageTypes.page;
    }
  }

  factory Page.fromJSON(Map<String, dynamic> json) {
    PageTypes t = PageTypes.values.firstWhere(
      (element) => element.toString() == "PageTypes." + json['types'],
      orElse: () => null,
    );

    return Page(types: t);
  }

  toJSON() {
    return {
      "types": types.toString().replaceFirst("PageTypes.", ""),
      "containers": containers.map((e) => e.toJSON()).toList()
    };
  }
}
