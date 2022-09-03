import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ntoaster/src/configuration/notification_meta_data.dart';
import 'package:ntoaster/src/ntoaster_base.dart';
import 'package:ntoaster/src/configuration/ntoaster_configuration.dart';
import 'package:pausable_timer/pausable_timer.dart';

class NToasterController implements NToasterBase {
  static NToasterController? _instance;
  final List<NotificationMetaData> _queue = <NotificationMetaData>[];

  final List<PausableTimer> _timers = <PausableTimer>[];

  NToasterConfiguration? _configuration;

  final _key = GlobalKey<AnimatedListState>();
  OverlayEntry? _entry;
  var _listWasAttached = false;

  NToasterController._();

  static NToasterController getInstance() {
    if (_instance != null) return _instance!;
    _instance = NToasterController._();
    return _instance!;
  }

  /// Attaches the notification center with [configuration]
  @override
  void attach(BuildContext context,
      {NToasterConfiguration configuration = const NToasterConfiguration()}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_listWasAttached) {
        _configuration = configuration;
        final entry = OverlayEntry(
            maintainState: true,
            builder: (context) => PositionedDirectional(
                top: _configuration?.top,
                bottom: _configuration?.bottom,
                start: _configuration?.start,
                end: _configuration?.end,
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: _configuration?.maxWidth ??
                          MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedList(
                          key: _key,
                          initialItemCount: _queue.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index, animation) {
                            final item = _queue.elementAt(index);
                            return Center(
                                key: ValueKey(item.id),
                                child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onLongPress: () {
                                      final timer = _timers[index];
                                      timer.pause();
                                    },
                                    onLongPressUp: () {
                                      final timer = _timers[index];
                                      timer.start();
                                    },
                                    child: Padding(
                                      padding: _configuration?.contentPadding ??
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: item.insertionAnimationBuilder
                                              ?.call(context, item.item,
                                                  animation) ??
                                          item.item,
                                    )));
                          }),
                    ),
                  ),
                )));
        final overlay = Overlay.of(context);
        if (overlay != null) {
          _entry = entry;
          overlay.insert(entry);
          _listWasAttached = true;
        } else {
          throw FlutterError(
              "You can't attach the notifications center when there is not an Overlay widget above it.");
        }
      }
    });
  }

  @override
  void enqueue(NotificationMetaData data) {
    if (_listWasAttached) {
      final length = _queue.length;
      _queue.add(data);
      _key.currentState?.insertItem(length);
      final timer = PausableTimer(data.showFor, () {
        try {
          _removeItem(data);
        } catch (e) {
          log(e.toString());
        }
      });
      _timers.add(timer);
      timer.start();
    } else {
      throw FlutterError(
          "You can't enqueue notifications before attaching the notification center with [NToast.attach]");
    }
  }

  @override
  void dequeue(NotificationMetaData data) {
    if (_listWasAttached && _queue.isNotEmpty) {
      _removeItem(data);
    } else {
      throw FlutterError(
          "You can't dequeue notifications before attaching the notification center with [NToast.attach] or when the notification center is empty.");
    }
  }

  void _removeItem(NotificationMetaData data) {
    final indexOfItem = _queue.indexWhere((element) => element.id == data.id);
    if (indexOfItem != -1) {
      final item = _queue[indexOfItem];
      _key.currentState?.removeItem(
          indexOfItem,
          (context, animation) => Center(
                child: Padding(
                  padding: _configuration?.contentPadding ??
                      const EdgeInsets.only(bottom: 8),
                  child: item.removalAnimationBuilder
                          ?.call(context, item.item, animation) ??
                      item.item,
                ),
              ));
      _queue.removeAt(indexOfItem);
      _timers.removeAt(indexOfItem);
    }
  }

  /// Detaches the notification center with [configuration]
  @override
  void detach() {
    _entry?.remove();
    _listWasAttached = false;
    _configuration = null;
  }
}
