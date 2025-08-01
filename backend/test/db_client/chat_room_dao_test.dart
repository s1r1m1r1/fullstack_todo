import 'package:backend/db_client/dao/chat_room_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

class TestDbClient extends DbClient {
  TestDbClient() : super(NativeDatabase.memory());
}

void main() {
  late TestDbClient db;
  late ChatRoomDao dao;

  setUp(() async {
    db = TestDbClient();
    dao = ChatRoomDao(db);
    // Ensure tables are created
    await db.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await db.close();
  });

  test('Deleting a ChatRoomTable cascades to ChatMemberTable', () async {
    // Insert a user
    final user = await dao
        .into(db.userTable)
        .insertReturning(UserTableCompanion.insert(email: 'alice@mail.com', password: '123456'));
    final room = await dao.insertRoom(ChatRoomTableCompanion.insert(name: 'test1'));
    expect(room, isNotNull);
    // Insert a chat_room_user
    await dao.insertMember(ChatMemberTableCompanion.insert(chatRoomId: room!.id, userId: user.id));

    final usersBefore = await dao.getListMember(room.id);
    expect(usersBefore.length, 1);

    // Delete the chat room
    await dao.deleteRoom(room.id);

    // // chat_room_user should be deleted
    final usersAfter = await dao.getListMember(room.id);
    expect(usersAfter.length, 0);
  });

  test('Deleting a UserTable cascades to ChatMemberTable', () async {
    // Insert a user
    final user = await db
        .into(db.userTable)
        .insertReturning(UserTableCompanion.insert(email: 'bob@mail.net', password: '123456'));
    final room = await db.into(db.chatRoomTable).insertReturning(ChatRoomTableCompanion.insert(name: 'test1'));

    // Insert a chat_room_user
    await db.into(db.chatMemberTable).insert(ChatMemberTableCompanion.insert(chatRoomId: room.id, userId: user.id));

    final usersBefore = await dao.getListMember(room.id);
    expect(usersBefore.length, 1);

    // Delete the user
    await (db.delete(db.userTable)..where((t) => t.id.equals(user.id))).go();

    final usersAfter = await dao.getListMember(room.id);
    final userTest = await (db.select(db.userTable)..where((tbl) => tbl.id.equals(user.id))).getSingleOrNull();
    expect(userTest, null);
    expect(usersAfter.length, 0);
  });

  test('Deleting a ChatMemberTable does not affect UserTable', () async {
    // Insert a user
    final user = await db
        .into(db.userTable)
        .insertReturning(UserTableCompanion.insert(email: 'bob@mail.net', password: '123456'));

    // Insert a chat room
    final chatRoom = await db.into(db.chatRoomTable).insertReturning(ChatRoomTableCompanion.insert(name: 'Room 2'));

    // Insert a chat_room_user
    await db.into(db.chatMemberTable).insert(ChatMemberTableCompanion.insert(chatRoomId: chatRoom.id, userId: user.id));

    // Delete the chat_room_user
    await dao.deleteMember(chatRoom.id, user.id);

    // User should still exist
    final userTest = await (db.select(db.userTable)..where((t) => t.id.equals(user.id))).getSingleOrNull();
    expect(userTest!.email, 'bob@mail.net');
  });
}
