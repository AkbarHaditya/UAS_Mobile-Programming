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
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  String _errorMessage = "";

  void _login() async {
    setState(() {
      _errorMessage = ""; // Reset error message
    });

    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        print('Trying to get user data');
        final userData = await _getUserData(email, password);

        if (userData != null) {
          print('User data found');
          if (userData['Password'] == password) {
            // Jika data ditemukan dan password cocok, arahkan ke HomePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            setState(() {
              _errorMessage = "Password salah. Silakan coba lagi.";
            });
          }
        } else {
          setState(() {
            _errorMessage = "Username atau password salah. Silakan coba lagi.";
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _getUserData(
      String email, String password) async {
    MySqlConnection conn = await createConnection();
    try {
      print('Connecting to the database');
      var results = await conn.query(
        'SELECT * FROM data_user WHERE Email = ? AND Password = ?',
        [email, password],
      );

      print('Query executed');
      if (results.isNotEmpty) {
        print('User data retrieved');
        return results.first.fields;
      } else {
        print('No user found');
        return null;
      }
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
      body: Stack(
        children: [
          // Background
          Container(
            color: Color.fromARGB(255, 224, 220, 220),
          ),

          Center(
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: 950,
                    height: 550, // Atur tinggi card
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/image/Bg1.jpg"), // Ganti dengan gambar background card Anda
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ))),
          // Positioned Card form login
          Positioned(
            right: 250, // Ubah nilai ini untuk mengatur posisi kiri-kanan
            top: 200,
            child: Container(
              width: 350, // Atur lebar Container (form login)
              height: 350,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukan username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukan password';
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Color.fromARGB(255, 196, 32, 4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    RegisterPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                        // Tambahkan logika navigasi ke halaman pendaftaran di sini
                      },
                      child: Text(
                        'Belum punya akun? Daftar sekarang',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = "";

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String username = _emailController.text;
      String password = _passwordController.text;

      try {
        await _saveDataToDatabase(username, password);
        _emailController.clear();
        _passwordController.clear();

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
        // Tampilkan pesan sukses atau navigasi ke halaman lain
      } catch (e) {
        setState(() {
          _errorMessage = "Gagal mendaftar. Silakan coba lagi.";
        });
      }
    }
  }

  Future<void> _saveDataToDatabase(String email, String password) async {
    MySqlConnection conn = await createConnection();
    try {
      await conn.query(
        'INSERT INTO data_user (Email, Password) VALUES (?, ?)',
        [email, password],
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
      db: 'db_reservasi',
    );

    return await MySqlConnection.connect(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Color.fromARGB(255, 224, 220, 220),
          ),

          Center(
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: 950,
                    height: 550, // Atur tinggi card
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/image/Bg1.jpg"), // Ganti dengan gambar background card Anda
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ))),
          // Positioned Card form login
          Positioned(
            right: 250, // Ubah nilai ini untuk mengatur posisi kiri-kanan
            top: 200,
            child: Container(
              width: 350, // Atur lebar Container (form login)
              height: 350,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Create New Account',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
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
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon diisi kolom ini';
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Color.fromARGB(255, 196, 32, 4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _register();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
