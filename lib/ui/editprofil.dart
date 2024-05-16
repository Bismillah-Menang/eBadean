import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  final TextEditingController jeniskelaminController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tgllahirController = TextEditingController();
  final TextEditingController kebangsaanController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController statusnikahController = TextEditingController();
  final TextEditingController nikController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Fullname',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: jeniskelaminController,
                decoration: InputDecoration(
                  labelText: 'Jenis kelamin',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Jenis kelamin harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      tgllahirController.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: tgllahirController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan tanggal lahir',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF1548AD),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tanggal lahir harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: kebangsaanController,
                decoration: InputDecoration(
                  labelText: 'Masukkan kebangsaan',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kebangsaan harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: pekerjaanController,
                decoration: InputDecoration(
                  labelText: 'Masukkan pekerjaan',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Pekerjaan harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: statusnikahController,
                decoration: InputDecoration(
                  labelText: 'Masukkan status pernikahan',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Status pernikahan harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nikController,
                decoration: InputDecoration(
                  labelText: 'Masukkan NIK',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xFF1548AD),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'NIK harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool result = await _updateProfile();
                  if (result) {
                    _showSuccessEdit();
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(29, 216, 163, 80)// Warna latar belakang
                  // Anda juga dapat mengatur warna lain seperti warna teks, bayangan, dll.
                ),
                child: Text('SAVE', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
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
        jeniskelaminController.text = user.jenis_kelamin ?? '';
        alamatController.text = user.alamat ?? '';
        tgllahirController.text = user.ttl ?? '';
        kebangsaanController.text = user.kebangsaan ?? '';
        pekerjaanController.text = user.pekerjaan ?? '';
        statusnikahController.text = user.status_nikah ?? '';
        nikController.text = user.nik ?? '';
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
            'jenis_kelamin': jeniskelaminController.text,
            'alamat': alamatController.text,
            'tanggal_lahir': tgllahirController.text,
            'kebangsaan': kebangsaanController.text,
            'pekerjaan': pekerjaanController.text,
            'status_nikah': statusnikahController.text,
            'nik': nikController.text
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

  void _showSuccessEdit() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Profile Terbarui',
      desc: 'Selamat profilmu sudah terbarui',
      btnOkOnPress: () {},
    )..show();
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
        alamat: alamatController.text,
        jenis_kelamin: jeniskelaminController.text,
        ttl: tgllahirController.text,
        kebangsaan: kebangsaanController.text,
        pekerjaan: pekerjaanController.text,
        status_nikah: statusnikahController.text,
        nik: nikController.text,
      );

      await DBHelper.updateUser(updatedUser, token);
      await _populateUserData();
    }
  }
}
