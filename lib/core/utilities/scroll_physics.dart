part of core;

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 20,
        damping: 1,
      );
}

class CustomPageScrollPhysics extends ScrollPhysics {
  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics();
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    return CustomSimulation(
      initPosition: position.pixels.ceilToDouble(),
      velocity: velocity,
    );
  }
}

class CustomSimulation extends Simulation {
  CustomSimulation({
    required this.initPosition,
    required this.velocity,
  });

  final double initPosition;
  final double velocity;

  @override
  double x(double time) {
    return math.max(
      math.min(initPosition, 0.0),
      initPosition + velocity * time,
    );
  }

  @override
  double dx(double time) {
    return velocity;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}
