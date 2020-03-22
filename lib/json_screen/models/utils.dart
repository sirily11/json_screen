import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
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
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

/// render List of blocks
Widget renderBlock(Block block, OnLinkTap onlinkTap, OnImageTap onImageTap) {
  if (block is ImageBlock) {
    return ImageView(block: block, onImageTap: onImageTap);
  } else if (block is NewLineBlock) {
    return TextView(
      block: TextBlock(content: "\n"),
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
  } else if (block is LinkBlock) {
    return LinkView(
      block: block,
      onLinkTap: onlinkTap,
    );
  }
  return Container();
}

/// render page
Widget renderPage(Page page, BuildContext context, OnLinkTap onlinkTap,
    OnImageTap onImageTap) {
  return RichText(
    text: TextSpan(
      children: page.containers.map<InlineSpan>((e) {
        var child = renderContainer(e, context, onlinkTap, onImageTap);
        if (child is Widget) {
          return WidgetSpan(
            child: child,
          );
        }
        return child;
      }).toList(),
    ),
  );
}

StoryItem renderStoryBlock(Block block, BuildContext context) {
  if (block is ImageBlock) {
    return StoryItem.inlineImage(
      NetworkImage(block.data ?? "", scale: 1),
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
    if (container.children.length == 0) {
      return Center(
        child: Text(
          "Blocks required",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
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
  } else if (container is c.FormContainer) {
    if (container.schema == null) {
      return Center(
        child: Text(
          "Schema is required",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    return Container(
      height: container.height,
      child: JSONSchemaForm(
        showSubmitButton: true,
        schema: container.schema,
        onSubmit: (data) async {
          Dio dio = Dio();
          if (container.url != null) {
            switch (container.method) {
              case "POST":
                await dio.post(container.url, data: data);
                break;
              case "PATCH":
                await dio.patch(container.url, data: data);
                break;
            }
          }
        },
      ),
    );
  } else if (container is c.TimelineContainer) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
      child: Timeline(
        position: TimelinePosition.Left,
        children: container.children
            .map(
              (e) => TimelineModel(
                renderBlock(e, (link) => null, (imageSrc) => null),
                leading: Text("${e.label}"),
              ),
            )
            .toList(),
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
