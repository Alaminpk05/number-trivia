import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/constant.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


class NumberTriviaBloc extends Bloc<Getconcre, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputeither = inputConverter.stringToUnsignedInteger(event.number);
    await inputeither.fold(
      (failure) async {
        emit(NumberTriviaErrorState(message: invalidInputMessage));
      },
      (integer) async {
        emit(NumberTriviaLoadingState());
        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );

        _eitherSuccessOrErrorState(emit, failureOrTrivia);
      },
    );
  }

  void _eitherSuccessOrErrorState(
    Emitter<NumberTriviaState> emit,
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    emit(
      failureOrTrivia.fold(
        (failure) =>
            NumberTriviaErrorState(message: _mapFailureToMessage(failure)),

        (trivia) => NumberTriviaSuccessState(trivia: trivia),
      ),
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoadingState());
    final failureOrTrivia = await getRandomNumberTrivia(NoPrarams());

    emit(
      failureOrTrivia.fold(
        (failure) =>
            NumberTriviaErrorState(message: _mapFailureToMessage(failure)),

        (trivia) => NumberTriviaSuccessState(trivia: trivia),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure():
        return serverFailureMessage;
      case CacheFailure():
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
