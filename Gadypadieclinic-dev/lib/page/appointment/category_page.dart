import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedLocation = arguments?['location'] ?? 'Unknown Location';
    final String selectedAddress = arguments?['address'] ?? 'Unknown Address';

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
              'CATEGORY',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE49092),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No categories found.'));
                }

                final categories = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final doc = categories[index].data() as Map<String, dynamic>;

                    final title = doc['title'] ?? '';
                    final description = doc['description'] ?? '';

                    return _buildCategoryCard(
                      context,
                      selectedLocation,
                      selectedAddress,
                      title,
                      description,
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String location,
    String address,
    String category,
    String description,
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
            category,
            style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details_category',
                arguments: {
                  'category': category,
                  'description': description,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              description,
              style: TextStyle(fontSize: 15, color: Color(0xFF9C9389)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/service_selection',
                arguments: {
                  'location': location,
                  'address': address,
                  'category': category,
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
