import 'dart:convert';

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
      case c.ContainerTypes.form:
        return c.FormContainer(children: container.children);
      case c.ContainerTypes.timeline:
        return c.TimelineContainer.copyWith(children: container.children);
    }
    return c.Container.copyWith(children: container.children);
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
            Text("Container "),
            DropdownButton<c.ContainerTypes>(
              value: container.types,
              onChanged: (v) {
                var newContainer = updateContainer(v);
                provider.updateContainer(newContainer, container);
                print(newContainer.types);
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
            if (container is c.FormContainer)
              Container(
                width: 100,
                child: TextField(
                  onChanged: (v) {
                    double value = double.tryParse(v);
                    if (value != null) {
                      if (container is c.FormContainer) {
                        (container as c.FormContainer).height = value;
                        provider.updateContainer(container, container);
                      }
                    }
                  },
                  decoration: InputDecoration(labelText: "Height"),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ContainerFieldValue extends StatelessWidget {
  final c.FormContainer container;

  ContainerFieldValue({this.container});

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: TextFormField(
                autovalidate: true,
                validator: (v) {
                  if (!v.startsWith("http")) {
                    return "Invaild url";
                  }
                  return null;
                },
                onChanged: (v) {
                  container.url = v;
                  provider.updateContainer(container, container);
                },
                decoration: InputDecoration(labelText: "url"),
              ),
            ),
            Spacer(),
            DropdownButton<String>(
              value: container.method,
              items: ["POST", "PATCH"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (String value) {
                container.method = value;
                provider.updateContainer(container, container);
              },
            )
          ],
        ),
      ),
    );
  }
}

/// This widget is form container only
class ContainerFieldValue2 extends StatelessWidget {
  final c.FormContainer container;

  ContainerFieldValue2({this.container});

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                autovalidate: true,
                onChanged: (v) {
                  try {
                    var json = JsonDecoder().convert(v);
                    if (json is List) {
                      container.schema =
                          json.map((e) => e as Map<String, dynamic>).toList();
                      provider.updateContainer(container, container);
                    }
                  } catch (err) {
                    print(err);
                  }
                },
                validator: (v) {
                  if (v.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
                maxLines: 10,
                decoration: InputDecoration(labelText: "Schema"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
