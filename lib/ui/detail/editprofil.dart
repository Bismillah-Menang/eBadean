import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/ip.dart';
import 'package:e_badean/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
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
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tgllahirController = TextEditingController();
  final TextEditingController kebangsaanController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController statusnikahController = TextEditingController();
  final TextEditingController nikController = TextEditingController();

  String? _selectedGender;
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    _populateUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Data',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Fullname',
                  prefixIcon: Icon(Icons.person_2_outlined),
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
                keyboardType: TextInputType.emailAddress,
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
                keyboardType: TextInputType.phone,
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
              SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Jenis kelamin',
                  prefixIcon: Icon(Icons.male),
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
                items: ['laki-laki', 'perempuan']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value as String?;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis kelamin harus dipilih';
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
                    initialDate: _pickedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _pickedDate = pickedDate;
                      tgllahirController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
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
                  prefixIcon: Icon(Icons.numbers),
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
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(29, 216, 163, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ), // Using Poppins font
                ),
                child: Text(
                  'SAVE',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _populateUserDataFromResponse(dynamic response) async {
    if (response['status']) {
      Map<String, dynamic> userData = response['user'];

      setState(() {
        fullNameController.text = userData['penduduk']['nama_lengkap'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneNumberController.text = userData['penduduk']['no_hp'] ?? '';
        alamatController.text = userData['penduduk']['alamat'] ?? '';
        kebangsaanController.text = userData['penduduk']['kebangsaan'] ?? '';
        pekerjaanController.text = userData['penduduk']['pekerjaan'] ?? '';
        statusnikahController.text = userData['penduduk']['status_nikah'] ?? '';
        nikController.text = userData['penduduk']['nik'] ?? '';

        if (userData['penduduk']['tanggal_lahir'] != null) {
          final dateParts = userData['penduduk']['tanggal_lahir'].split('-');
          if (dateParts.length == 3) {
            _pickedDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
            tgllahirController.text =
                DateFormat('dd-MM-yyyy').format(_pickedDate!);
          }
        }

        _selectedGender = userData['penduduk']['jenis_kelamin'];
      });
    }
  }

  Future<void> _populateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      dynamic response = await DBHelper.getUserFromLocal(token);
      await _populateUserDataFromResponse(response);
    }
  }

Future<User?> _getUserFromLocal(String token) async {
  try {
    dynamic response = await DBHelper.getUserFromLocal(token);
    if (response != null && response['status'] == true) {
      dynamic userData = response['user'];
      if (userData != null && userData['penduduk'] != null) {
        return User.fromJson(userData);
      } else {
        print('Data pengguna tidak ditemukan dalam respons');
        return null;
      }
    } else {
      print('Respons tidak sesuai dengan yang diharapkan');
      return null;
    }
  } catch (error) {
    print("Error getting user data: $error");
    return null;
  }
}

  Future<bool> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      String url = "${ApiConfig.baseUrl}/api/update_user";

      try {
        // Mendapatkan user dari database lokal
        User? user = await DBHelper.getUserFromLocal(token);
        if (user != null) {
          final response = await http.put(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'id_user': user.id,
              'nama_lengkap': fullNameController.text,
              'email': emailController.text,
              'no_hp': phoneNumberController.text,
              'jenis_kelamin': _selectedGender,
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
        } else {
          print("User not found in local database");
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

Future<void> _updateUserToLocal(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token != null) {
    User? existingUser = await _getUserFromLocal(token);
    if (existingUser != null) {
      Map<String, dynamic> updatedPenduduk = {
        'nama_lengkap': fullNameController.text,
        'no_hp': phoneNumberController.text,
        'jenis_kelamin': _selectedGender,
        'alamat': alamatController.text,
        'tanggal_lahir': tgllahirController.text,
        'kebangsaan': kebangsaanController.text,
        'pekerjaan': pekerjaanController.text,
        'status_nikah': statusnikahController.text,
        'nik': nikController.text,
      };

      User updatedUser = User(
        id: existingUser.id,
        email: emailController.text,
        penduduk: updatedPenduduk,
      );

      // Simpan data pengguna yang diperbarui ke penyimpanan lokal
      await DBHelper.updateUser(updatedUser, token);

      // Perbarui tampilan dengan data pengguna yang diperbarui
      await _populateUserData();
    }
  } else {
    print("Token not found");
  }
}


}
