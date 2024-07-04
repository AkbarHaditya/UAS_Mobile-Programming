import 'dart:io';
import 'package:mysql1/mysql1.dart';

Future<void> main() async {
  // Buat koneksi ke database
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'admin',
    password: 'admin123',
    db: 'db_reservasi',
  ));

  // Baca file SQL
  final file = File('"C:\Users\SUCI YULIA RAHAYU\OneDrive\Dokumen\Projek_Flutter\aplikasi\db\datamaster.sql"');
  final sql = await file.readAsString();

  // Eksekusi perintah SQL
  await conn.query(sql);

  // Tutup koneksi
  await conn.close();
}
