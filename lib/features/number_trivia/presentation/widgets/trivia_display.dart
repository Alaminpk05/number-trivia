import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/core/utils/snackbar.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/numbert_trivia/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/loading_indicator.dart';

class TriviaMessage extends StatelessWidget {
  const TriviaMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: BlocConsumer<NumberTriviaBloc, NumberTriviaState>(
        listener: (context, state) {
          if (state is NumberTriviaErrorState) {
            showCustomSnackBar(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is NumberTriviaLoadingState) {
            return CircularProgressIndicatorWidget();
          } else if (state is NumberTriviaSuccessState) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state.trivia.number.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                
                    SizedBox(height: 10),
                
                    Text(state.trivia.text, style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            );
          }
          return Text('Start Searching', style: TextStyle(fontSize: 20),);
        },
      ),
    );
  }
}