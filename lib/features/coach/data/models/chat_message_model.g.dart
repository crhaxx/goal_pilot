// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      role: ChatMessageModel._roleFromJson(json['role'] as Object),
      content: json['content'] as String,
      timestamp: ChatMessageModel._dateTimeFromJson(
        json['timestamp'] as Object,
      ),
      goalId: json['goalId'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'goalId': ?instance.goalId,
      'role': ChatMessageModel._roleToJson(instance.role),
      'timestamp': ChatMessageModel._dateTimeToJson(instance.timestamp),
    };
