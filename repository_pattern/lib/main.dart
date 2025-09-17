import 'package:flutter/material.dart';
import 'package:repository_pattern/services/api_services/firebase_service.dart';
import 'app/locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: firebaseService.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data as String);
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}