import 'package:json_annotation/json_annotation.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_message.dart';
import 'package:goal_pilot/features/coach/domain/entities/chat_role.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.goalId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  final String id;
  final String content;
  final String? goalId;

  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final ChatRole role;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime timestamp;

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      role: entity.role,
      content: entity.content,
      timestamp: entity.timestamp,
      goalId: entity.goalId,
    );
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      timestamp: timestamp,
      goalId: goalId,
    );
  }

  static ChatRole _roleFromJson(Object value) {
    if (value is String) {
      return ChatRole.values.firstWhere(
        (r) => r.name == value,
        orElse: () => ChatRole.user,
      );
    }
    return ChatRole.user;
  }

  static String _roleToJson(ChatRole role) => role.name;

  static DateTime _dateTimeFromJson(Object value) {
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw FormatException('Invalid DateTime value: $value');
  }

  static String _dateTimeToJson(DateTime value) => value.toIso8601String();
}
