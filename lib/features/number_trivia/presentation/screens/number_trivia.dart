import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/core/utils/snackbar.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/numbert_trivia/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_button.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';

class NumberTriviaScreen extends StatelessWidget {
  NumberTriviaScreen({super.key});

  final TextEditingController numberController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Center(
          child: Column(
            children: [
              TriviaMessage(),

              SizedBox(height: 20),

              TextFormField(
                key: _formKey,
                controller: numberController,
                decoration: InputDecoration(
                  hintText: 'Enter a number',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberTriviaButtonWidget(
                    onPressed: () {
                      if (numberController.text.isNotEmpty) {
                        context.read<NumberTriviaBloc>().add(
                          GetTriviaForConcreteNumber(
                            number: numberController.text,
                          ),
                        );
                        return;
                      }

                      showCustomSnackBar(
                        context,
                        message: 'Please enter a number',
                      );
                    },
                    title: 'Search',
                    color: Theme.of(context).colorScheme.primary,
                    titleColor: Colors.white,
                  ),

                  NumberTriviaButtonWidget(
                    onPressed: () {
                      context.read<NumberTriviaBloc>().add(
                          GetTriviaForRandomNumber(
                            
                          ),
                        );
                    },
                    title: 'Get random trivia',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





