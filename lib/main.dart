import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const AnimatedContainerExampleApp());

class AnimatedContainerExampleApp extends StatelessWidget {
  const AnimatedContainerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: ListView(children: const [
          ImplicitExample(),
          SizedBox(
            height: 40,
          ),
          AnimatedWidgetExample(),
          SizedBox(
            height: 100,
          ),
          AnimatedFooExample(),
          SizedBox(
            height: 100,
          ),
          TweenSequenceExample(),
          SizedBox(
            height: 40,
          ),
        ]),
      ),
    );
  }
}

class ImplicitExample extends StatefulWidget {
  const ImplicitExample({super.key});

  @override
  State<ImplicitExample> createState() => _ImplicitExampleState();
}

class _ImplicitExampleState extends State<ImplicitExample> {
  bool selected = false;
  double opacity = 1.0;
  double rotation = 0;
  double iconSize = 48.0;
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              opacity = opacity == 1 ? 0.2 : 1;
            });
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: opacity,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              rotation += 0.5;
            });
          },
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.elasticOut,
            turns: rotation,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            _isMoved = !_isMoved;
          },
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                left: _isMoved ? 200.0 : 50.0,
                top: _isMoved ? 200.0 : 50.0,
                child: FlutterLogo(size: 100),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = !selected;
                });
              },
              child: AnimatedContainer(
                width: selected ? 200.0 : 100.0,
                height: selected ? 100.0 : 200.0,
                color: selected ? Colors.orange : Colors.black,
                alignment: selected ? Alignment.center : AlignmentDirectional.topCenter,
                duration: const Duration(seconds: 2),
                curve: Curves.linear,
                child: const FlutterLogo(size: 75),
              ),
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: iconSize),
          duration: const Duration(seconds: 1),
          curve: Curves.bounceOut,
          builder: (BuildContext context, double size, Widget? child) {
            return SizedBox(
              height: 100,
              child: IconButton(
                iconSize: size,
                color: Colors.amber,
                icon: child!,
                onPressed: () {
                  setState(() {
                    iconSize = iconSize == 48.0 ? 96.0 : 48.0;
                  });
                },
              ),
            );
          },
          child: const Icon(Icons.account_balance_outlined),
        ),
      ],
    );
  }
}

class AnimatedWidgetExample extends StatefulWidget {
  const AnimatedWidgetExample({super.key});

  @override
  State<AnimatedWidgetExample> createState() => _AnimatedWidgetExampleState();
}

class _AnimatedWidgetExampleState extends State<AnimatedWidgetExample> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _controller.isAnimating ? _controller.stop() : _controller.repeat();
        },
        child: SpinningContainer(controller: _controller));
  }
}

class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({
    super.key,
    required AnimationController controller,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 2.0 * pi,
      child: const Icon(
        Icons.accessibility_outlined,
        size: 100,
      ),
    );
  }
}

class AnimatedFooExample extends StatefulWidget {
  const AnimatedFooExample({super.key});

  @override
  State<AnimatedFooExample> createState() => _AnimatedFooExampleState();
}

class _AnimatedFooExampleState extends State<AnimatedFooExample> with TickerProviderStateMixin {
  late final AnimationController _controllerFirst = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final AnimationController _controllerSecond = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  );
  late Animation<double> radiusAnimation = Tween<double>(
    begin: 100,
    end: 40,
  ).animate(
    CurvedAnimation(
      parent: _controllerFirst,
      curve: const Interval(
        0.0,
        0.8,
        curve: Curves.elasticOut,
      ),
    ),
  );
  late Animation<Color?> colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
    CurvedAnimation(
      parent: _controllerFirst,
      curve: const Interval(
        0.1,
        1.0,
        curve: Curves.easeIn,
      ),
    ),
  );

  @override
  void dispose() {
    _controllerFirst.dispose();
    _controllerSecond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controllerFirst,
      child: Center(
        child: IconButton(
          onPressed: () {
            _controllerFirst.isCompleted ? _controllerFirst.reverse() : _controllerFirst.forward();
          },
          icon: const Icon(Icons.add),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: CirclePainter(
            radius: radiusAnimation.value,
            color: colorAnimation.value,
          ),
          child: child,
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({required this.radius, required this.color});

  final double radius;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: <Color>[
          Colors.transparent,
          color ?? Colors.blue,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
    final Paint paintHoop = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, paintHoop);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class TweenSequenceExample extends StatefulWidget {
  const TweenSequenceExample({super.key});

  @override
  State<TweenSequenceExample> createState() => _TweenSequenceExampleState();
}

class _TweenSequenceExampleState extends State<TweenSequenceExample> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  final Tween<double> firstTween = Tween<double>(
    begin: 0,
    end: 0,
  );
  final Tween<double> secondTween = Tween<double>(
    begin: 0,
    end: -20,
  );
  final Tween<double> thirdTween = Tween<double>(
    begin: -20,
    end: 20,
  );
  final Tween<double> fourthTween = Tween<double>(
    begin: 20,
    end: 0,
  );
  final Tween<double> fivesTween = Tween<double>(
    begin: 0,
    end: 0,
  );
  final Tween<double> sixesTween = Tween<double>(
    begin: 0,
    end: 0,
  );

  late final TweenSequence<double> yTweenSequence = TweenSequence([
    TweenSequenceItem<double>(tween: firstTween, weight: 1),
    TweenSequenceItem<double>(tween: secondTween, weight: 1),
    TweenSequenceItem<double>(tween: thirdTween, weight: 1),
    TweenSequenceItem<double>(tween: fourthTween, weight: 1),
    TweenSequenceItem<double>(tween: fivesTween, weight: 1),
  ]);
  late final Animation<double> yAnimation = yTweenSequence.animate(_controller);
  late Animation<Color?> colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.1,
        1.0,
        curve: Curves.easeIn,
      ),
    ),
  );

  late final Animation<double> xAnimation = TweenSequence([
    TweenSequenceItem(
        tween: Tween<double>(
          begin: -50,
          end: 50,
        ),
        weight: 4),
    TweenSequenceItem(
        tween: Tween<double>(
          begin: 50,
          end: -50,
        ),
        weight: 1),
  ]).animate(
    _controller,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColoredBox(
        color: Colors.amber,
        child: SizedBox(
          height: 150,
          width: 150,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: BallPainter(xProgress: xAnimation.value, yProgress: yAnimation.value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double xProgress;
  final double yProgress;

  BallPainter({required this.xProgress, required this.yProgress});

  final Paint _paint = Paint()
    ..color = Colors.greenAccent
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2 + xProgress, size.height / 2 + yProgress);
    canvas.drawCircle(center, 10, _paint);
  }

  @override
  bool shouldRepaint(BallPainter oldDelegate) {
    return true;
  }
}
