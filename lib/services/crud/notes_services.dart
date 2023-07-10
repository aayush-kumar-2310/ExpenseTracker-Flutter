import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

class NotesService {
  Database? _db;

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath as String, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';

      await db.execute(createUserTable);
      const createExpenseTable = '''
        CREATE TABLE "expense" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "title"	TEXT NOT NULL,
        "amount"	NUMERIC NOT NULL,
        "dateTime"	TEXT NOT NULL,
        "category"	TEXT NOT NULL,
        "is_synced_with_cloud"	INTEGER NOT NULL,
        PRIMARY KEY("id"),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      )
      ''';

      await db.execute(createExpenseTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

class DatabseUser {
  final int id;
  final String email;
  DatabseUser({
    required this.id,
    required this.email,
  });

  DatabseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseExpense {
  final int id;
  final int userId;
  final String title;
  final double amount;
  final String dateTime;
  final String category;
  final bool isSyncedWithCloud;

  DatabaseExpense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.category,
    required this.isSyncedWithCloud,
  });

  DatabaseExpense.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        title = map[titleColumn] as String,
        amount = map[amountColumn] as double,
        dateTime = map[dateTimeColumn] as String,
        category = map[categoryColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseExpense other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'expense.db';
const expenseTable = 'expense';
const userTable = 'user';
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const titleColumn = "title";
const amountColumn = "amount";
const dateTimeColumn = "dateTime";
const categoryColumn = "category";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
