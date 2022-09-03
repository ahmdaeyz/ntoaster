import 'package:flutter/widgets.dart';
import 'package:ntoaster/ntoaster.dart';
import 'package:ntoaster/src/ntoaster_base.dart';

class NToasterCenter extends StatefulWidget {
  const NToasterCenter(
      {Key? key,
      required this.child,
      this.configuration = const NToasterConfiguration()})
      : super(key: key);
  final NToasterConfiguration configuration;
  final Widget child;

  @override
  State<NToasterCenter> createState() => _NToasterCenterState();
}

class _NToasterCenterState extends State<NToasterCenter> {
  final NToasterController _controller = NToasterController.getInstance();

  @override
  void initState() {
    super.initState();
    _controller.attach(context, configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return NToaster(
      _controller,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.detach();
  }
}

class NToaster extends InheritedWidget implements NToasterBase {
  const NToaster(
    this._controller, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);
  final NToasterController _controller;

  static NToaster of(BuildContext context) {
    final NToaster? result =
        context.dependOnInheritedWidgetOfExactType<NToaster>();
    assert(result != null, 'No NToaster found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(NToaster oldWidget) => false;

  @override
  void attach(BuildContext context,
          {NToasterConfiguration configuration =
              const NToasterConfiguration()}) =>
      _controller.attach(context, configuration: configuration);

  @override
  void dequeue(NotificationMetaData data) => _controller.dequeue(data);

  @override
  void detach() => _controller.detach();

  @override
  void enqueue(NotificationMetaData data) => _controller.enqueue(data);
}
