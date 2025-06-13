import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/utils/constant.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/local_data_source/number_trivia_local_data_source_impl.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';


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
      jsonDecode(fixture('trivia_cached.json')),
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
        verify(mockSharedPreferences.getString(AppConstant.cachNumberTrivia));
        expect(result, equals(tNumberTiviaModel));
      },
    );

    test(
      'should throw a CachedException when there isnot cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        //act
        final call = datasource.getLastNumberTrivia;

        //assert

        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

group('cacheNumberTrivia', () {
  final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);

  test('should call SharedPreferences to cache data', () async {
  // arrange
  final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
  when(mockSharedPreferences.setString(AppConstant.cachNumberTrivia, expectedJsonString))
      .thenAnswer((_) async => true); // <- this line fixes the error

  // act
  await datasource.cacheNumberTrivia(tNumberTriviaModel);

  // assert
  verify(mockSharedPreferences.setString(AppConstant.cachNumberTrivia, expectedJsonString)).called(1);
});

});


}
