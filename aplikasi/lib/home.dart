import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:aplikasi/formPendaftaran.dart';
import 'package:aplikasi/laporanTransaksi.dart';
import 'package:aplikasi/testPage.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Penerimaan Peserta Didik Baru"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 236, 232, 232),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            ImageSliderWidget(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white54,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Color.fromARGB(255, 122, 122, 122),
          labelColor: Color.fromARGB(255, 122, 122, 122),
          unselectedLabelColor: Color.fromARGB(255, 122, 122, 122),
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
          ],
        ),
      ),
    );
  }
}

class ImageSliderWidget extends StatefulWidget {
  @override
  _ImageSliderWidgetState createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _images = [
    {
      'image': 'assets/image/pramuka.jpg',
      'judul': 'Ekskul Pramuka',
    },
    {
      'image': 'assets/image/paskibra.jpg',
      'judul': 'Ekskul Paskibra',
    },
    {
      'image': 'assets/image/sepakbola.jpg',
      'judul': 'Ekskul Sepakbola',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500, // Atur tinggi yang sesuai untuk PageView
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              _images[index]['image']!,
                              height: 550,
                              width: 600,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _images[index]['judul']!,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _images.length,
              effect: WormEffect(),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormPage(),
                                  ),
                                );
                                print('PPDB button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(150, 100),
                                side: BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.school, size: 60),
                            ),
                            SizedBox(height: 5),
                            Text('Pendaftaran', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Info PPDB button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(150, 100),
                                side: BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.info, size: 60),
                            ),
                            SizedBox(height: 5),
                            Text('Pengumuman', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizPage(),
                                  ),
                                );
                                print('Test button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(150, 100),
                                side: BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.task, size: 60),
                            ),
                            SizedBox(height: 5),
                            Text('Test', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Transaksi button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(250, 100),
                                side: BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.money, size: 60),
                            ),
                            SizedBox(height: 5),
                            Text('Transaksi', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LaporanTransaksi(),
                                  ),
                                );
                                print('Laporan Transaksi button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(250, 100),
                                side: BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.description, size: 60),
                            ),
                            SizedBox(height: 5),
                            Text('Laporan Transaksi', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
