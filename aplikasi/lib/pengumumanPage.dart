import 'package:flutter/material.dart';
import 'package:aplikasi/databaseHelper.dart';
import 'package:aplikasi/formTransaksi.dart';

class PengumumanPage extends StatefulWidget {
  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  int _score = 0;
  int _totalQuestions = 3; // Ganti sesuai dengan jumlah pertanyaan kuis Anda

  @override
  void initState() {
    super.initState();
    _fetchScoreFromDatabase();
  }

  Future<void> _fetchScoreFromDatabase() async {
    final conn = await DatabaseHelper().getConnection();
    var results = await conn.query('SELECT score FROM quiz_result ORDER BY id DESC LIMIT 1');
    if (results.isNotEmpty) {
      setState(() {
        _score = results.first['score'];
      });
    }
    await conn.close();
  }

  String get resultPhrase {
    double percentage = (_score / _totalQuestions) * 100;
    if (percentage >= 60) {
      return 'Selamat, Anda LULUS!';
    } else {
      return 'Maaf, Anda Tidak Lulus.';
    }
  }

  void _navigateBasedOnResult(BuildContext context) {
    double percentage = (_score / _totalQuestions) * 100;
    if (percentage >= 60) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormPage3(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman Kelulusan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Berdasarkan Hasil Test Yang Anda Lakukan',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              resultPhrase,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: resultPhrase.contains('Lulus',) ? Colors.green : Colors.red,
              ),
            ),
            if (resultPhrase.contains('Lulus')) ...[
              SizedBox(height: 20.0),
              Text(
                'Silakan lanjut ke form pembayaran',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _navigateBasedOnResult(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 18.0),
              ),
              child: Text(resultPhrase.contains('Lulus') ? 'Ke Form Pembayaran' : 'Kembali ke Home'),
            ),
          ],
        ),
      ),
    );
  }
}
