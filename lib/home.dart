import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';
import 'edit.dart';
import 'env.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // membuat list/array untuk mengakomodasi semua data dari database
  List _get = [];

  //membuat warna berbeda untuk card yang beda
  final _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  void initState() {
    super.initState();
    // _getData() akan dijalankan pertama kali
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse("${Env.URL_PREFIX}/notepad"),
          headers: {"Accept": "application/json"});

      // jika respon berhasil
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // data dari database
        setState(() {
          _get = data["data"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepadku'),
      ),
      //jika tidak sama dengan 0 maka akan menampilkan data
      //jika sama maka akan menampilkan pesan
      body: _get.length != 0
          //mansory grid sebagai tampilan card
          ? MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: _get.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        //route untuk halaman edit
                        //mengirim id
                        MaterialPageRoute(
                            builder: (context) => Edit(
                                  id: _get[index]['id'],
                                )));
                  },
                  child: Card(
                    //warna acak untuk berbagai card
                    color: _lightColors[index % _lightColors.length],
                    child: Container(
                      //membuat 2 tinggi berbeda
                      constraints:
                          BoxConstraints(minHeight: (index % 2 + 1) * 85),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            '${_get[index]['title']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Tidak ada data yang tersedia",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              //route untuk menambahkan note baru
              MaterialPageRoute(builder: (context) => Add()));
        },
      ),
    );
  }
}
