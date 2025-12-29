import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedLocation = arguments?['location'] ?? 'Unknown Location';
    final String selectedAddress = arguments?['address'] ?? 'Unknown Address';
    final String selectedCategory = arguments?['category'] ?? 'Unknown Category';

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
              'SERVICE',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE49092)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('services')
                  .where('location', isEqualTo: selectedLocation)
                  .where('category', isEqualTo: selectedCategory)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No services available for this category.'));
                }

                final services = snapshot.data!.docs;
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: services.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildServiceCard(
                      context,
                      selectedLocation,
                      selectedAddress,
                      selectedCategory,
                      data['name'] ?? '',
                      data['duration'] ?? '',
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String location,
    String address,
    String category,
    String serviceName,
    String duration,
  ) {
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
            serviceName,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            duration,
            style: TextStyle(fontSize: 14, color: Color(0xFF9C9389)),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/provider_selection',
                arguments: {
                  'location': location,
                  'address': address,
                  'category': category,
                  'service': serviceName,
                  'duration': duration,
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
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              alignment: Alignment.center,
              child: Text(
                'Select',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return BottomNavigationBar(
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
              if (user != null) {
                Navigator.pushNamed(context, '/profile');
              } else {
                Navigator.pushNamed(context, '/account');
              }
              break;
          }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 30), label: 'APPOINTMENTS'),
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
      ],
    );
  }
}
