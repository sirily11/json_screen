import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:json_screen/json_screen/models/converter.dart';

class WidgetProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> key = GlobalKey();
  List<Page> pages = [
    Page(
      types: PageTypes.page,
      containers: [
        c.Container(
          types: c.ContainerTypes.container,
          children: [
            TextBlock(content: "Hello world"),
          ],
        ),
      ],
    )
  ];

  void loadPageFromString(String json) {
    try {
      var parsed = JsonDecoder().convert(json);
      if (parsed is List) {
        var p = JSONConverter(json: parsed).convert();
        this.pages = p;
        key.currentState.showSnackBar(
          SnackBar(
            content: Text("Imported json"),
          ),
        );
        notifyListeners();
      } else {
        key.currentState.showSnackBar(
          SnackBar(
            content: Text("Unable import json"),
          ),
        );
      }
    } catch (err) {
      print(err);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text("Unable import json"),
        ),
      );
    }
  }

  void addPage(Page page) {
    this.pages.add(page);
    notifyListeners();
  }

  void removePage(Page page) {
    this.pages.remove(page);
    notifyListeners();
  }

  void updatePage(Page newPage, Page oldPage) {
    notifyListeners();
  }

  void addContainer(c.Container container, Page page) {
    page.containers.add(container);
    notifyListeners();
  }

  void removeContainer(c.Container container, Page page) {
    page.containers.remove(container);
    notifyListeners();
  }

  void updateContainer(c.Container newContainer, c.Container oldContainer) {
    for (var page in pages) {
      int index = 0;
      for (var container in page.containers) {
        if (container == oldContainer) {
          page.containers[index] = newContainer;
          notifyListeners();
          return;
        }
        index += 1;
      }
    }
  }

  void addBlock(Block block, c.Container container) {
    container.children.add(block);
    notifyListeners();
  }

  void removeBlock(Block block, c.Container container) {
    container.children.remove(block);
    notifyListeners();
  }

  void updateBlock(Block newBlock, Block oldBlock) {
    for (var page in pages) {
      for (var container in page.containers) {
        int index = 0;
        for (var block in container.children) {
          if (block == oldBlock) {
            container.children[index] = newBlock;
            notifyListeners();
            return;
          }
          index += 1;
        }
      }
    }
  }

  void moveBlockUp(Block block) {
    for (var page in pages) {
      for (var container in page.containers) {
        int index = 0;
        for (var b in container.children) {
          if (b == block) {
            if (index == 0) {
              return;
            }
            var tempBlock = container.children[index - 1];
            container.children[index - 1] = block;
            container.children[index] = tempBlock;
            notifyListeners();
            return;
          }
          index += 1;
        }
      }
    }
    notifyListeners();
  }

  void moveBlockDown(Block block) {
    for (var page in pages) {
      for (var container in page.containers) {
        int index = 0;
        for (var b in container.children) {
          if (b == block) {
            if (index == container.children.length - 1) {
              return;
            }
            var tempBlock = container.children[index + 1];
            container.children[index + 1] = block;
            container.children[index] = tempBlock;
            notifyListeners();
            return;
          }
          index += 1;
        }
      }
    }
  }
}
