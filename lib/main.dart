import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:number_trivia/dependency_injection.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/numbert_trivia/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/screens/number_trivia.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>serviceLocator<NumberTriviaBloc>())
      ],
      child: MaterialApp(
        title: 'Number Trivia',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
            surface: Colors.white,
            primary: Colors.green,
            error: Colors.red,
          ),
          primaryColor: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<NumberTriviaBloc, NumberTriviaState>(
          listener: (context, state) {
            
          },
          builder: (context, state) {
            return NumberTriviaScreen();
          },
        ),
      ),
    );
  }
}
