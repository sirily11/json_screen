import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;

typedef void OnContainerSelect(c.Container container);

class ContainerSelector extends StatefulWidget {
  final String title;
  final OnContainerSelect select;
  final List<c.Container> containers;

  ContainerSelector({this.title, this.select, @required this.containers});

  @override
  _ContainerSelectorState createState() => _ContainerSelectorState();
}

class _ContainerSelectorState extends State<ContainerSelector> {
  c.Container selected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        width: 400,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.containers.length,
            itemBuilder: (context, i) {
              return RadioListTile<c.Container>(
                title: Text(widget.containers[i].types.toString()),
                onChanged: (v) {
                  setState(() {
                    selected = v;
                  });
                },
                groupValue: selected,
                value: widget.containers[i],
              );
            }),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("ok"),
          onPressed: () {
            if (widget.select != null) {
              widget.select(selected);
            }
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
