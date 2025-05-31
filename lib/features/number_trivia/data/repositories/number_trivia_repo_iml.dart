import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/plateform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepoIml implements NumberTriviaRepository {
  late NumberTriviaRemoteDatasource remoteDatasource;
  late NumberTriviaLocalDataSource localDataSource;
  late NetworkInfo networkInfo;

  NumberTriviaRepoIml({
    required this.remoteDatasource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    networkInfo.isConnectivity;
    final remoteTrivia = await remoteDatasource.getConcreteNumberTrivia(number);
    localDataSource.cacheNumberTrivia(remoteTrivia);
    return Right(remoteTrivia);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return Right(NumberTrivia(text: 'Test', number: 1));
  }
}
