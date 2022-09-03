import 'package:flutter/widgets.dart';

class NToasterConfiguration {
  final double? maxWidth;
  final EdgeInsets? contentPadding;
  final double top;
  final double bottom;
  final double start;
  final double end;

  const NToasterConfiguration({
    this.maxWidth,
    this.contentPadding,
    this.top = 16,
    this.bottom = 0,
    this.start = 0,
    this.end = 16,
  });
}
