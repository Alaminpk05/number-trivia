import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/plateform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repo_iml.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'number_trivia_repository_imp_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDatasource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepoIml repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNumberTriviaLocalDataSource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockLocalDatasource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepoIml(
      remoteDatasource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
      when(
        mockRemoteDatasource.getConcreteNumberTrivia(any),
      ).thenAnswer((_) async => tNumberTriviaModel);

      // act
      await repository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockNetworkInfo.isConnectivity);
    });

    test(
      'should return remote data when call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
        when(
          mockRemoteDatasource.getConcreteNumberTrivia(tNumber),
        ).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      },
    );
    test(
      'should cache the data locallly  when call to remote data source is successful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
        when(
          mockRemoteDatasource.getConcreteNumberTrivia(tNumber),
        ).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      },
    );
  });
}
