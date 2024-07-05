import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost', // Ganti dengan host database Anda
      port: 3306,
      user: 'admin', // Ganti dengan username database Anda
      password: 'admin123', // Ganti dengan password database Anda
      db: 'db_ppdb', // Ganti dengan nama database Anda
    );

    return await MySqlConnection.connect(settings);
  }
}
