import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedLocation =
        arguments?['location'] ?? 'Unknown Location';
    final String selectedAddress = arguments?['address'] ?? 'Unknown Address';
    final String selectedCategory =
        arguments?['category'] ?? 'Unknown Category';
    final String selectedService = arguments?['service'] ?? 'Unknown Service';
    final String selectedDuration =
        arguments?['duration'] ?? 'Unknown Duration';

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
              'PROVIDER',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE49092)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('providers')
                  .where('location', isEqualTo: selectedLocation)
                  .where('category', isEqualTo: selectedCategory)
                  .where('service', isEqualTo: selectedService)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No providers available.'));
                }

                final docs = snapshot.data!.docs;
                List<Map<String, dynamic>> allProviders = [];

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final providers = data['providers'] as List<dynamic>?;

                  if (providers != null) {
                    for (var p in providers) {
                      allProviders.add({
                        'name': p['name'],
                        'day': p['day'],
                      });
                    }
                  }
                }

                if (allProviders.isEmpty) {
                  return Center(child: Text('No providers found in data.'));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  itemCount: allProviders.length,
                  itemBuilder: (context, index) {
                    final provider = allProviders[index];

                    return _buildProviderCard(
                      context,
                      selectedLocation,
                      selectedAddress,
                      selectedCategory,
                      selectedService,
                      selectedDuration,
                      provider['name'] ?? 'Unknown',
                      provider['day'] ?? 'Unknown',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildProviderCard(
    BuildContext context,
    String location,
    String address,
    String category,
    String service,
    String duration,
    String doctorName,
    String day,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
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
            '$doctorName ($day)',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              print('🚀 Navigating to DateTimePage');
              print('🩺 provider: $doctorName, day: $day, duration: $duration');

              Navigator.pushNamed(
                context,
                '/datetime',
                arguments: {
                  'location': location,
                  'address': address,
                  'category': category,
                  'service': service,
                  'duration': duration,
                  'provider': doctorName,
                  'day': day,
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
        BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 30), label: 'APPOINTMENTS'),
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35), label: 'HOME'),
        BottomNavigationBarItem(
            icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
      ],
    );
  }
}
