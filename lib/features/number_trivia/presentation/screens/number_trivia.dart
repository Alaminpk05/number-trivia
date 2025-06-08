import 'package:flutter/material.dart';

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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Center(
          child: Column(
            children: [
              Text('18', style: TextStyle(fontSize: 30)),

              Flexible(
                child: Text(
                  '19 is the beginning of directory enquiries numbers in the united kingdom',
                  style: TextStyle(fontSize: 20),
                ),
              ),

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
                    onPressed: () {},
                    title: 'Search',
                    color: Theme.of(context).colorScheme.primary,
                    titleColor: Colors.white,
                  ),

                  NumberTriviaButtonWidget(
                    onPressed: () {},
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

class NumberTriviaButtonWidget extends StatelessWidget {
  const NumberTriviaButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.titleColor,
  });
  final void Function() onPressed;
  final String title;
  final Color? color;
  final Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(),
        ),
        child: Text(title, style: TextStyle(color: titleColor)),
      ),
    );
  }
}
