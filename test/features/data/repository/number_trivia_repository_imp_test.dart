
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/plateform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/local_data_source/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/remote_data_source/number_trivia_remote_datasource.dart';
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
  late NumberTriviaRepoImpl repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNumberTriviaLocalDataSource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockLocalDatasource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepoImpl(
      remoteDatasource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestsOnline(() {
      test(
        'getConcreteNumberTrivia should check if the device is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
          when(
            mockRemoteDatasource.getConcreteNumberTrivia(any),
          ).thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockNetworkInfo.isConnectivity);
        },
      );

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
          await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when call to remote data source is successful',
        () async {
          // arrange
          // when(mockNetworkInfo.isConnectivity).thenAnswer((_) async => true);
          when(
            mockRemoteDatasource.getConcreteNumberTrivia(any),
          ).thenThrow(ServerException());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(left(ServerFailure())));
        },
      );
    });
    runTestsOffline(() {
      test(
        'should reutrn last locally when the cached data is present ',
        () async {
          //arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should reutrn CachedFailure when there is no cached data present ',
        () async {
          //arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenThrow(CacheException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
