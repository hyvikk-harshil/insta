import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static const _databaseName = "instagram_clone.db";
  static const _databaseVersion = 1;

  // Singleton pattern
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create tables using foreign keys to keep data relational
  Future _onCreate(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        profile_pic TEXT
      )
    ''');

    // 2. Posts Table
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        caption TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Likes Table (Join table for User <-> Post relationship)
    await db.execute('''
      CREATE TABLE likes (
        post_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        PRIMARY KEY (post_id, user_id),
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');


    // Seed mock data so your app isn't blank on first boot
    await _seedMockData(db);
  }

  Future<void> _seedMockData(Database db) async {
    // Create Current User (ID: 1) and Mock Creator Accounts
    await db.rawInsert("INSERT INTO users (id, username, profile_pic) VALUES (1, 'my_username', 'assets/mock/me.jpg')");
    await db.rawInsert("INSERT INTO users (id, username, profile_pic) VALUES (2, 'travel_explorer', 'assets/mock/p1.jpg')");
    await db.rawInsert("INSERT INTO users (id, username, profile_pic) VALUES (3, 'chef_mode', 'assets/mock/p2.jpg')");

    // Pre-load a sample post from the travel account
    await db.rawInsert('''
      INSERT INTO posts (user_id, image_path, caption, timestamp) 
      VALUES (2, 'assets/mock/post1.jpg', 'Chasing sunrises in Bali! 🌅 #travel', '2026-09-02 10:00:00')
    ''');
  }
}
