import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBE6E0),
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/image/logo.png', height: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFBDB3A7), height: 2),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF9C9389)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              'LOCATION',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE49092),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('locations')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No locations found.'));
                }

                final locations = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final loc = locations[index].data() as Map<String, dynamic>;
                    return _buildLocationCard(
                      context,
                      loc['title'] ?? '',
                      loc['address'] ?? '',
                      loc['details'] ?? '',
                      loc['lat'] ?? 0.0,
                      loc['lng'] ?? 0.0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF6F1EB),
        selectedItemColor: Color(0xFFE49092),
        unselectedItemColor: Color(0xFF9C9389),
        currentIndex: 1,
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
              Navigator.pushNamed(
                  context, user != null ? '/profile' : '/account');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, String title, String address,
      String details, double lat, double lng) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details_location',
                arguments: {
                  'title': title,
                  'address': address,
                  'details': details.replaceAll(r'\n', '\n'),
                  'lat': lat,
                  'lng': lng,
                },
              );
            },
            child: Text(
              'read more',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFE49092),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Color(0xFF9C9389), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch maps for: $address';
                    }
                  },
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFE49092),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/category',
                arguments: {
                  'location': title,
                  'address': address,
                },
              );
            },
            child: Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFEEDDDD), Color(0xFFE49092)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              alignment: Alignment.center,
              child: Text(
                'Select',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
