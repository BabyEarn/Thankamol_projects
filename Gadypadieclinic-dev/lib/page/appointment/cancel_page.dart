import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CancelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBE6E0), 
        elevation: 0, 
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10), 
          child: Image.asset('assets/image/logo.png', height: 40), 
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Color(0xFFBDB3A7), 
            height: 2, 
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,'/appointment');
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Color(0xFF9C9389)),
                    SizedBox(width: 8),
                    Text(
                      "Back to services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C9389),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "There are no appointments yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF9C9389)),
                textAlign: TextAlign.center,
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
              icon: Icon(Icons.calendar_today, size: 30),
              label: 'APPOINTMENTS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}
