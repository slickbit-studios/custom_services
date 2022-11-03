import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class NotificationMessage with _$NotificationMessage {
  const factory NotificationMessage({
    required bool empty, // is the notification part empty
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) = _NotificationMessage;
}
