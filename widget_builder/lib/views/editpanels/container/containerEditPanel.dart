import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';

class ContainerEditPanel extends StatelessWidget {
  final c.Container container;

  ContainerEditPanel({@required this.container});

  c.Container updateContainer(c.ContainerTypes containerTypes) {
    switch (containerTypes) {
      case c.ContainerTypes.container:
        return c.Container.copyWith(children: container.children);
      case c.ContainerTypes.horizontal:
        return c.HorizontalCarousel.copyWith(children: container.children);
      case c.ContainerTypes.story:
        return c.StoryContainer.copyWith(children: container.children);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Container Type"),
            DropdownButton<c.ContainerTypes>(
              value: container.types,
              onChanged: (v) {
                var newContainer = updateContainer(v);
                provider.updateContainer(newContainer, container);
              },
              items: c.ContainerTypes.values
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e.toString()),
                      value: e,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
