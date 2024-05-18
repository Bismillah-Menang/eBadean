import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 85.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        fontSize: 14,
                      ),
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return RiwayatItem();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RiwayatItem extends StatefulWidget {
  const RiwayatItem({Key? key}) : super(key: key);

  @override
  _RiwayatItemState createState() => _RiwayatItemState();
}

class _RiwayatItemState extends State<RiwayatItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
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
                            SizedBox(height: 15.0),
                            Row(
                              children: [
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
                              ],
                            ),
                            Center(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: _isExpanded ? 75.0 : 75.0,
                                  child: Icon(
                                    _isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 24.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isExpanded) ProsesPengajuan(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProsesPengajuan extends StatelessWidget {
  const ProsesPengajuan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xFFEEEDF3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proses Pengajuan',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIndicator('Dibaca', true),
                  _buildLine(),
                  _buildIndicator('Ditolak', false),
                  _buildLine(),
                  _buildIndicator('Disetujui', false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(String label, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22.0,
          height: 22.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? _getColorForIndicator(label) : Colors.grey,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      width: 60.0,
      height: 2.0,
      color: Colors.grey[500],
    );
  }

  Color _getColorForIndicator(String label) {
    switch (label) {
      case 'Dibaca':
        return Color(0xFF1548AD);
      case 'Ditolak':
        return Colors.red;
      case 'Disetujui':
        return Color.fromRGBO(29, 216, 163, 1);
      default:
        return Colors.grey;
    }
  }
}
