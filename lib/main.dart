import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double turns = 0.0;

  List<Widget> croissantList = [];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _getTapPosition(TapDownDetails details) async {
    final tapPosition = details.globalPosition;
    setState(() {
      croissantList.add(Croissant(tapPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return GestureDetector(
        onTapDown: (details) {
          _getTapPosition(details);
          print("X: " +
              details.globalPosition.dx.toString() +
              "\nY: " +
              details.globalPosition.dy.toString());
          _incrementCounter();
        },
        onTapUp: (details) => setState(() {}),
        child: Scaffold(
          body: Stack(
              children: _counter <= 0
                  ? [
                      Center(
                          child: Text("Tap to croissant.", textScaleFactor: 2))
                    ]
                  : croissantList),
        ));
  }
}

class Croissant extends StatelessWidget {
  Offset? tapPosition;

  Croissant(this.tapPosition, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double startRotation = Random().nextInt(100).toDouble();
    double startHeight = Random().nextInt(100).toDouble();
    double startWidth = Random().nextInt(60).toDouble();

    return Positioned(
      left: tapPosition!.dx - 100,
      top: tapPosition!.dy - 60,
      child: PlayAnimationBuilder(
          curve: Curves.decelerate,
          tween: Tween(begin: 100 * pi, end: 1* pi),
          duration: const Duration(milliseconds: 500), // 0° to 360° (2π)
          builder: (context, zoom, _) {
          return PlayAnimationBuilder<double>(
            curve: Curves.decelerate,
            tween: Tween(begin: 1.5 * pi, end: 2 * pi), // 0° to 360° (2π)
            duration: const Duration(milliseconds: 500),
            builder: (context, spin, _) {
              return Transform.rotate(
                  angle: startRotation + spin,
                  child: SizedBox(
                      height: startHeight + 120 + zoom,
                      width: startWidth + 160 + zoom,
                      child: Image.asset("assets/croissant.png")));
            },
          );
        }
      ),
    );
  }
}
