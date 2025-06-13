class AppConstant {
  //API URL
  static String getCroncreteNumberTriviaUrl = 'http://numbersapi.com';
  static String getRandomNumberTriviaUrl = 'http://numbersapi.com/random';

  // LOCAL STORAGE KEY
  static String cachNumberTrivia = 'CACHE_NUMBER_TRIVIA';

  ///ERROR MESSEGE
  static String serverFailureMessage = 'Server Failure';
  static String cacheFailureMessage = 'Cache Failure';
  static String invalidInputMessage =
      'Invalide Input - the integer must be positive or 0 ';
}
