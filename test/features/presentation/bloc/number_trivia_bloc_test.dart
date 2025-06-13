import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/constant.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/numbert_trivia/number_trivia_bloc.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () {
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    final String tNumberString = '1';
    final int tNumberParsed = 1;
    final NumberTrivia tNumberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );

    void setUpMockInputConverterSuccess() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(
          mockGetConreteNumberTrivia.call(Params(number: tNumberParsed)),
        ).thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [NumberTriviaErrorState] when input is invalid', () {
      // arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));

      // assert later
      expect(bloc.state, equals(NumberTriviaInitial()));
      expectLater(
        bloc.stream,
        emitsInOrder([NumberTriviaErrorState(message: AppConstant.invalidInputMessage)]),
      );

      // act
      bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
    });

    test('should get data from concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConreteNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
      await untilCalled(mockGetConreteNumberTrivia(any));

      // assert
      verify(mockGetConreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading, success] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaSuccessState(trivia: tNumberTrivia),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: AppConstant.serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: AppConstant.serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(number: tNumberString));
      },
    );
  });

  /// RANDOM NUMBER TRIVIA TEST FUNCTIONS
  group('GetTriviaForRandomNumber', () {
    final NumberTrivia tNumberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );

    test('should get data from random use case', () async {
      // arrange

      when(
        mockGetRandomNumberTrivia(NoPrarams()),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoPrarams()));

      // assert
      verify(mockGetRandomNumberTrivia(NoPrarams()));
    });

    test(
      'should emit [Loading, success] when data is gotten successfully',
      () async {
        // arrange

        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaSuccessState(trivia: tNumberTrivia),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetRandomNumberTrivia(NoPrarams()),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: AppConstant.serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange

        when(
          mockGetRandomNumberTrivia(NoPrarams()),
        ).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: AppConstant.serverFailureMessage),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
