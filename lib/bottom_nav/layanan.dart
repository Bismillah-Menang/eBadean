import 'package:flutter/material.dart';

class Layanan extends StatelessWidget {
  const Layanan({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Layanan",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEDF3),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Surat',
                    hintStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                        fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 13.5,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEBF0FF),
                              child: Icon(Icons.note, color: Color(0xFF0046F8)),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SK Tidak Mampu',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEBF0FF),
                              child: Icon(Icons.business, color: Color(0xFF0046F8)),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SK Ijin Usaha',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEBF0FF),
                              child: Icon(Icons.location_on, color: Color(0xFF0046F8)),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SK Domisili Usaha',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEBF0FF),
                              child: Icon(Icons.notifications, color: Color(0xFF0046F8)),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SK Kematian',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFEBF0FF),
                              child: Icon(Icons.bedroom_baby_rounded, color: Color(0xFF0046F8)),
                            ),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SK Kelahiran',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
