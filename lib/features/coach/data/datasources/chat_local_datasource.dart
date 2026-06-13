import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:goal_pilot/core/constants/storage_constants.dart';
import 'package:goal_pilot/core/error/exceptions.dart';
import 'package:goal_pilot/features/coach/data/models/chat_message_model.dart';

class ChatLocalDataSource {
  ChatLocalDataSource(this._box);

  final Box<String> _box;

  Future<List<ChatMessageModel>> getMessages(String goalId) async {
    try {
      final raw = _box.get(goalId);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Could not read chat history.', cause: e);
    }
  }

  Future<void> saveMessages(
    String goalId,
    List<ChatMessageModel> messages,
  ) async {
    try {
      final encoded = jsonEncode(messages.map((m) => m.toJson()).toList());
      await _box.put(goalId, encoded);
    } catch (e) {
      throw CacheException('Could not save chat history.', cause: e);
    }
  }
}

Future<ChatLocalDataSource> openChatLocalDataSource() async {
  if (!Hive.isBoxOpen(StorageConstants.chatBox)) {
    await Hive.openBox<String>(StorageConstants.chatBox);
  }
  return ChatLocalDataSource(Hive.box<String>(StorageConstants.chatBox));
}
