import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();
  static Database? _database;

  Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'codes_database.db'),
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE codes(uniqueId INT, organizationName TEXT, codeCategory TEXT, interval INT)');
        await db.execute('CREATE TABLE categoryNames(id INTEGER PRIMARY KEY AUTOINCREMENT, codeCategory TEXT, color INT)');
        await db.execute('CREATE TABLE passwords(uniqueId INT, domainName TEXT, iv TEXT, username TEXT)');
        await db.execute('INSERT INTO categoryNames VALUES (1, \'+ ADD\', 0xff9e9e9e)');
        await db.execute('INSERT INTO categoryNames VALUES (2, \'all\', 0xff9e9e9e)');
        await db.execute('INSERT INTO categoryNames VALUES (3, \'work\', 0xffb36a5e)');
        await db.execute('INSERT INTO categoryNames VALUES (4, \'social\', 0xff3c887e)');
        await db.execute('INSERT INTO categoryNames VALUES (5, \'other\', 0xff9e9e9e)');
      },
      version: 1,
    );
  }
}