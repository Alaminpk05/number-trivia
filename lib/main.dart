import 'package:flutter/material.dart';
import 'package:number_trivia/dependency_injection.dart';
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
    return MaterialApp(
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
      home: NumberTriviaScreen(),
    );
  }
}
