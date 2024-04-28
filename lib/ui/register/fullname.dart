import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_badean/ui/register/username.dart';
import 'package:flutter/material.dart';

class Fullname extends StatefulWidget {
  @override
  FullnamePageState createState() => FullnamePageState();
}

class FullnamePageState extends State<Fullname> {
  TextEditingController fullnameController = TextEditingController();

  Future<void> _register(BuildContext context, String fullname) async {
    String url = "http://127.0.0.1:8000/api/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': fullname,
        },
      );

      print("Response: ${response.body}"); 

      final responseData = json.decode(response.body);

      if (responseData['status'] == false) {
        if (responseData['message'] == "Validation error") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Username(fullname: fullname)),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Registrasi Gagal"),
              content: Text(responseData['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Siapa Nama Lengkap Anda ?',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
            SizedBox(
              height: 50.0,
              child: TextFormField(
                controller: fullnameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: 'Masukkan Nama Lengkap',
                  labelStyle: TextStyle(fontSize: 14.0),
                  prefixIcon: Icon(Icons.person_2_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _register(context, fullnameController.text);
                },
                child: Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF1548AD),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
            ),
            SizedBox(height: 473.0), // Ganti dengan nilai yang sesuai
            Divider(),
          ],
        ),
      ),
    );
  }
}
