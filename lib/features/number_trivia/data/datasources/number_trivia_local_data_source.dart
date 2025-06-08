import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}



const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String? jsonString = sharedPreferences.getString(cachedNumberTrivia);

    if (jsonString != null) {
      return Future.value(
        NumberTriviaModel.fromJson(jsonDecode(jsonString)),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
   return await sharedPreferences.setString(cachedNumberTrivia, jsonEncode(triviaToCache.toJson()));
  }
}
