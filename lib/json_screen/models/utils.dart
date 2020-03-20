import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/page.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/header_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/image_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/link_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/list_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/quote_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/table_view.dart';
import 'package:json_screen/json_screen/views/subviews/blocks/text_view.dart';
import 'package:json_screen/json_screen/models/container.dart' as c;
import 'package:story_view/story_view.dart';

/// render List of blocks
Widget renderBlock(Block block, OnLinkTap onlinkTap, OnImageTap onImageTap) {
  if (block is ImageBlock) {
    return ImageView(
      block: block,
      onImageTap: onImageTap
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
      onLinkTap: onlinkTap,
      onImageTap: onImageTap,
    );
  } else if (block is ListBlock) {
    return ListViewView(
      block: block,
      onLinkTap: onlinkTap,
      onImageTap: onImageTap,
    );
  } else if(block is LinkBlock){
    return LinkView(block: block, onLinkTap: onlinkTap,);
  }
  return Container();
}

/// render page
Widget renderPage(Page page, BuildContext context, OnLinkTap onlinkTap,
    OnImageTap onImageTap) {
  return RichText(
    text: TextSpan(
      children: page.containers.map((e) {
        if (e is c.HorizontalCarousel || e is c.StoryContainer) {
          return WidgetSpan(
            child: renderContainer(e, context, onlinkTap, onImageTap) as Widget,
          );
        }
        return renderContainer(e, context, onlinkTap, onImageTap) as InlineSpan;
      }).toList(),
    ),
  );
}

StoryItem renderStoryBlock(Block block, BuildContext context) {
  if (block is ImageBlock) {
    return StoryItem.inlineImage(
      NetworkImage(block.data, scale: 1),
      caption: Text(block.content),
    );
  }

  return StoryItem.text(block.content, Theme.of(context).primaryColor);
}

/// render container
dynamic renderContainer(c.Container container, BuildContext context,
    OnLinkTap onlinkTap, OnImageTap onImageTap) {
  if (container is c.HorizontalCarousel) {
    return Container(
      key: Key("horizontal"),
      child: CarouselSlider(
        enableInfiniteScroll: false,
        items: container.children
            .map(
              (e) => renderBlock(e, onlinkTap, onImageTap),
            )
            .toList(),
      ),
    );
  } else if (container is c.StoryContainer) {
    return Padding(
      key: Key("story-card"),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: container.height ?? 250,
        width: container.width,
        child: StoryView(
          container.children
              .map(
                (e) => renderStoryBlock(e, context),
              )
              .toList(),
          progressPosition: ProgressPosition.bottom,
          repeat: true,
        ),
      ),
    );
  }
  return TextSpan(
    children: container.children.map((e) {
      if (e is NewLineBlock) {
        return TextSpan(text: "\n");
      }
      return WidgetSpan(
        child: renderBlock(e, onlinkTap, onImageTap),
      );
    }).toList(),
  );
}
