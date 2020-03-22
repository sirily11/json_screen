import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';

typedef void OnTextSubmit(String submitedValue);
typedef void OnMultiTextSubmit(List<String> submitedValue);

class AddItemWidget extends StatefulWidget {
  final String title;
  final OnTextSubmit onTextSubmit;
  final int maxLines;

  const AddItemWidget({
    this.title,
    this.onTextSubmit,
    this.maxLines = 1,
    Key key,
  }) : super(key: key);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.title}"),
      content: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: widget.maxLines,
          decoration: InputDecoration(labelText: "Content"),
          controller: controller,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("ok"),
          onPressed: () {
            if (widget.onTextSubmit != null) {
              widget.onTextSubmit(controller.text);
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddMultipleItemWidget extends StatefulWidget {
  final String title;
  final OnMultiTextSubmit onTextSubmit;
  final List<String> titles;

  const AddMultipleItemWidget({
    this.title,
    this.onTextSubmit,
    @required this.titles,
    Key key,
  }) : super(key: key);

  @override
  _AddMultipleItemWidgetState createState() => _AddMultipleItemWidgetState();
}

class _AddMultipleItemWidgetState extends State<AddMultipleItemWidget> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    controllers = widget.titles.map((e) => TextEditingController()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.title}"),
      content: Container(
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.titles.length,
          itemBuilder: (c, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controllers[i],
                decoration: InputDecoration(
                    labelText: "${widget.titles[i]}", filled: true),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("ok"),
          onPressed: () {
            if (widget.onTextSubmit != null) {
              widget.onTextSubmit(controllers.map((e) => e.text).toList());
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
