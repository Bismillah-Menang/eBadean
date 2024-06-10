import 'dart:io';

import 'package:e_badean/database/db_helper.dart';
import 'package:e_badean/ip.dart'; // Ensure this import exists
import 'package:e_badean/models/user.dart';
import 'package:file_picker/file_picker.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tgllahirController = TextEditingController();
  final TextEditingController kebangsaanController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();

  String? _selectedGender;
  DateTime? _pickedDate;
  String? _filePath;
  String? _filePathKtp;
  String? _fotoKKUrl;
  String? _fotoKTPUrl;

  @override
  void initState() {
    super.initState();
    _populateUserData();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _pickKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePathKtp = result.files.single.path;
      });
    }
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
              TextField(
                controller: tempatLahirController,
                decoration: InputDecoration(
                  labelText: 'Tempat Lahir',
                  prefixIcon: Icon(Icons.location_city),
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
                controller: agamaController,
                decoration: InputDecoration(
                  labelText: 'Agama',
                  prefixIcon: Icon(Icons.favorite),
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
                    return 'Agaam harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nikController,
                decoration: InputDecoration(
                  labelText: 'Masukkan NIK',
                  prefixIcon: Icon(Icons.badge),
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
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.upload_file),
                        title: Text(
                          _filePath == null
                              ? 'Unggah Foto/Scan KK'
                              : 'File terpilih: ${_filePath!.split('/').last}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                      if (_fotoKKUrl != null && _filePath == null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _fotoKKUrl!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickKtp,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.upload_file),
                        title: Text(
                          _filePathKtp == null
                              ? 'Foto KTP'
                              : 'File terpilih: ${_filePathKtp!.split('/').last}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                      if (_fotoKTPUrl != null && _filePathKtp == null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _fotoKTPUrl!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1548AD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _populateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        User? user = await getUserFromToken(token);

        if (user != null) {
          setState(() {
            fullNameController.text = user.penduduk?.namaLengkap ?? '';
            emailController.text = user.email;
            phoneNumberController.text = user.penduduk?.noHp ?? '';
            alamatController.text = user.penduduk?.alamat ?? '';
            tempatLahirController.text = user.penduduk?.tempatLahir ?? '';
            tgllahirController.text = user.penduduk?.tanggalLahir ?? '';
            kebangsaanController.text = user.penduduk?.kebangsaan ?? '';
            pekerjaanController.text = user.penduduk?.pekerjaan ?? '';
            agamaController.text = user.penduduk?.agama ?? '';
            nikController.text = user.penduduk?.nik ?? '';
            _selectedGender = user.penduduk?.jenisKelamin;
            _fotoKKUrl = user.penduduk?.fotoKk;
            _fotoKTPUrl = user.penduduk?.fotoKtp;
          });
        }
      } catch (error) {
        print("Error retrieving user data: $error");
      }
    } else {
      print("Token not found");
    }
  }

  Future<User?> getUserFromToken(String token) async {
    try {
      String url = "${ApiConfig.baseUrl}/api/get_user";

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Response getUserFromToken: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final userData = responseData['user'];
          if (userData != null) {
            return User.fromJson(userData);
          }
        } else {
          print("Failed to get user data: ${responseData['message']}");
          return null;
        }
      } else {
        print("Failed to get user data: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error getting user data: $error");
      return null;
    }
  }

  Future<User?> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      String url = "${ApiConfig.baseUrl}/api/update_user";

      try {
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
              'tempat_lahir': tempatLahirController.text,
              'tanggal_lahir': tgllahirController.text,
              'kebangsaan': kebangsaanController.text,
              'pekerjaan': pekerjaanController.text,
              'agama': agamaController.text,
              'nik': nikController.text,
            }),
          );

          if (_filePath != null) {
            _fotoKKUrl = await _uploadPhotoKK();
          }

          if (_filePathKtp != null) {
            _fotoKTPUrl = await _uploadPhotoKTP();
          }

          if (response.statusCode == 200) {
            User updatedUser = User(
              id: user.id,
              email: emailController.text,
              role: user.role,
              penduduk: Penduduk(
                id: user.penduduk?.id ?? 0,
                idUser: user.id,
                namaLengkap: fullNameController.text,
                noHp: phoneNumberController.text,
                jenisKelamin: _selectedGender,
                alamat: alamatController.text,
                tempatLahir: tempatLahirController.text,
                tanggalLahir: tgllahirController.text,
                kebangsaan: kebangsaanController.text,
                pekerjaan: pekerjaanController.text,
                agama: agamaController.text,
                nik: nikController.text,
              ),
            );

            await DBHelper.updateUser(updatedUser, token);
            _populateUserData();
            _showSuccessEdit();
            return user;
          } else {
            print("Failed to update user data: ${response.body}");
            return null;
          }
        } else {
          print("User not found in local database");
          return null;
        }
      } catch (error) {
        print("Error updating user data: $error");
        return null;
      }
    } else {
      print("Token not found");
      return null;
    }
  }

  Future<String?> _uploadPhotoKK() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && _filePath != null) {
      String url = "${ApiConfig.baseUrl}/api/upload_kk";

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('foto_kk', _filePath!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        print("Response from server: $responseBody");

        if (responseData.containsKey('foto_kk')) {
          return responseData['foto_kk'];
        } else {
          print("Response does not contain 'foto_kk' key");
          return null;
        }
      } else {
        print("Failed to upload photo KK: ${response.statusCode}");
        return null;
      }
    } else {
      print("Token or file path not found");
      return null;
    }
  }

  Future<String?> _uploadPhotoKTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && _filePathKtp != null) {
      String url = "${ApiConfig.baseUrl}/api/upload_ktp";

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('foto_ktp', _filePathKtp!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        print("Response from server: $responseBody");

        if (responseData.containsKey('foto_ktp')) {
          return responseData['foto_ktp'];
        } else {
          print("Response does not contain 'foto_ktp' key");
          return null;
        }
      } else {
        print("Failed to upload photo KTP: ${response.statusCode}");
        return null;
      }
    } else {
      print("Token or file path not found");
      return null;
    }
  }

  void _showSuccessEdit() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Profile Terbaharui',
      desc: 'Berhasil memperbarui data profil',
      btnOkOnPress: () {
        Navigator.pop(context, true);
      },
    )..show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }
}
