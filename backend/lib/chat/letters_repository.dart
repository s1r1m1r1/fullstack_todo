import 'dart:io';

import 'package:backend/db_client/db_client.dart';
import 'package:drift/drift.dart' show Value;
import 'package:shared/shared.dart';

import '../db_client/dao/letters_dao.dart';
import '../models/typedefs.dart';

class LettersRepository {
  final LettersDao _dao;

  const LettersRepository(this._dao);

  Future<LetterDto?> createLetter(Json payload) async {
    stdout.writeln('Creating letter: start');
    final LetterDto letter = LetterDto.fromJson(payload);
    try {
      final entry = await _dao.insertRow(
        LetterTableCompanion(
          chatRoomId: Value(0),
          content: Value(letter.content),
          senderId: Value(letter.senderId),
          createdAt: Value(DateTime.now()),
        ),
      );
      if (entry?.id == null || entry?.chatRoomId == null) {
        return null;
      }
      stdout.writeln('Creating letter: success');
      return LetterDto(
        id: entry!.id,
        chatRoomId: entry.chatRoomId!,
        senderId: entry.senderId,
        content: entry.content,
        createdAt: entry.createdAt,
      );
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> deleteLetter(Json payload) async {
    final id = payload['id'];

    try {
      await _dao.deleteLetter(id);
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<Iterable<LetterDto>> fetchAllLetters() async {
    try {
      final messages = await _dao.getListLetter();

      return messages.map(
        (i) =>
            LetterDto(chatRoomId: i.chatRoomId ?? 0, content: i.content, senderId: i.senderId, createdAt: i.createdAt),
      );
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<Iterable<LetterDto>> fetchMessages(String chatRoomId) async {
    try {
      final messages = await _dao.getListLetter();

      return messages.map(
        (i) =>
            LetterDto(chatRoomId: i.chatRoomId ?? 0, content: i.content, senderId: i.senderId, createdAt: i.createdAt),
      );
    } catch (err) {
      throw Exception(err);
    }
  }
}
