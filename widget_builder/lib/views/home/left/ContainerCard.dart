import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/editpanels/container/containerEditPanel.dart';
import 'package:widget_builder/views/home/left/BlockCard.dart';

class ContainerCardList extends StatelessWidget {
  final List<c.Container> containers;

  ContainerCardList({@required this.containers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: containers.length,
      itemBuilder: (c, i) {
        return ContainerCard(
          container: containers[i],
          index: i,
        );
      },
    );
  }
}

class ContainerCard extends StatelessWidget {
  final c.Container container;

  final int index;

  ContainerCard({this.container, this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> w = container.children
        .map<Widget>(
          (e) => BlockCard(
            block: e,
            container: container,
          ),
        )
        .toList();

    List<Widget> widgets = [
      ContainerEditPanel(
        container: container,
      ),
      ...w
    ];

    return ExpansionTile(
      title: Text(container.types.toString()),
      children: widgets.toList(),
    );
  }
}
