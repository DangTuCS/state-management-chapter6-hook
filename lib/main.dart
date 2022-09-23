import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

extension Normalize on num {
  num normalized(
    num selfRangeMin,
    num selfRangeMax, [
    num normalizedRangeMin = 0.0,
    num normalizedRangeMax = 1.0,
  ]) =>
      (normalizedRangeMax - normalizedRangeMin) *
          ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) +
      normalizedRangeMin;
}

const imageUrl =
    'https://cdn.pixabay.com/photo/2016/11/06/19/42/cat-1803904__340.jpg';
const imageHeight = 300.0;

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController(
      duration: const Duration(seconds: 1),
      initialValue: 1.0,
      upperBound: 1.0,
      lowerBound: 0.0,
    );

    final size = useAnimationController(
      duration: const Duration(seconds: 1),
      initialValue: 1.0,
      upperBound: 1.0,
      lowerBound: 0.0,
    );

    final controller = useScrollController();
    useEffect(() {
      controller.addListener(() {
        final newOpacity = max(imageHeight - controller.offset, 0.0);
        final normalized = newOpacity.normalized(0.0, imageHeight).toDouble();
        opacity.value = normalized;
        size.value = normalized;
      });
      return null;
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks demo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizeTransition(
              sizeFactor: size,
              axis: Axis.vertical,
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: opacity,
                child: Image.network(
                  imageUrl,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: 100,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    'Person $index',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
