import 'package:flutter/material.dart';

typedef DialogCallback = Future<T?> Function<T>({
  required DialogBuilder builder,
  required bool dismissable,
  required Duration transitionDuration,
  RouteTransitionsBuilder? transitionBuilder,
  RouteSettings? routeSettings,
});

typedef DialogBuilder = Widget Function();

abstract class DialogService {
  void registerCallback(DialogCallback? showDialogCallback);

  Future<T?> showDialog<T>({
    required DialogBuilder builder,
    bool barrierDismissable,
    Duration transitionDuration,
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? routeSettings,
  });
}

class AppDialogService extends DialogService {
  DialogCallback? showDialogCallback;

  @override
  void registerCallback(DialogCallback? showDialogCallback) {
    this.showDialogCallback = showDialogCallback;
  }

  @override
  Future<T?> showDialog<T>({
    required DialogBuilder builder,
    bool barrierDismissable = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? routeSettings,
  }) {
    return (showDialogCallback == null)
        ? Future.value(null)
        : showDialogCallback!.call(
            builder: builder,
            dismissable: barrierDismissable,
            transitionDuration: transitionDuration,
            transitionBuilder: transitionBuilder,
            routeSettings: routeSettings,
          );
  }
}
