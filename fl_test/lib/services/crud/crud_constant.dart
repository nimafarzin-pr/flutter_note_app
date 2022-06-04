const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_sync_with_cloud';
const crateUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
         );''';
const crateNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
	       "id"	INTEGER NOT NULL,
	       "user_id"	INTEGER NOT NULL,
	       "text"	TEXT,
	       "is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	       PRIMARY KEY("id" AUTOINCREMENT),
	       FOREIGN KEY("user_id") REFERENCES "user"("id")
        );''';
