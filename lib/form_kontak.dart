// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/kontak.dart';

class FormKontak extends StatefulWidget {
  final Kontak? kontak;

  FormKontak({this.kontak});

  @override
  _FormKontakState createState() => _FormKontakState();
}

class _FormKontakState extends State<FormKontak> {
  DbHelper db = DbHelper();

  TextEditingController? name;
  TextEditingController? lastName;
  TextEditingController? mobileNo;
  TextEditingController? email;
  TextEditingController? company;

  @override
  void initState() {
    name = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.name);

    mobileNo = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.mobileNo);

    email = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.email);

    company = TextEditingController(
        text: widget.kontak == null ? '' : widget.kontak!.company);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Kontak'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: mobileNo,
              decoration: InputDecoration(
                  labelText: 'No HP/Telp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: company,
              decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: (widget.kontak == null)
                  ? Text(
                      'Tambah',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Ubah',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () {
                if (name?.text == "" || mobileNo?.text == "") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Nama & Nomor Telp tidak boleh kosong"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok")),
                          ],
                        );
                      });
                } else {
                  upsertKontak();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> upsertKontak() async {
    if (widget.kontak != null) {
      if (name?.text == "" || mobileNo?.text == "") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Nama & Nomor Telp tidak boleh kosong"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok")),
                ],
              );
            });
      } else {
        //update
        await db.updateKontak(Kontak(
            id: widget.kontak!.id,
            name: name!.text,
            mobileNo: mobileNo!.text,
            email: email!.text,
            company: company!.text));

        Navigator.pop(context, 'update');
      }
    } else {
      //insert
      await db.saveKontak(Kontak(
        name: name!.text,
        mobileNo: mobileNo!.text,
        email: email!.text,
        company: company!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
