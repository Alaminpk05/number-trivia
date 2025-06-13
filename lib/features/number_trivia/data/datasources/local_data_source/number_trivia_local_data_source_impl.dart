
import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/utils/constant.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/local_data_source/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String? jsonString = sharedPreferences.getString(AppConstant.cachNumberTrivia);

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
   return await sharedPreferences.setString(AppConstant.cachNumberTrivia, jsonEncode(triviaToCache.toJson()));
  }
}
