import 'package:flutter/material.dart';
import 'package:how_old/constants.dart';
import 'package:how_old/widgets/date_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appName),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 200,
                child: DateField(labelText: 'Start date'),
              ),
              SizedBox(
                width: 200,
                child: DateField(
                  labelText: 'End date',
                  initialDate: DateTime.now(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
