import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class TransaksiTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  TransaksiTable(this.data);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        // Baris pertama sebagai header
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          children: [
            _buildTableHeader('Nama_Lengkap'),
            _buildTableHeader('Biaya'),
            _buildTableHeader('Jumlah_Total'),
            _buildTableHeader('Tanggal'),
            _buildTableHeader('Metode'),
          ],
        ),
        // Data dari database
        ...data.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> row = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: idx % 2 == 0 ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            children: [
              _buildTableCell(row['Nama_Lengkap']?.toString() ?? ''),
              _buildTableCell(row['Biaya']?.toString() ?? ''),
              _buildTableCell(row['Jumlah_Total']?.toString() ?? ''),
              _buildTableCell(row['Tanggal']?.toString() ?? ''),
              _buildTableCell(row['Metode']?.toString() ?? ''),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}


class LaporanTransaksi extends StatefulWidget {
  
 @override
  _LaporanTransaksiState createState() => _LaporanTransaksiState();
  Widget _buildTableCell(String text) {
  return Container(
    color: Colors.black,
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(color: Colors.black),
    ),
  );
}
}

class _LaporanTransaksiState extends State<LaporanTransaksi> {
  
  late Future<List<Map<String, dynamic>>> _dataFuture1;


  @override
  void initState() {
    super.initState();
    _dataFuture1 = getDataFromDatabase1();
    // Inisialisasi future lainnya sesuai kebutuhan
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

Future<List<Map<String, dynamic>>> getDataFromDatabase1() async {
    MySqlConnection conn = await createConnection();
    Results result = await conn.query('SELECT * FROM transaksi');
    await conn.close();

    List<Map<String, dynamic>> data = [];
    for (var row in result) {
      data.add(Map.from(row.fields));
    }

    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_dataFuture1]),
        builder: (context, AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<List<Map<String, dynamic>>> data = snapshot.data!;
            List<Map<String, dynamic>> data1 = data[0];

            // Use data1, data2, data3, and data4 to build your UI
            return _buildReport(data1);
          }
        },
      ),
    );
  }


  

  Widget _buildReport(List<Map<String, dynamic>> data1) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 224, 220, 220),
      
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: [
              _buildSectionTitle('Form Transaksi'),
                TransaksiTable(data1),
  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Beranda'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigasi ke Beranda di sini
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigasi ke Profil di sini
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigasi ke Pengaturan di sini
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Keluar'),
            onTap: () {
              Navigator.pop(context);
              // Handle aksi keluar di sini
            },
          ),
        ],
      ),
    );
  }
}



  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  

