import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:e_badean/ui/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:e_badean/ip.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_badean/models/emailRegister.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Register extends StatefulWidget {
  @override
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  String selectedGender = '';

  bool _passwordvisible = false;
  bool _passwordvisiblekonfirmasi = false;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  Future<void> _registerUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
    });

    String fullname = fullnameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPassController.text;
    String phoneNumber = phoneController.text;
    String address = alamatController.text;
    String gender = selectedGender;

    String? _validateEmail(String value) {
      if (value.isEmpty) {
        return 'Email harus diisi';
      }
      bool isValid = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
      ).hasMatch(value);
      if (!isValid) {
        return 'Email tidak valid';
      }
      return null;
    }

    // Metode validasi untuk password
    String? _validatePassword(String value) {
      if (value.isEmpty) {
        return 'Password harus diisi';
      }
      if (value.length < 6) {
        return 'Password harus terdiri dari setidaknya 6 karakter';
      }
      return null;
    }

    // Lakukan validasi form
    if (fullname.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty ||
        gender.isEmpty) {
      _showAlertDialog(context, 'Pemberitahuan', 'Tolong isi semua kolom');
      return;
    }

    // Lakukan registrasi
    String url =
        "${ApiConfig.baseUrl}/api/register"; // Ganti dengan URL server Anda
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'nama_lengkap': fullname,
          'username': username,
          'email': email,
          'password': password,
          'no_hp': phoneNumber,
          'alamat': address,
          'jenid_kelamin': gender,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> result = jsonDecode(response.body);

        // Simpan email ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("registered_email", email);

        // Tampilkan dialog sukses
        _showRegisteredUserDialog(context, result['user']);

        // Bersihkan field input
        _clearFields();

        // Ambil email dari SharedPreferences dan simpan ke controller email di LoginPageState
        String registeredEmail = prefs.getString('registered_email') ?? '';

        // Navigasi ke halaman login setelah registrasi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        _showSuccessRegister("Register berhasil", result['user']);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (error) {
      print('Network error: $error');
      _showAlertDialog(context, 'Error', 'Failed to register user: $error');
    }
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _showSuccessRegister(String message, Map<String, dynamic> user) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Registrasi Berhasil',
      desc:
          'Selamat datang, ${user['username']}!\nAkun Anda telah berhasil didaftarkan.',
      btnOkOnPress: () {},
    )..show();
  }

  void _showNotification(BuildContext context) {
    ScaffoldMessenger.of(context)!.showSnackBar(
      SnackBar(
        content: Text(
          'Tolong masukkan email yang sesuai',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Background color set to red
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
// kode yang digunakan untuk menyimpan ke dalam db_helper registeremail
  Future<void> _saveEmailSharedPreferences(
      String email, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('username', username);
  }

  void _showSuccessDialog(String message, User user) {
    // Implementasi dialog sukses
  }

  void _showRegisteredUserDialog(
      BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Full Name: ${user['fullname']}'),
              Text('Username: ${user['username']}'),
              Text('Email: ${user['email']}'),
              Text('no_hp: ${user['no_hp']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    fullnameController.clear();
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
    phoneController.clear();
    alamatController.clear();
    selectedGender = '';
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Daftar Akun',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: false,
      bottom: null, 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5),
                TextFormField(
                  controller: fullnameController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan nama lengkap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'nama harus diisi';
                    }
                    if (value.length < 10) {
                      return 'nama lengkap minimal 10';
                    }
                    if (!value.contains(RegExp(r'^[a-zA-Z ]+$'))) {
                      return 'Nama lengkap hanya boleh mengandung huruf dan spasi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nama akun',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama akun tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null; // Jika valid
                  },
                ),
                SizedBox(height: 10.0),
                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      !_passwordvisible, // Gunakan _passwordvisible untuk menentukan apakah teks tersembunyi atau tidak
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordvisible =
                              !_passwordvisible; // Perubahan nilai _passwordvisible ketika tombol ditekan
                        });
                      },
                      icon: Icon(
                        _passwordvisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    // Validasi panjang karakter, kekuatan password, dll.
                    return null; // Jika valid
                  },
                ),
                SizedBox(height: 10.0),
                // Confirm Password
                TextFormField(
                  controller: confirmPassController,
                  obscureText: !_passwordvisiblekonfirmasi,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordvisiblekonfirmasi =
                              !_passwordvisiblekonfirmasi; // Perubahan nilai _passwordvisible ketika tombol ditekan
                        });
                      },
                      icon: Icon(
                        _passwordvisiblekonfirmasi
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Konfirmasi password tidak cocok';
                    }
                    return null; // Jika valid
                  },
                ),
                SizedBox(height: 10.0),
                // Nomor Handphone
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Nomor Hp',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // Gender Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Kelamin',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = 'Laki-laki';
                            });
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: selectedGender == 'Laki-laki'
                                    ? Color.fromRGBO(29, 216, 163, 80)
                                    : Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text('Laki - Laki'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = 'Perempuan';
                            });
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: selectedGender == 'Perempuan'
                                    ? Color.fromRGBO(29, 216, 163, 80)
                                    : Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text('Wanita'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                // Alamat
                TextFormField(
                  maxLines: 3,
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // Tombol Register
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _autovalidateMode = AutovalidateMode.onUserInteraction;
                    });
                    _registerUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(21, 72, 173, 1),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Daftar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Kembali',
                          style: TextStyle(
                              color: const Color.fromRGBO(21, 72, 173, 1)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                        ),
                        TextSpan(
                          text: ' ke halaman login',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
