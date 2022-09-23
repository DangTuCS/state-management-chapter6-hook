import 'dart:async';
import 'dart:core';

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

const imageUrl =
    'https://cdn.pixabay.com/photo/2016/11/06/19/42/cat-1803904__340.jpg';

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(onListen: () {
      controller.sink.add(0.0);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks demo'),
      ),
      body: SafeArea(
        child: StreamBuilder<double>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final rotation = snapshot.data ?? 0.0;
              return GestureDetector(
                onTap: () {
                  controller.sink.add(rotation + 10.0);
                },
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(rotation / 360.0),
                  child: Center(
                    child: Image.network(imageUrl),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
