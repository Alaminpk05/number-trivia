import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represent an unsigned int',
      () async {
        //arrange
        final str = '123';

        //act
        final result = inputConverter.stringToUnsignedInteger(str);

        //assert
        expect(result, Right(123));

        
      },
    );


    test(
      'should return a Failure when the string is not an integer',
      () async {
        //arrange
        final str = 'a';

        //act
        final result = inputConverter.stringToUnsignedInteger(str);

        //assert
        expect(result, Left(InvalidInputFailure()));


      },
    );

    test(
      'should return a Failure when the string is negetive integer',
      () async {
        //arrange
        final str = '-1234';

        //act
        final result = inputConverter.stringToUnsignedInteger(str);

        //assert
        expect(result, Left(InvalidInputFailure()));


      },
    );
  });
}
