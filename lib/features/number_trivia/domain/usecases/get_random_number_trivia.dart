import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia,NoPrarams> {
    final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);
  
  
  @override
  Future<Either<Failure, NumberTrivia>> call(NoPrarams params) async {
    return await repository.getRandomNumberTrivia();
  }
}


