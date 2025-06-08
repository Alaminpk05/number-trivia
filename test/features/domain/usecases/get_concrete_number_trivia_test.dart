import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumber = 100;
  final testNumberTivia = NumberTrivia(text: 'test', number: 5);

  test('Should get trivia for the number from the repository', () async {
    // ARRANGE
    when(
      mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber),
    ).thenAnswer((_) async => Right(testNumberTivia));

    //ACT
    final result = await usecase(Params(number: testNumber));

    //ASSERT
    expect(result, Right(testNumberTivia));

    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
