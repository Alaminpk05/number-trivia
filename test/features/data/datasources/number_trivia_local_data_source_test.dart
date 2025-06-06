import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
    
  });

  group('gtLastNumberTrivia', () {
    final tNumberTiviaModel = NumberTriviaModel.fromJson(
      jsonDecode( fixture('trivia_cached.json')),
    );

    test(
      'should return NumberTrivia from sharedPreferences when there is one in cache',
      () async {
        //arrange
        when(
          mockSharedPreferences.getString(any),
        ).thenReturn(fixture('trivia_cached.json'));

        //act
        final result = await datasource.getLastNumberTrivia();

        //assert
        verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, equals(tNumberTiviaModel));
      },
    );
  });
}
