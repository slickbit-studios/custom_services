import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const Session._();

  const factory Session({
    required String id,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'success_url') required String successUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'cancel_url') required String cancelUrl,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}
