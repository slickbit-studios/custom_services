import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    String? id,
    String? title,
    String? body,
  }) = _Message;
}
