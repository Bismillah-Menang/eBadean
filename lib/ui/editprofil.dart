import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const EditProfilePage({Key? key, this.onProfileUpdated}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Fullname'),
            ),
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool result = await _updateProfile();
                if (result) {
                  Navigator.pop(context, true);
                }
              },
              child: Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _populateUserData() async {
    User? user = await _getUserFromLocal();
    if (user != null) {
      setState(() {
        fullNameController.text = user.nama_lengkap;
        userNameController.text = user.username;
        emailController.text = user.email;
        phoneNumberController.text = user.no_hp ?? '';
      });
    }
  }

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DBHelper.getUserFromLocal(token);
    } else {
      return null;
    }
  }

  Future<bool> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      String url = "${ApiConfig.baseUrl}/api/update_user";

      try {
        final response = await http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'nama_lengkap': fullNameController.text,
            'username': userNameController.text,
            'email': emailController.text,
            'no_hp': phoneNumberController.text,
            'alamat': alamatController.text,
          }),
        );

        if (response.statusCode == 200) {
          print("User data updated successfully");
          await _updateUserToLocal(token);
          return true;
        } else {
          print("Failed to update user data: ${response.body}");
          return false;
        }
      } catch (error) {
        print("Error updating user data: $error");
        return false;
      }
    } else {
      print("Token not found");
      return false;
    }
  }

  Future<User?> _updateUserToLocal(String token) async {
    User? existingUser = await _getUserFromLocal();
    if (existingUser != null) {
      User updatedUser = User(
        id: existingUser.id,
        nama_lengkap: fullNameController.text,
        username: userNameController.text,
        email: emailController.text,
        no_hp: phoneNumberController.text,
        alamat: existingUser.alamat,
        jenis_kelamin: existingUser.jenis_kelamin,
        ttl: existingUser.ttl,
        kebangsaan: existingUser.kebangsaan,
        pekerjaan: existingUser.pekerjaan,
        status_nikah: existingUser.status_nikah,
        nik: existingUser.nik,
      );

      await DBHelper.updateUser(updatedUser, token);
      _populateUserData();
    }
  }
}
