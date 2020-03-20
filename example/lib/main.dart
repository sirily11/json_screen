import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("JSON Screen"),
        ),
        body: JsonScreen(
          json: [
            {"types": "text", "content": "hello\n"},
            {"types": "text", "content": "worlde\n"},
            {
              "types": "image",
              "content": "google",
              "data":
                  "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
            }
          ],
        ),
      ),
    );
  }
}
