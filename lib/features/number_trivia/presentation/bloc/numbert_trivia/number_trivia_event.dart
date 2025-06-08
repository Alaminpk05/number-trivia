part of 'number_trivia_bloc.dart';

sealed class Getconcre extends Equatable {
  const Getconcre();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends Getconcre {
  final String number;

  const GetTriviaForConcreteNumber( {required this.number});
}

class GetTriviaForRandomNumber extends Getconcre {}
