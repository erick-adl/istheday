import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:istheday/features/date/data/models/date_model.dart';

import 'package:istheday/features/date/domain/entities/date.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tDateModel = DateModel(day: 1, month: 1, text: 'Test Text');

  test(
    'should be a subclass of Date entity',
    () async {
      // assert
      expect(tDateModel, isA<Date>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model ',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = DateModel.fromJson(jsonMap);
        // assert
        expect(result, isA<Date>());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tDateModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "day": 1,
          "month": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
