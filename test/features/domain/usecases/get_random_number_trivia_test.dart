import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'number_trivia_test.mocks.dart';





 @GenerateMocks([NumberTriviaRepository]) 
  void main() {
    late GetRandomNumberTrivia usecase;
    late MockNumberTriviaRepository mockNumberTriviaRepository;

    setUp(() {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
    });

    final testNumberTivia = NumberTrivia(text: 'test', number: 5);

    test('Should get trivia from the repository',
    () async {

      // ARRANGE
      when(
        mockNumberTriviaRepository.getRandomNumberTrivia(),
      ).thenAnswer((_) async => Right(testNumberTivia));

      //ACT
      final result = await usecase(NoPrarams());

      //ASSERT
      expect(result, Right(testNumberTivia));
      
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      
      verifyNoMoreInteractions(mockNumberTriviaRepository);

    });
  }

