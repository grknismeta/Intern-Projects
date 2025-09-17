import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RandomButtonPage(),
    );
  }
}

class RandomButtonPage extends StatefulWidget {
  const RandomButtonPage({super.key});

  @override
  State<RandomButtonPage> createState() => _RandomButtonPageState();
}

class count {
  int sayi = 0;
  void arttir() {
    sayi++;
  }

  void azalt() {
    sayi--;
  }
}

class _RandomButtonPageState extends State<RandomButtonPage> {
  double _x = 100;
  double _y = 200;
  final Random _rnd = Random();
  int _counter = 0;
  void _moveButton(Size size) {
    setState(() {
      _x = _rnd.nextDouble() * (size.width - 120);
      _y = _rnd.nextDouble() * (size.height - 120);
      Color.fromARGB(
        255,
        _rnd.nextInt(256),
        _rnd.nextInt(256),
        _rnd.nextInt(256),
      );
      _counter++;
      print("Butona basılma sayısı: $_counter");
    });
  }

  // Rastgele Renk Değişikliği için
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color.fromARGB(25, 25, 25, 255),
              getRandomColor(),
              getRandomColor(),
              getRandomColor(),
              //Color(0xFF6EC6FF), // gökyüzü mavisi
              //Color(0xFF2196F3), // derin mavi
              //Color(0xFF01579B), // deniz gibi
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              //Sayaç Göstergesi
              top: 40,
              right: 20,
              child: Text(
                'Sayaç: $_counter',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Dekoratif ikonlar
            const Positioned(
              top: 50,
              left: 30,
              child: Icon(Icons.bluetooth, size: 48, color: Colors.white),
            ),
            const Positioned(
              top: 120,
              right: 40,
              child: Icon(
                Icons.filter_vintage,
                size: 50,
                color: Colors.pinkAccent,
              ), // çiçek gibi
            ),
            const Positioned(
              bottom: 100,
              left: 20,
              child: Icon(
                Icons.place,
                size: 50,
                color: Colors.redAccent,
              ), // meyve (elma)
            ),
            const Positioned(
              bottom: 180,
              right: 60,
              child: Icon(
                Icons.local_florist,
                size: 50,
                color: Colors.orangeAccent,
              ),
            ),

            // Hareket eden buton
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: _x,
              top: _y,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  elevation: 6,
                  shadowColor: Colors.black54,
                ),
                onPressed: () => _moveButton(size),
                child: const Text("Catch Me If You Can 🎲"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
