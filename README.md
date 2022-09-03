# NToaster


https://user-images.githubusercontent.com/36048466/188284228-cb91fd1d-9237-4edc-8d49-c4bba6e7bb31.mp4


#### Notification Toaster.
> Toasts are lightweight notifications designed to mimic the push notifications that have been popularized by mobile and desktop operating systems.
## Features

- Use either a Singleton or an InheritedWidget to get access to the Notifications Center.
- Completely flexible animation and widget UI.
- You can remove the notification programmatically.
- When the user long presses the notification its timer is paused until it is free.

## Usage

1) Attach the notification center manually using the `NToasterController.attach` or Construct
   a `NToasterCenter` which takes care of attaching and detaching the notification center and
   provides you with an `NToaster` `InheritedWidget`.

```dart
// Manual attachment
final ntoaster = NToasterController.getInstance();
ntoaster.attach(context, configuration: NToasterConfiguration
(
)) // Pass your center level configuration;

```

```dart
// Widget attachment
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const NToasterCenter(
        child: MyHomePage(title: 'Flutter Demo Home Page')),
  );
}
```

2) Enqueue your notifications (with whichever size/animation)

```dart
// with `InheritedWidget`
final ntoaster = NToaster.of(context);
NotificationMetaData? notification;
notification = NotificationMetaData(
  showFor: Duration(milliseconds:5000),
item: GestureDetector(
  onTap: () {
    notification?.remove();
  },
  child: SizedBox(
    height:100,
    width: 300,
    child: Card(
      elevation: 8.0,
      color: Colors.green,child: Text("$_counter Cool title",style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),),),),),
);
ntoaster.enqueue(notification,);
```

3) If you hold into a reference of a `NotificationMetaData` you can `dequeue` it immediately before
   the timer ends.

```dart

final notificationX = NotificationMetaData(...);
final ntoaster = NToaster.of(context);
ntoaster.dequeue(notificationX);
```

