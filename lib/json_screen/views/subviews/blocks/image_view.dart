import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class ImageView extends StatelessWidget {
  final ImageBlock block;
  final OnImageTap onImageTap;

  ImageView({this.block, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    String imageURL = "${block.data ?? ""}";

    if (block.data != null && !block.data.startsWith("http")) {
      imageURL = "${block.baseURL ?? ""}${block.data ?? ""}";
    }
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () async {
              if (onImageTap != null) {
                await onImageTap(
                  block.data,
                );
              }
            },
            child: Image.network(
              imageURL,
              height: block.height,
              width: block.width,
            ),
          ),
        ),
        if (block.content != null && block.content != "")
          Text("${block.content}"),
        if (block.content != null && block.content != "")
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(),
          ),
      ],
    );
  }
}
