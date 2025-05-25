import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  /// Deserialize from JSON
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'] as String,
      number: (json['number'] as num).toInt(),
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
