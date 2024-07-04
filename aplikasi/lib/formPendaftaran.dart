import 'package:flutter/material.dart';
import 'package:aplikasi/home.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormPage(

      ),
    );
  }
}

class FormPage extends StatefulWidget {

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedValueTanggal = 'Tanggal';

  late TextEditingController _controllerAsalSekolah;
  late TextEditingController _controllerNoTelp;
  late TextEditingController _controllerNamaOrtu;
  late TextEditingController _controllerAlamat;
  late TextEditingController _controllerTanggal;
  late TextEditingController _controllerNamaLengkap;
  late TextEditingController _controllerNISN;
  late TextEditingController _controllerNoPendaftaran;

  @override
  void initState() {
    super.initState();
    _controllerAsalSekolah = TextEditingController();
     _controllerNoTelp = TextEditingController();
    _controllerNamaOrtu = TextEditingController();
    _controllerAlamat = TextEditingController();
    _controllerTanggal = TextEditingController();
    _controllerNamaLengkap = TextEditingController();
    _controllerNISN = TextEditingController();
    _controllerNoPendaftaran = TextEditingController();
  }

  @override
  void dispose() {
    _controllerAsalSekolah.dispose();
    _controllerNoTelp.dispose();
    _controllerNamaOrtu.dispose();
    _controllerAlamat.dispose();
    _controllerNamaLengkap.dispose();
    _controllerNISN.dispose();
    _controllerNoPendaftaran.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _saveDataToDatabase();
        setState(() {
          _selectedValueTanggal = 'Tanggal';
        });
        _controllerAsalSekolah.clear();
        _controllerNoTelp.clear();
        _controllerNamaOrtu.clear();
        _controllerAlamat.clear();
        _controllerNamaLengkap.clear();
        _controllerNISN.clear();
        _controllerNoPendaftaran.clear();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
    
            ),
          ),
        );
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
        'INSERT INTO calon_siswa (`No_Pendaftaran`, `NISN`, `Nama_Lengkap`, `Tanggal_Lahir`,`Alamat`,`Nama_Ortu`,`Telp`,`Asal_Sekolah`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [_controllerNoPendaftaran.text, _controllerNISN.text, _controllerNamaLengkap.text, _selectedValueTanggal, _controllerAlamat.text, _controllerNamaOrtu.text, _controllerNoTelp.text, _controllerAsalSekolah.text ],
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
                  side: BorderSide(color: Colors.black, width: 2.0),
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
                          'Registrasi Siswa',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _controllerNoPendaftaran,
                          decoration: InputDecoration(
                            labelText: 'No Pendafftaran',
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
                          controller: _controllerNISN,
                          decoration: InputDecoration(
                            labelText: 'NISN',
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
                        SizedBox(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tanggal Lahir',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: _controllerTanggal,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Lahir',
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
                                _controllerTanggal.text =
                                    _selectedValueTanggal;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10.0),
                         TextFormField(
                          controller: _controllerAlamat,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
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
                          controller: _controllerNamaOrtu,
                          decoration: InputDecoration(
                            labelText: 'Nama Orang tua',
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
                          controller: _controllerNoTelp,
                          decoration: InputDecoration(
                            labelText: 'No Telpon',
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
                          controller: _controllerAsalSekolah,
                          decoration: InputDecoration(
                            labelText: 'Asal Sekolah',
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
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center, // or MainAxisAlignment.spaceBetween
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
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                                        content: Text('Apakah Anda yakin ingin membatalkan dan kembali ke halaman utama?'),
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
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                            ],
                          )

                             
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
