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
      email: json['email'],
      role: json['role'],
      penduduk: json['penduduk'] != null ? Penduduk.fromJson(json['penduduk']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      if (penduduk != null) 'penduduk': penduduk!.toJson(),
    };
  }
}

class Penduduk {
  final int id;
  final int idUser;
  final String? namaLengkap;
  final String? noHp;
  final String? alamat;
  final String? jenisKelamin;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? kebangsaan;
  final String? pekerjaan;
  final String? nik;
  final String? agama;
  final String? fotoProfil;
  final String? fotoKk;
  final String? fotoKtp;

  Penduduk({
    required this.id,
    required this.idUser,
    this.namaLengkap,
    this.noHp,
    this.alamat,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.kebangsaan,
    this.pekerjaan,
    this.nik,
    this.agama,
    this.fotoKk, 
    this.fotoProfil, 
    this.fotoKtp, 
  });

  factory Penduduk.fromJson(Map<String, dynamic> json) {
    return Penduduk(
      id: json['id'],
      idUser: json['id_user'],
      namaLengkap: json['nama_lengkap'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      kebangsaan: json['kebangsaan'],
      pekerjaan: json['pekerjaan'],
      nik: json['nik'],
      agama: json['agama'],
      fotoKk: json['foto_kk'], 
      fotoProfil: json['foto_profil'], 
      fotoKtp: json['foto_ktp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'nama_lengkap': namaLengkap,
      'no_hp': noHp,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'kebangsaan': kebangsaan,
      'pekerjaan': pekerjaan,
      'nik': nik,
      'agama': agama,
      'foto_kk': fotoKk,
      'foto_profil': fotoProfil,
      'foto_ktp': fotoKtp,
    };
  }
}
