import 'package:flutter_test/flutter_test.dart';
import 'package:json_screen/json_screen.dart';

void main() {
  group("Test block from xml to json then back", () {
    var countDownBlock =
        '''<page><container> <countdown data="">Count down</countdown></container></page>
    ''';

    var headerBlock =
        '''<page><container> <header level="5">Header</header></container></page>
    ''';

    test("countdown", () {
      var page = XMLConverter(xml: countDownBlock).convert();
      var countdown = page[0].containers[0].children[0];
      expect(countdown.types, BlockTypes.countdown);
      var json = countdown.toJSON();
      var countdownJSONBlock =
          JSONConverter(json: page.map((e) => e.toJSON()).toList()).convert();
      expect(countdownJSONBlock.length, 1);
      expect(countdownJSONBlock[0].containers[0].children[0].types,
          BlockTypes.countdown);
    });

    test("header", () {
      var page = XMLConverter(xml: headerBlock).convert();
      var header = page[0].containers[0].children[0];
      expect(header.types, BlockTypes.header);
      var json = header.toJSON();
      expect(json['types'], "header");
      expect(json['level'], 5);
      var headerJSONBlock =
          JSONConverter(json: page.map((e) => e.toJSON()).toList()).convert();
      expect(headerJSONBlock.length, 1);
      expect(headerJSONBlock[0].containers[0].children[0].types,
          BlockTypes.header);
      expect(headerJSONBlock[0].containers[0].children[0].content, "Header");
    });
  });
}
