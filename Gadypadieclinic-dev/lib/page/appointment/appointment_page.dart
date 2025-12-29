import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool isUpcomingSelected = true;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        await _addBookingToFirestore(args);
      }
      await _loadBookingDataFromFirestore();
    });
  }

  Future<void> _addBookingToFirestore(Map<String, dynamic> booking) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('appointments').add({
      ...booking,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> _loadBookingDataFromFirestore() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection('appointments')
      .where('uid', isEqualTo: uid)
      .orderBy('startTime')
      .get();

  final loaded = snapshot.docs
      .map((doc) => {
            ...doc.data(),
            'docId': doc.id, 
          })
      .toList();

  setState(() {
    bookings = loaded;
  });
}


Future<void> _deleteBooking(Map<String, dynamic> booking) async {
  if (booking['docId'] != null) {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(booking['docId'])
        .delete();

    await _loadBookingDataFromFirestore();
  }
}


  DateTime _parseDateTime(String dateStr) {
    final parts = dateStr.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    return DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
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
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/image/logo.png', height: 40),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(color: Color(0xFFBDB3A7), height: 2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFFEBE6E0),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xFFBDB3A7), width: 1.5),
              ),
              child: Row(
                children: [
                  _buildToggleButton('UPCOMING', true),
                  _buildToggleButton('PREVIOUS', false),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/location');
                  if (result != null && result is Map<String, dynamic>) {
                    await _addBookingToFirestore(result);
                    await _loadBookingDataFromFirestore();
                  }
                },
                child: _buildButton('BOOK NOW'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: bookings.isNotEmpty
                  ? ListView(
                      children: bookings
                          .map((booking) => _buildAppointmentCard(booking))
                          .toList(),
                    )
                  : Center(child: Text("No appointments yet.")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> booking) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15), 
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking['service'] ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoRow('Date:', booking['date'] ?? 'N/A'),
          _buildInfoRow('Ends at:', booking['endTime'] != null ? DateFormat('HH:mm').format(DateTime.parse(booking['endTime'])) : 'N/A'),
          _buildInfoRow('Provider:', booking['provider'] ?? 'N/A'),
          _buildInfoRow('Location:', booking['location'] ?? 'N/A',isLink: true, isBold: true),
          _buildInfoRow('Category:', booking['category'] ?? 'N/A'),
          _buildInfoRow('Status:', booking['status'] ?? 'N/A', isBold: true),
          SizedBox(height: 15),
          Center(
            child: ElevatedButton(
              onPressed: () => _deleteBooking(booking),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C9389),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.block, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLink = false, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isLink ? Color(0xFFE49092) : Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isUpcoming) {
    bool isSelected = (isUpcoming == isUpcomingSelected);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isUpcomingSelected = isUpcoming),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFE49092) : Color(0xFFF6F1EB),
            borderRadius: BorderRadius.horizontal(
              left: isUpcoming ? Radius.circular(30) : Radius.zero,
              right: !isUpcoming ? Radius.circular(30) : Radius.zero,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Color(0xFFE49092),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      width: 200,
      height: 50,
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
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFF6F1EB),
      selectedItemColor: Color(0xFFE49092),
      unselectedItemColor: Color(0xFF9C9389),
      currentIndex: 1,
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
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 30), label: 'APPOINTMENTS'),
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
      ],
    );
  }
}
