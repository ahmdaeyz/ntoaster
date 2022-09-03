import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:ntoaster/ntoaster.dart';

class NotificationMetaData {
  late int id;

  /// The widget holding your notification/toast configuration
  final Widget item;

  /// How much time you want the notification to be shown for
  final Duration showFor;

  /// Your [item] enter transition
  ///
  /// Use [animation] to drive your own animation like this:
  ///
  /// ```dart
  /// Tween<Offset>(
  ///   begin: Offset.zero,
  ///   end: Offset(1, 0)
  /// ).animate(animation)
  /// ```
  /// Or use it directly.
  final Widget Function(
      BuildContext context,

      /// The passed [item]
      Widget? child,
      Animation<double> animation)? insertionAnimationBuilder;

  /// Your [item] exit transition
  ///
  /// Use [animation] to drive your own animation like this:
  ///
  /// ```dart
  /// Tween<Offset>(
  ///   begin: Offset.zero,
  ///   end: Offset(1, 0)
  /// ).animate(animation)
  /// ```
  /// Or use it directly.
  final Widget Function(
      BuildContext context,

      /// The passed [item]
      Widget? child,
      Animation<double> animation)? removalAnimationBuilder;

  NotificationMetaData({
    required this.item,
    this.showFor = const Duration(milliseconds: 2000),
    this.removalAnimationBuilder,
    this.insertionAnimationBuilder,
  }) {
    id = Random(DateTime.now().millisecondsSinceEpoch).nextInt(10000000);
  }

  /// Removes this notification (triggering the [removalAnimationBuilder])
  void remove() {
    final ntoaster = NToasterController.getInstance();

    ntoaster.dequeue(this);
  }
}
