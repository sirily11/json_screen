import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';

class ImageView extends StatelessWidget {
  final ImageBlock block;
  final OnImageTap onImageTap;

  ImageView({this.block, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async{
          if (onImageTap != null) {
            await onImageTap(block.data);
          }
        },
        child: Image.network(block.data));
  }
}
