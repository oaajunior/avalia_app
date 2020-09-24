import 'package:flutter/material.dart';

class CheckBoxAnimation extends AnimatedWidget {
  final Widget child;
  final String keyValue;
  CheckBoxAnimation({AnimationController controller, this.child, this.keyValue})
      : super(
            listenable: Tween<double>(begin: 0, end: 1.0).animate(controller));

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Opacity(
      opacity: animation.value,
      key: Key(keyValue),
      child: child,
    );
  }
}
