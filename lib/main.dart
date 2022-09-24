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
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks demo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => store.dispatch(Action.rotateLeft),
                    child: Text('Rotate Left'),
                  ),
                  ElevatedButton(
                    onPressed: () => store.dispatch(Action.rotateRight),
                    child: Text('Rotate Right'),
                  ),
                  ElevatedButton(
                    onPressed: () => store.dispatch(Action.moreVisible),
                    child: Text('Increase Opacity'),
                  ),
                  ElevatedButton(
                    onPressed: () => store.dispatch(Action.lessVisible),
                    child: Text('Decrease Opacity'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Opacity(
              opacity: store.state.alpha,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(
                  store.state.rotationDeg / 360.0,
                ),
                child: Center(
                  child: Image.network(imageUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
