import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:aplikasi/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormPage3(),
    );
  }
}

class FormPage3 extends StatefulWidget {
  @override
  _FormPage3State createState() => _FormPage3State();
}

class _FormPage3State extends State<FormPage3>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _controllerBiaya = TextEditingController();
  final _controllerTanggal = TextEditingController();
  final _controllerJumlah = TextEditingController();
  final _controllerNamaLengkap = TextEditingController();

  String _selectedValueMetode = 'Gopay';
  String _selectedValueTanggal = 'Tanggal';

  Future<void> _simpan() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save data to database
        await _saveDataToDatabase();

        // Show payment note
        _showPaymentNote();

        setState(() {
          _selectedValueMetode = 'Gopay';
          _selectedValueTanggal = 'Tanggal';
        });

        _controllerBiaya.clear();
        _controllerJumlah.clear();
        _controllerNamaLengkap.clear();

        // Navigate to home page after saving
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _saveDataToDatabase() async {
    MySqlConnection conn = await createConnection();
    try {
      await conn.query(
        'INSERT INTO transaksi (`Nama_Lengkap`, `Biaya`, `Jumlah_Total`, `Tanggal`, `Metode`) VALUES (?, ?, ?, ?, ?)',
        [
          _controllerNamaLengkap.text,
          _controllerBiaya.text,
          _controllerJumlah.text,
          _selectedValueTanggal,
          _selectedValueMetode,
        ],
      );
    } finally {
      await conn.close();
    }
  }

  Future<MySqlConnection> createConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'admin',
      password: 'admin123',
      db: 'db_ppdb',
    );

    return await MySqlConnection.connect(settings);
  }

  void _showPaymentNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nota Pembayaran'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Nama: ${_controllerNamaLengkap}'),
                Text('Biaya: ${_controllerBiaya}'),
                Text('Jumlah: $_controllerJumlah'),
                Text('Tanggal: $_controllerTanggal'),
                Text('Metode Pembayaran: $_selectedValueMetode'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 236, 232, 232),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Card(
                elevation: 10.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pembayaran',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _controllerNamaLengkap,
                          decoration: InputDecoration(
                            labelText: 'Nama Lengkap',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon diisi kolom ini';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _controllerBiaya,
                          decoration: InputDecoration(
                            labelText: 'Biaya',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon diisi kolom ini';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _controllerJumlah,
                          decoration: InputDecoration(
                            labelText: 'Total Jumlah',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon diisi kolom ini';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          readOnly: true,
                          controller: _controllerTanggal,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedValueTanggal =
                                    '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
                                _controllerTanggal.text = _selectedValueTanggal;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButton<String>(
                            value: _selectedValueMetode,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 15,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValueMetode = newValue!;
                              });
                            },
                            items: <String>[
                              'Gopay',
                              'Dana',
                              'BCA',
                              'BRI',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // or MainAxisAlignment.spaceBetween
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _simpan();
                                },
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10), // Jarak antara dua tombol
                              ElevatedButton(
                                onPressed: () async {
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi'),
                                        content: Text(
                                            'Apakah Anda yakin ingin membatalkan dan kembali ke halaman utama?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('Tidak'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Ya'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirm) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
