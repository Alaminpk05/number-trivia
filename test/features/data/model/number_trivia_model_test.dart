import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';

import '../../../fixtures/fixture_reader.dart';







void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");
  test('Should be a subclass of NumberTrivia enity', () async {
    expect(tNumberTriviaModel, isA<NumberTriviaModel>());
  });

  group('from josn', () {
    test(
      'should return a valid model when the JSON number is an integer',

      () async {
        //arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia.json'),
        );

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
 group('toJson', () {
  test(
    'should return a JSON map containing the proper data',
    () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedJsonMap);
    },
  );
});
}
