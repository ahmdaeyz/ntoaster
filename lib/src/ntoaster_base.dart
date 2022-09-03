import 'package:flutter/widgets.dart';
import 'package:ntoaster/src/configuration/notification_meta_data.dart';
import 'package:ntoaster/src/configuration/ntoaster_configuration.dart';

abstract class NToasterBase {
  /// Attaches the notification center with [configuration]
  void attach(BuildContext context,
      {NToasterConfiguration configuration = const NToasterConfiguration()});

  void enqueue(NotificationMetaData data);

  void dequeue(NotificationMetaData data);

  /// Detaches the notification center with [configuration]
  void detach();
}
