import 'dart:convert';
import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';
import 'package:provider/provider.dart';
import 'package:widget_builder/models/widgetsProvider.dart';
import 'package:widget_builder/views/home/left/pageCard.dart';
import 'package:widget_builder/views/home/popup/addItemDialog.dart';
import 'package:menubar/menubar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool useGUI = true;
  String json = "";

  @override
  void initState() {
    super.initState();
    setApplicationMenu(
      [
        Submenu(
          label: "File",
          children: [
            MenuItem(
                label: "Open file and listen",
                onClicked: () async {
                  var result =
                      await showOpenPanel(allowedFileTypes: ["json", "xml"]);
                  if (!result.canceled) {
                    File file = File(result.paths.first);
                    WidgetProvider provider =
                        Provider.of(context, listen: false);
                    bool isJSON = file.path.contains("json");
                    var fileStream = file.watch();
                    var content = await file.readAsString();
                    provider.loadPageFromString(
                      content,
                      types: isJSON ? DataTypes.json : DataTypes.xml,
                    );
                    fileStream.listen((event) async {
                      File newFile = File(event.path);
                      var content = await newFile.readAsString();
                      provider.loadPageFromString(
                        content,
                        isUpdate: true,
                        showSnackbar: false,
                        types: isJSON ? DataTypes.json : DataTypes.xml,
                      );
                    });
                  }
                }),
            MenuItem(
                label: "Save to local",
                onClicked: () async {
                  var result =
                      await showSavePanel(suggestedFileName: "block.json");
                  WidgetProvider provider = Provider.of(context, listen: false);
                  if (!result.canceled) {
                    File file = File(result.paths.first);
                    file.writeAsString(
                      JsonEncoder().convert(
                        provider.pages
                            .map(
                              (e) => e.toJSON(),
                            )
                            .toList(),
                      ),
                    );
                  }
                }),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetProvider provider = Provider.of(context);
    var parsedJSON;

    if (json.isNotEmpty) {
      try {
        parsedJSON = JsonDecoder().convert(json);
        if (parsedJSON is List) {
        } else {
          parsedJSON = null;
        }
      } catch (err) {}
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: provider.key,
        appBar: AppBar(
          title: Text("Widget Builder - Use GUI ($useGUI)"),
          actions: <Widget>[
            Switch(
                value: useGUI,
                onChanged: (v) {
                  setState(() {
                    useGUI = v;
                  });
                }),
            IconButton(
              tooltip: "Input json schema",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => AddItemWidget(
                    title: "Import JSON",
                    maxLines: 10,
                    onTextSubmit: (t) {
                      provider.loadPageFromString(t, types: DataTypes.json);
                    },
                  ),
                );
              },
              icon: Icon(Icons.folder_open),
            )
          ],
        ),
        body: Row(
          children: <Widget>[
            if (!useGUI)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: json,
                    onChanged: (v) {
                      setState(() {
                        json = v;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 80,
                  ),
                ),
              ),
            if (useGUI)
              Expanded(
                child: Column(
                  children: <Widget>[
                    TabBar(
                      labelColor: Theme.of(context).textTheme.bodyText2.color,
                      tabs: <Widget>[
                        Tab(
                          child: Text("Builder"),
                        ),
                        Tab(
                          child: Text("JSON output"),
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        Container(
                          height: double.infinity,
                          child: PageCardList(
                            pages: provider.pages,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: double.infinity,
                            child: SelectableText(
                              JsonEncoder.withIndent("  ").convert(
                                provider.pages
                                    .map(
                                      (e) => e.toJSON(),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Theme(
                data: ThemeData(
                  textTheme: Theme.of(context).textTheme.copyWith(
                        bodyText1: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                ),
                child: JsonScreen(
                  onImageTap: (image) async {
                    print(image);
                  },
                  onLinkTap: (link) async {
                    print(link);
                  },
                  pages: useGUI ? provider.pages : null,
                  json: !useGUI ? parsedJSON ?? [] : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
