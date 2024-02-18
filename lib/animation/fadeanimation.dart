// // Packages you must install ==>  simple_animations: ^4.0.1 || supercharged: ^2.1.1
//
// // ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
//
// import 'package:flutter/material.dart';
// import 'package:supercharged/supercharged.dart';
//
// enum AniProps { opacity, translateY }
//
// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;
//
//   FadeAnimation({required this.delay, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTween<AniProps>()
//       ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
//       ..add(AniProps.translateY, (-30.0).tweenTo(0.0), 500.milliseconds,
//           Curves.easeOut);
//
//     return PlayAnimation<MultiTweenValues<AniProps>>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, child, value) => Opacity(
//         opacity: value.get(AniProps.opacity),
//         child: Transform.translate(
//             offset: Offset(0, value.get(AniProps.translateY)), child: child),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _translationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
      // Optionally, you can set the delay here as well:
      // duration: Duration(milliseconds: (500 * widget.delay).round()),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    _translationAnimation = Tween<Offset>(
      begin: Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    // Optionally, you can add delay to animation
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _translationAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
