import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:storekeeper_app/models/product.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    int version = 1;
    String path = await getDatabasesPath();
    String fullPath = join(path, 'products.db');

    return await openDatabase(
      fullPath,
      version: version,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        imagePath TEXT
      )
    """);
  }

  // ----------------- CRUD -------------------
  // Create product
  Future<int> add(Product product) async {
    Database db = await database;

    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // View or read product
  Future<List<Product>> viewAllProducts() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('products');

    return maps.map((map) => Product.fromMap(map)).toList();
  }

  // Update or edit a product
  Future<int> edit(Product product) async {
    Database db = await database;

    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  Future<int> delete(int id) async {
    Database db = await database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close datbase
  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}