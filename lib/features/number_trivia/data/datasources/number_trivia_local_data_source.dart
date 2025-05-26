import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  
 Future<NumberTriviaModel> getLastNumberTrivia(int number);

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);


}