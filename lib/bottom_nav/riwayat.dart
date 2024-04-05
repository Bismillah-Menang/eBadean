import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 20.0,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Text(
                "Riwayat",
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
                  hintText: 'Cari Riwayat',
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
                                Row(children: [
                                  Text(
                                    '14 Januari 2023',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Diterima',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Color(0xFF1DD8A3),
                                    ),
                                  ),
                                ]),
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
                                Row(children: [
                                  Text(
                                    '14 Januari 2023',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Diterima',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Color(0xFF1DD8A3),
                                    ),
                                  ),
                                ]),
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
                                Row(children: [
                                  Text(
                                    '15 Januari 2023',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Ditolak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Color(0xFFF91414),
                                    ),
                                  ),
                                ]),
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
                                Row(children: [
                                  Text(
                                    '15 Januari 2023',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Ditolak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      color: Color(0xFFF91414),
                                    ),
                                  ),
                                ]),
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
          ]),
        ),
      ),
    );
  }
}
