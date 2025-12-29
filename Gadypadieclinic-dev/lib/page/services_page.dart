import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicesPage extends StatelessWidget {
  final List<Map<String, String>> services = [
    {
      'name': 'THERMAGE KOREA',
      'description': 'Unlimited Shots',
      'price1': 'Smile Lines/Under Eye',
      'price2': 'Cheek + Smile Lines',
      'price3': 'Jawline + Double Chin',
      'price4': 'Full Face + Double Chin',
      'cost1': '1,999.-',
      'cost2': '3,999.-',
      'cost3': '4,999.-',
      'cost4': '6,999.-',
      'image': 'assets/image/servicesimage1.png',
    },
    {
      'name': 'ULTRA FORMER',
      'description': 'Unlimited Shots',
      'price1': 'Smile Lines/Under Eye',
      'price2': 'Cheek + Smile Lines',
      'price3': 'Jawline + Double Chin',
      'price4': 'Full Face + Double Chin',
      'cost1': '3,999.-',
      'cost2': '6,999.-',
      'cost3': '8,999.-',
      'cost4': '10,999.-',
      'image': 'assets/image/servicesimage2.png',
    },
    {
      'name': 'FILLER',
      'description': '1 cc',
      'price1': 'Restylane',
      'price2': 'Juvederm',
      'price3': 'Belotero',
      'price4': 'e.p.t.q',
      'cost1': '14,000.-',
      'cost2': '13,000.-',
      'cost3': '12,000.-',
      'cost4': '8,999.-',
      'image': 'assets/image/servicesimage3.png',
    },
    {
      'name': 'SCULPTRA',
      'description': '1 vial = 10 cc',
      'price1': '1 vial',
      'price2': '2 vials',
      'price3': '3 vials',
      'price4': '4 vials',
      'cost1': '29,000.-',
      'cost2': '50,000.-',
      'cost3': '75,000.-',
      'cost4': '100,000.-',
      'image': 'assets/image/servicesimage4.png',
    },
    {
      'name': 'IV INJECTION',
      'description': '1 time = 100 ml',
      'price1': 'Immune Booster',
      'price2': 'Slim Booster',
      'price3': 'Power Charger',
      'price4': 'Perfect White Radiance',
      'cost1': '1,000.-',
      'cost2': '1,800.-',
      'cost3': '2,000.-',
      'cost4': '2,400.-',
      'image': 'assets/image/servicesimage5.png',
    },
    {
      'name': 'FAT BOMB',
      'description': '10 cc',
      'price1': 'Profyne Lite',
      'price2': 'Rase sisi',
      'price3': 'Neo Bella',
      'price4': 'Body sisi',
      'cost1': '999.-',
      'cost2': '1,900.-',
      'cost3': '3,500.-',
      'cost4': '1,500.-',
      'image': 'assets/image/servicesimage6.png',
    },
    {
      'name': 'BOTOX',
      'description': '100 units',
      'price1': 'Allergan',
      'price2': 'Xeomin',
      'price3': 'Aestox / Neuronox',
      'price4': 'Nabota',
      'cost1': '14,000.-',
      'cost2': '15,000.-',
      'cost3': '7,000.-',
      'cost4': '6,000.-',
      'image': 'assets/image/servicesimage7.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBE6E0),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset('assets/image/logo.png', height: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFBDB3A7), height: 2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OUR SERVICES',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE49092),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 10, left: 20, right: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                services[index]['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 370,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 12, left: 16, right: 16),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.zero,
                                child: Text(
                                  services[index]['name']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE49092),
                                  ),
                                ),
                              ),

                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  services[index]['description']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFFE49092)),
                                ),
                              ),
                              SizedBox(height: 10),

                              // รายการบริการ + ราคา
                              Column(
                                children: [
                                  _buildPriceRow(services[index]['price1']!,
                                      services[index]['cost1']!),
                                  _buildPriceRow(services[index]['price2']!,
                                      services[index]['cost2']!),
                                  _buildPriceRow(services[index]['price3']!,
                                      services[index]['cost3']!),
                                  _buildPriceRow(services[index]['price4']!,
                                      services[index]['cost4']!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF6F1EB),
        selectedItemColor: Color(0xFFE49092),
        unselectedItemColor: Color(0xFF9C9389),
        currentIndex: 3,
        onTap: (index) async {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/reviews');
              break;
            case 1:
              Navigator.pushNamed(context, '/appointment');
              break;
            case 2:
              Navigator.pushNamed(context, '/');
              break;
            case 3:
              Navigator.pushNamed(context, '/services');
              break;
            case 4:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.pushNamed(context, '/profile');
              } else {
                Navigator.pushNamed(context, '/account');
              }
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String service, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(service,
              style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFE49092),
                  fontWeight: FontWeight.bold)),
          Text(price,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE49092))),
        ],
      ),
    );
  }
}
