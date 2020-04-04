import 'package:flutter_test/flutter_test.dart';
import 'package:json_screen/json_screen.dart';

void main() {
  group("Test block from xml to json then back", () {
    var countDownBlock =
        '''<page><container> <countdown data="">Count down</countdown></container></page>
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
  });
}
