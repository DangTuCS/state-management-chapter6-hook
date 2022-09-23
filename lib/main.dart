import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

void testId() {
  final values = [1, 2, null, 3];
  final nonNullValues = values.compactMap((_) => 'Hello');
  print(nonNullValues);
}

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

const url =
    'https://cdn.pixabay.com/photo/2022/08/14/21/47/snake-7386684__340.jpg';

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() =>
      NetworkAssetBundle(Uri.parse(url))
          .load(url)
          .then((value) => value.buffer.asUint8List())
          .then((value) => Image.memory(value)),
    );
    print('running');
    final snapshot = useFuture(future);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooks demo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            snapshot.data
          ].compactMap().toList(),
        ),
      ),
    );
  }
}
