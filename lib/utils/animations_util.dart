import 'package:flutter/material.dart';

class AnimationUtils {
  const AnimationUtils._();

  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.8,
    double end = 1.0,
    Curve curve = Curves.elasticOut,
  }) => Tween<double>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  static Animation<double> createFadeAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeIn,
  }) => Tween<double>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) => Tween<Offset>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  static Animation<double> createRotateAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.linear,
  }) => Tween<double>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  static Animation<double> createPulseAnimation(
    AnimationController controller, {
    double minScale = 0.95,
    double maxScale = 1.05,
  }) => Tween<double>(
    begin: minScale,
    end: maxScale,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

  static Animation<Color?> createColorAnimation(
    AnimationController controller, {
    required Color begin,
    required Color end,
    Curve curve = Curves.easeInOut,
  }) => ColorTween(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);
}
