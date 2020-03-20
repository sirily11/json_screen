import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/header_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/image_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/quote_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/table_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/text_view.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;

/// render List of blocks
Widget renderBlock(Block block) {
  if (block is ImageBlock) {
    return ImageView(
      block: block,
    );
  } else if (block is TextBlock) {
    return TextView(
      block: block,
    );
  } else if (block is HeaderBlock) {
    return HeaderView(
      block: block,
    );
  } else if (block is QuoteBlock) {
    return QuoteView(
      block: block,
    );
  } else if (block is TableBlock) {
    return TableView(
      tableBlock: block,
    );
  }
  return Container();
}

/// render page
Widget renderPage(Page page) {
  return RichText(
    text: TextSpan(
      children: page.containers.map((e) {
        if (e is c.HorizontalCarousel) {
          return WidgetSpan(
            child: renderContainer(e) as Widget,
          );
        }
        return renderContainer(e) as InlineSpan;
      }).toList(),
    ),
  );
}

/// render container
dynamic renderContainer(c.Container container) {
  if (container is c.HorizontalCarousel) {
    return CarouselSlider(
      enableInfiniteScroll: false,
      items: container.children
          .map(
            (e) => renderBlock(e),
          )
          .toList(),
    );
  }
  return TextSpan(
    children: container.children.map((e) {
      if (e is NewLineBlock) {
        return TextSpan(text: "\n");
      }
      return WidgetSpan(
        child: renderBlock(e),
      );
    }).toList(),
  );
}
