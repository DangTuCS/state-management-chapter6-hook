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

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

@immutable
class State {
  final double rotationDeg;
  final double alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(
        rotationDeg: rotationDeg + 10.0,
        alpha: alpha,
      );

  State rotateLeft() => State(
        rotationDeg: rotationDeg - 10.0,
        alpha: alpha,
      );

  State increaseAlpha() => State(
        rotationDeg: rotationDeg,
        alpha: min(alpha + 0.1, 1.0),
      );

  State decreaseAlpha() => State(
        rotationDeg: rotationDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

const imageUrl =
    'https://cdn.pixabay.com/photo/2016/11/06/19/42/cat-1803904__340.jpg';

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useAppLifecycleState();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks demo'),
      ),
      body: SafeArea(
        child: Opacity(
          opacity: state == AppLifecycleState.resumed ? 1.0 :  0.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withAlpha(100),
                  spreadRadius: 10,
                )
              ],
            ),
            child: Image.asset('assets/visa.webp'),
          ),
        ),
      ),
    );
  }
}
