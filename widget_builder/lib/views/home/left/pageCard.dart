import 'package:flutter/material.dart' hide Page;
import 'package:json_screen/json_screen.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/home/left/ContainerCard.dart';
import 'package:widget_builder/views/home/popup/popupDialog.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;

class PageCardList extends StatelessWidget {
  final List<Page> pages;

  PageCardList({@required this.pages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: pages.length,
        itemBuilder: (c, i) {
          if (i >= pages.length) {
            return IconButton(
              tooltip: "Add page",
              onPressed: () {},
              icon: Icon(Icons.add),
            );
          }
          return PageCard(
            page: pages[i],
            index: i,
          );
        });
  }
}

class PageCard extends StatelessWidget {
  final Page page;
  final int index;

  PageCard({@required this.page, this.index});

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Page $index",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 24),
                ),
                PopupMenuButton<int>(
                  onSelected: (v) {
                    if (v == 0) {
                      showDialog(
                        context: context,
                        builder: (c) => ContainerSelector(
                          title: "Add block to container",
                          containers: page.containers,
                          select: (container) {
                            provider.addBlock(
                              TextBlock(content: "New Text"),
                              container,
                            );
                          },
                        ),
                      );
                    } else if (v == 1) {
                      provider.addContainer(
                        c.Container(
                          children: [],
                          types: c.ContainerTypes.container,
                        ),
                        page,
                      );
                    } else if (v == 2) {
                      provider.addPage(Page(containers: []));
                    } else if (v == 3) {
                      provider.removePage(page);
                    } else if (v == 4) {
                      showDialog(
                        context: context,
                        builder: (c) => ContainerSelector(
                          title: "Delete container",
                          containers: page.containers,
                          select: (container) {
                            provider.removeContainer(container, page);
                          },
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (c) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text("Add Block"),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text("Add Container"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Add Page"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text("Delete Page"),
                      ),
                      PopupMenuItem(
                        value: 4,
                        child: Text("Delete Container"),
                      )
                    ];
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ExpansionTile(
              title: Text("Containers"),
              children: <Widget>[
                ContainerCardList(containers: page.containers)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
