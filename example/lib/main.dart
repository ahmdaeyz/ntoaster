import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ntoaster/ntoaster.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NToasterCenter(
          child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
    final ntoaster = NToaster.of(context);
    NotificationMetaData? notification;
    notification = NotificationMetaData(
      insertionAnimationBuilder: (context, child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      removalAnimationBuilder: (context, child, animation) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: const Offset(0.5, 0))
            .animate(animation),
        child: child,
      ),
      showFor: Duration(
          milliseconds:
              (Random(DateTime.now().millisecondsSinceEpoch).nextDouble() *
                      5000)
                  .toInt()),
      item: GestureDetector(
        onTap: () {
          notification?.remove();
        },
        child: SizedBox(
          height:
              Random(DateTime.now().millisecondsSinceEpoch).nextDouble() * 100 +
                  50,
          width: 300,
          child: Card(
            elevation: 8.0,
            color: Colors.red.withGreen(
                Random(DateTime.now().millisecondsSinceEpoch).nextInt(255)),
            child: Center(
              child: Text(
                "$_counter Cool title",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
    ntoaster.enqueue(
      notification,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
