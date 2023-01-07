import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart';

class Edit extends StatefulWidget {
  Edit({required this.id});

  String id;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();

  // inisialisasi form
  var title = TextEditingController();
  var content = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getData() akan dijalankan pertama kali
    _getData();
  }

  // http untuk mengambil data
  Future _getData() async {
    try {
      final response =
          await http.get(Uri.parse("${Env.URL_PREFIX}/notepad/${widget.id}"));

      // jika respon berhasil
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          title = TextEditingController(text: data['data']['title']);
          content = TextEditingController(text: data['data']['content']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onUpdate(context) async {
    try {
      return await http.put(
        Uri.parse("${Env.URL_PREFIX}/notepad/${widget.id}"),
        headers: {"Accept": "application/json"},
        body: {
          "id": widget.id,
          "title": title.text,
          "content": content.text,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  Future _onDelete(context) async {
    try {
      return await http.delete(
        Uri.parse("${Env.URL_PREFIX}/notepad/${widget.id}"),
        headers: {"Accept": "application/json"},
      ).then((value) {
        // Menghapus semua route yang dibuka dan menampilkan kembali halaman utama
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Catatan"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //tampilkan dialog untuk mengonfirmasi penghapusan data
                      return AlertDialog(
                        content: Text('Apa kamu yakin ingin menghapus ini?'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Icon(Icons.cancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Icon(Icons.check_circle),
                            onPressed: () => _onDelete(context),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Judul',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                    hintText: "Ketik Judul Catatan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Judul Catatan Diperlukan!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Konten',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Ketik Konten Catatan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Catatan Konten Diperlukan!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Kirim",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  //validasi
                  if (_formKey.currentState!.validate()) {
                    // kirim data ke database dengan _onUpdate(context);
                    _onUpdate(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
