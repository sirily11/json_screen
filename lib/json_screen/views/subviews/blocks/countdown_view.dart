import 'package:flutter/material.dart';
import 'package:json_screen/json_screen.dart';
import 'dart:async';

class CountdownView extends StatefulWidget {
  final CountDownBlock block;
  CountdownView({@required this.block});

  @override
  _CountdownViewState createState() => _CountdownViewState();
}

class _CountdownViewState extends State<CountdownView> {
  DateTime now;
  Timer timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<String> getTimeDiff(Duration diff) {
    if (diff.inDays >= 1 || (diff.inMinutes < -60 * 24)) {
      if (widget.block.absolute) {
        return ["${diff.inDays.abs()}", "Days"];
      }
      return ["${diff.inDays}", "Days"];
    }
    if (diff.inHours >= 1 ||
        (diff.inMinutes < -60 && diff.inMinutes > -60 * 24)) {
      if (widget.block.absolute) {
        return ["${diff.inHours.abs()}", "Hours"];
      }
      return ["${diff.inHours}", "Hours"];
    }
    if (diff.inMinutes >= 1 || (diff.inMinutes <= -1 && diff.inMinutes > -60)) {
      if (widget.block.absolute) {
        return ["${diff.inMinutes.abs()}", "Minutes"];
      }
      return ["${diff.inMinutes}", "Minutes"];
    }
    if (widget.block.absolute) {
      return ["${diff.inSeconds.abs()}", "Seconds"];
    }
    return ["${diff.inSeconds}", "Seconds"];
  }

  @override
  Widget build(BuildContext context) {
    try {
      DateTime targetDate = DateTime.parse(widget.block.data);

      return Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: widget.block.content,
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextSpan(
                  text: getTimeDiff(
                    targetDate.difference(now),
                  )[0],
                  style: Theme.of(context).textTheme.headline3,
                ),
                TextSpan(
                  text: getTimeDiff(
                    targetDate.difference(now),
                  )[1],
                  style: Theme.of(context).textTheme.headline5,
                ),
              ]),
            ),
          ),
        ),
      );
    } catch (err) {
      return Text("Cannot parse time");
    }
  }
}
