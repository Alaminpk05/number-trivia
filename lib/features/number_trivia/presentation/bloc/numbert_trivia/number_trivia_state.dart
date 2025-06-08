part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

final class NumberTriviaInitial extends NumberTriviaState {}

final class NumberTriviaIEmptyState extends NumberTriviaState {}

final class NumberTriviaLoadingState extends NumberTriviaState {}

final class NumberTriviaSuccessState extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaSuccessState({required this.trivia});
}

final class NumberTriviaErrorState extends NumberTriviaState {
  final String message;

  const NumberTriviaErrorState({required this.message});
}
