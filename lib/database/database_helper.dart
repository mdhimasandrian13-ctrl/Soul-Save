import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/celengan_model.dart';
import '../models/transaksi_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('soul_save.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE celengan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        emoji TEXT NOT NULL,
        target REAL NOT NULL,
        saldo REAL NOT NULL DEFAULT 0,
        targetTanggal TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        celenganId INTEGER NOT NULL,
        tipe TEXT NOT NULL,
        nominal REAL NOT NULL,
        catatan TEXT,
        tanggal TEXT NOT NULL,
        FOREIGN KEY (celenganId) REFERENCES celengan (id)
      )
    ''');
  }

  // CELENGAN CRUD
  Future<int> insertCelengan(Celengan c) async {
    final db = await database;
    return await db.insert('celengan', c.toMap());
  }

  Future<List<Celengan>> getAllCelengan() async {
    final db = await database;
    final maps = await db.query('celengan', orderBy: 'createdAt DESC');
    return maps.map((m) => Celengan.fromMap(m)).toList();
  }

  Future<int> updateCelengan(Celengan c) async {
    final db = await database;
    return await db.update('celengan', c.toMap(),
        where: 'id = ?', whereArgs: [c.id]);
  }

  Future<int> deleteCelengan(int id) async {
    final db = await database;
    await db.delete('transaksi', where: 'celenganId = ?', whereArgs: [id]);
    return await db.delete('celengan', where: 'id = ?', whereArgs: [id]);
  }

  // TRANSAKSI CRUD
  Future<int> insertTransaksi(Transaksi t) async {
    final db = await database;
    return await db.insert('transaksi', t.toMap());
  }

  Future<List<Transaksi>> getTransaksiBycelengan(int celenganId) async {
    final db = await database;
    final maps = await db.query('transaksi',
        where: 'celenganId = ?',
        whereArgs: [celenganId],
        orderBy: 'tanggal DESC');
    return maps.map((m) => Transaksi.fromMap(m)).toList();
  }
}