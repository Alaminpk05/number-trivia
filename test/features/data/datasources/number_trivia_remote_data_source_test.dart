import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClien;

  setUp(() {
    mockHttpClien = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClien);
  });

  void setUpMockHttpClientSuccess200() {
    when(
      mockHttpClien.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      mockHttpClien.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')),
    );

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint with application/json hear''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        await dataSource.getConcreteNumberTrivia(tNumber);

        //assert
        verify(
          mockHttpClien.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should return NumberTrivia when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throws ServerException when the response is 404 or others',
      () async {
        //arrange
        setUpMockHttpClientFailure404();

        //act
        final call = dataSource.getConcreteNumberTrivia;

        //assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });


  /// RANDOM NUMBER TRIVIA TEST FUNCTIONS
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')),
    );

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint with application/json hear''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();

        //act
        await dataSource.getRandomNumberTrivia();

        //assert
        verify(
          mockHttpClien.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should return NumberTrivia when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throws ServerException when the response is 404 or others',
      () async {
        //arrange
        setUpMockHttpClientFailure404();

        //act
        final call = dataSource.getRandomNumberTrivia;

        //assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
