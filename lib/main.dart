import 'package:flutter/material.dart';
import "package:animations/animations.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationDemoPage(),
    );
  }
}

class AnimationDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          OpenContainer(
            closedBuilder: (context, action) => ElevatedButton(
              onPressed: action,
              child: Text('Container Transform'),
            ),
            openBuilder: (context, action) => ContainerTransformDemo(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SharedAxisTransitionDemo(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                    SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    ),
              ),
            ),
            child: Text('Shared Axis Transition'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    FadeThroughTransitionDemo(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                    FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    ),
              ),
            ),
            child: Text('Fade Through Transition'),
          ),
        ],
      ),
    );
  }
}

class ContainerTransformDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container Transform'),
      ),
      body: Center(
        child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 1000),
          closedBuilder: (context, action) => Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(child: Text('Open')),
          ),
          openBuilder: (context, action) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text('Open Container'),
            ),
            body: Center(child: Text('Opened')),
          ),
        ),
      ),
    );
  }
}

class SharedAxisTransitionDemo extends StatefulWidget {
  @override
  _SharedAxisTransitionDemoState createState() =>
      _SharedAxisTransitionDemoState();
}

class _SharedAxisTransitionDemoState extends State<SharedAxisTransitionDemo> {
  bool _isFirstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Axis Transition'),
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondaryAnimation) =>
            SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
        child: _isFirstPage
            ? FirstPage(
          onNext: () {
            setState(() {
              _isFirstPage = false;
            });
          },
        )
            : SecondPage(
          onBack: () {
            setState(() {
              _isFirstPage = true;
            });
          },
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  final VoidCallback onNext;

  const FirstPage({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onNext,
        child: Text('Next'),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final VoidCallback onBack;

  const SecondPage({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onBack,
        child: Text('Back'),
      ),
    );
  }
}

class FadeThroughTransitionDemo extends StatefulWidget {
  @override
  _FadeThroughTransitionDemoState createState() =>
      _FadeThroughTransitionDemoState();
}

class _FadeThroughTransitionDemoState extends State<FadeThroughTransitionDemo> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fade Through Transition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showFirst = !_showFirst;
                });
              },
              child: Text('Toggle'),
            ),
            SizedBox(height: 20),
            PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  ),
              child: _showFirst ? FirstWidget() : SecondWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('First'),
      color: Colors.blue,
      width: 100,
      height: 100,
      child: Center(child: Text('First')),
    );
  }
}

class SecondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('Second'),
      color: Colors.red,
      width: 100,
      height: 100,
      child: Center(child: Text('Second')),
    );
  }
}
