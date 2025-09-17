import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Stateless vs Stateful",
      home: Scaffold(
        appBar: AppBar(title: const Text("Stateless & Stateful")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyStatelessText(), // değişmez
              SizedBox(height: 20),
              MyStatefulCounter(), // değişebilir
            ],
          ),
        ),
      ),
    );
  }
}

// 1) STATLESS WIDGET
class MyStatelessText extends StatelessWidget {
  const MyStatelessText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.teal,
      child: const Text(
        "Stateless, Sabit olan 🙂",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

// 2) STATEFUL WIDGET
class MyStatefulCounter extends StatefulWidget {
  const MyStatefulCounter({super.key});

  @override
  State<MyStatefulCounter> createState() => _MyStatefulCounterState();
}

class _MyStatefulCounterState extends State<MyStatefulCounter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.redAccent,
      child: Column(
        children: [
          Text(
            "Duruma Göre değişken🙂‍↔️ $_count",
            style: const TextStyle(fontSize: 18),
          ),
          ElevatedButton(onPressed: _increment, child: const Text("Artır")),
        ],
      ),
    );
  }
}
