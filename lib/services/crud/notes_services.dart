import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'crud_exceptions.dart';

class NotesService {
  Database? _db;

  Future<DatabseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabseUser(
      id: userId,
      email: email,
    );
  }

  Future<DatabseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabseUser.fromRow(results.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath as String, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createExpenseTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<DatabaseExpense> createExpense({required DatabseUser owner}) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database with correct id

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const title = '';
    double amt = 0;
    String dateTime = "", category = "";

    //create expense

    final expenseId = await db.insert(expenseTable, {
      userIdColumn: owner.email,
      titleColumn: title,
      amountColumn: amt,
      dateTimeColumn: dateTime,
      categoryColumn: category,
      isSyncedWithCloudColumn: 1
    });

    final expense = DatabaseExpense(
      id: expenseId,
      userId: owner.id,
      title: title,
      amount: amt,
      dateTime: dateTime,
      category: category,
      isSyncedWithCloud: true,
    );

    return expense;
  }

  Future<void> deleteExpense({required int id}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      expenseTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      CouldNotDeleteExpense();
    }
  }

  Future<DatabaseExpense> getExpense({required int id}) async {
    final db = _getDatabaseOrThrow();
    final expense = await db.query(
      expenseTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (expense.isEmpty) {
      throw CouldNotFindExpense();
    } else {
      return DatabaseExpense.fromRow(expense.first);
    }
  }

  Future<Iterable<DatabaseExpense>> getAllExpenses() async {
    final db = _getDatabaseOrThrow();
    final expenses = await db.query(
      expenseTable,
    );

    return expenses.map((e) => DatabaseExpense.fromRow(expenses.first));
  }

  Future<DatabaseExpense> updateExpense({
    required DatabaseExpense expense,
    required String title,
    required double amount,
    required String dateTime,
    required String category,
  }) async {
    final db = _getDatabaseOrThrow();

    await getExpense(id: expense.id);

    final updateCount = await db.update(expenseTable, {
      titleColumn: title,
      amountColumn: amount,
      dateTimeColumn: dateTime,
      categoryColumn: category,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateExpense();
    } else {
      return await getExpense(id: expense.id);
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
const createExpenseTable = '''
        CREATE TABLE IF NOT EXISTS "expense" (
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
const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
