class User {
  final int id;
  final String email;
  final String role;
  final Penduduk? penduduk;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.penduduk,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      penduduk: json['penduduk'] != null ? Penduduk.fromJson(json['penduduk']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'penduduk': penduduk?.toJson(),
    };
  }
}

class Penduduk {
  final String? namaLengkap;
  final String? noHp;
  final String? alamat;
  final String? jenisKelamin;
  final String? tanggalLahir;
  final String? kebangsaan;
  final String? pekerjaan;
  final String? statusNikah;
  final String? nik;

  Penduduk({
    this.namaLengkap,
    this.noHp,
    this.alamat,
    this.jenisKelamin,
    this.tanggalLahir,
    this.kebangsaan,
    this.pekerjaan,
    this.statusNikah,
    this.nik,
  });

  factory Penduduk.fromJson(Map<String, dynamic> json) {
    return Penduduk(
      namaLengkap: json['nama_lengkap'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      tanggalLahir: json['tanggal_lahir'],
      kebangsaan: json['kebangsaan'],
      pekerjaan: json['pekerjaan'],
      statusNikah: json['status_nikah'],
      nik: json['nik'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'no_hp': noHp,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir,
      'kebangsaan': kebangsaan,
      'pekerjaan': pekerjaan,
      'status_nikah': statusNikah,
      'nik': nik,
    };
  }
}
