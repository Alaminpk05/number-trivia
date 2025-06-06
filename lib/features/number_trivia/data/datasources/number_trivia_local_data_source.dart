import 'dart:convert';

import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});



  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String? jsonString = sharedPreferences.getString(
      'CACHED_NUMBER_TRIVIA',
    );

    return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString??'Not Found')));
  
  }

    @override
  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache) async {}
}
