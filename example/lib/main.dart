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
          onImageTap: (string) {
            print(string);
          },
          onLinkTap: (string) {
            print(string);
          },
          json: [
            {
              "types": "page",
              "containers": [
                {
                  "types": "container",
                  "blocks": [
                    {
                      "types": "header",
                      "level": 3,
                      "content": "This is the header"
                    },
                    {"types": "quote", "content": "Below is the content"},
                    {"types": "text", "content": "hello "},
                    {
                      "types": "link",
                      "content": "world",
                      "data": "https://google.com"
                    },
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {
                      "types": "header",
                      "level": 5,
                      "content": "Also Horizontal Carousel"
                    }
                  ]
                },
                {
                  "types": "horizontal",
                  "blocks": [
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    }
                  ]
                },
                {
                  "types": "container",
                  "blocks": [
                    {"types": "header", "level": 5, "content": "Story Card"}
                  ]
                },
                {
                  "types": "story",
                  "blocks": [
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {
                      "types": "image",
                      "content": "google",
                      "data":
                          "https://www.google.com/logos/doodles/2020/spring-2020-northern-hemisphere-6753651837108323-l.png"
                    },
                    {"types": "text", "content": "hello story"}
                  ]
                }
              ]
            },
            {
              "types": "page",
              "containers": [
                {
                  "types": "container",
                  "blocks": [
                    {
                      "types": "table",
                      "content": "hello table",
                      "columns": [
                        {"types": "text", "content": "hello"},
                        {"types": "text", "content": "hello2"},
                        {"types": "text", "content": "hello3"},
                        {"types": "text", "content": "hello4"},
                        {"types": "text", "content": "hello5"},
                        {"types": "text", "content": "hello6"}
                      ],
                      "rows": [
                        [
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"}
                        ],
                        [
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"},
                          {"types": "text", "content": "abc"}
                        ]
                      ]
                    },
                    {
                      "types": "list",
                      "styles": "unordered",
                      "children": [
                        {"types": "text", "content": "list 1"},
                        {"types": "text", "content": "list 2"},
                        {
                          "types": "list",
                          "styles": "ordered",
                          "children": [
                            {"types": "text", "content": "list 3"},
                            {"types": "text", "content": "list 4"}
                          ]
                        }
                      ]
                    }
                  ]
                },
              ]
            },
            {
              "types": "page",
              "containers": [
                {
                  "types": "form",
                  "height": 200.0,
                  "schema": [
                    {
                      "label": "Item Name",
                      "readonly": false,
                      "extra": {
                        "help": "Please Enter your item name",
                        "default": ""
                      },
                      "name": "name",
                      "widget": "text",
                      "required": true,
                      "translated": false,
                      "validations": {
                        "length": {"maximum": 1024}
                      }
                    }
                  ]
                },
              ]
            }
          ],
        ),
      ),
    );
  }
}
