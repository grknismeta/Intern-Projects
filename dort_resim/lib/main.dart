import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FourImagesScreen(),
    );
  }
}

class FourImagesScreen extends StatelessWidget {
  const FourImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2, // 2 sütun
        children: const [
          ImageWidget('lib/assets/images/bg1.jpg'),
          ImageWidget('lib/assets/images/bg2.jpg'),
          ImageWidget('lib/assets/images/bg3.jpg'),
          ImageWidget('lib/assets/images/bg4.jpg'),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imagePath;
  const ImageWidget(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}
