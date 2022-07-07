// import 'dart:async';

// import 'package:fl_test/extention/list/filter.dart';
// import 'package:fl_test/services/auth/auth_exception.dart';
// import 'package:fl_test/services/crud/crud_constant.dart';
// import 'package:fl_test/services/crud/crud_exception.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class NoteService {
//   Database? _db;

//   List<DataBaseNote> _notes = [];
//   DataBaseUser? _user;

//   //singleton pattern for get one instance from of it
//   static final NoteService _shared = NoteService._sharedInstance();
//   NoteService._sharedInstance() {
//     _noteStreamController = StreamController<List<DataBaseNote>>.broadcast(
//       onListen: () {
//         _noteStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NoteService() => _shared;
//   // end of pattern

//   late final StreamController<List<DataBaseNote>> _noteStreamController;

//   Stream<List<DataBaseNote>> get allNotes =>
//       _noteStreamController.stream.filter(
//         (note) {
//           final currentUser = _user;
//           if (currentUser != null) {
//             return note.userId == currentUser.id;
//           } else {
//             throw UserShouldSetBeforeReadingAllNoteException();
//           }
//         },
//       );

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   Future<DataBaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _noteStreamController.add(_notes);
//   }

//   Future<DataBaseNote> updateNote({
//     required DataBaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     //* make sure note exist else throw an exception
//     await getNote(id: note.id);

//     //* update db
//     final updateCount = await db.update(
//         noteTable,
//         {
//           textColumn: text,
//           //* 0 because update but not sync with server
//           isSyncedWithCloudColumn: 0,
//         },
//         where: 'id = ?',
//         whereArgs: [note.id]);

//     if (updateCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updateNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updateNote.id);
//       _notes.add(updateNote);
//       _noteStreamController.add(_notes);
//       return updateNote;
//     }
//   }

//   Future<Iterable<DataBaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final notes = await db.query(
//       noteTable,
//     );

//     return notes.map((e) => DataBaseNote.formRow(e));
//   }

//   Future<DataBaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DataBaseNote.formRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _noteStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     //* return number of rows
//     final numberOfDeletions = await db.delete(noteTable);
//     _notes = [];
//     _noteStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     //* return 0 or 1 and 0 mean is note not exists
//     final deleteCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deleteCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _noteStreamController.add(_notes);
//     }
//   }

//   Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     //* make sure owner exist in database with current id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     const text = '';

//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     final note = DataBaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );

//     _notes.add(note);
//     _noteStreamController.add(_notes);

//     return note;
//   }

//   Future<DataBaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (result.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DataBaseUser.formRow(result.first);
//     }
//   }

//   Future<DataBaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (result.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DataBaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     //* return 0 or 1 and 0 mean is user or account not exists
//     final deleteCount = await db.delete(userTable,
//         where: 'email = ?', whereArgs: [email.toLowerCase()]);
//     if (deleteCount != 1) {
//       throw CouldNotDeleteUaer();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       //* create user table
//       await db.execute(crateUserTable);

//       //* create note table
//       await db.execute(crateNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectory();
//     }
//   }
// }

// @immutable
// class DataBaseUser {
//   final int id;
//   final String email;

//   const DataBaseUser({
//     required this.id,
//     required this.email,
//   });

//   DataBaseUser.formRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

// //* for fully print of instance in console not instance of DatabaseUser
//   @override
//   String toString() => 'Person, ID=$id, email=$email';

// //* override == operator for equality
//   @override
//   bool operator ==(covariant DataBaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// @immutable
// class DataBaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   const DataBaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DataBaseNote.formRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
//   @override
//   String toString() =>
//       'Note, ID=$id, userId=$userId, isSyncedWithCloud=$isSyncedWithCloud, text=$text';

//   @override
//   bool operator ==(covariant DataBaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
