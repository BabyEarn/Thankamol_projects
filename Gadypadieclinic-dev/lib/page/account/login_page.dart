import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String email = '';
  String phone = '';
  String dob = '';
  String gender = '';


@override
void initState() {
  super.initState();
  Future.delayed(Duration(milliseconds: 200), () {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/account');
    } else {
      _loadProfileData();
    }
  });
}

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/account');
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = "${data['title']} ${data['firstname']} ${data['lastname']}";
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        dob = data['dob'] != null
    ? DateFormat('dd MMMM yyyy').format(DateTime.parse(data['dob']))
    : '';
        gender = data['gender'] ?? '';
      });
    }
  }

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE49092), Color(0xFFEBE6E0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Logout Button
          Positioned(
            top: 15,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/account');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: Text("Log out", style: TextStyle(color: Color(0xFF9C9389), fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProfileRow("Name", name),
                    _buildDivider(),
                    _buildProfileRow("E-mail", email),
                    _buildDivider(),
                    _buildProfileRow("Phone number", phone),
                    _buildDivider(),
                    _buildProfileRow("Date of birth", dob),
                    _buildDivider(),
                    _buildProfileRow("Gender", gender),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF6F1EB),
        selectedItemColor: Color(0xFFE49092),
        unselectedItemColor: Color(0xFF9C9389),
        currentIndex: 4,
        onTap: (index) {
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
              Navigator.pushNamed(context, user != null ? '/profile' : '/account');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF9C9389))),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Color(0xFFBDB3A7), thickness: 1);
  }
}
