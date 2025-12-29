import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        backgroundColor: Color(0xFFF6F1EB),
        appBar: AppBar(
          backgroundColor: Color(0xFFEBE6E0),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'CONFIRM APPOINTMENT',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE49092)),
          ),
        ),
        body: Center(child: Text("No appointment details available.")),
      );
    }

    final String selectedLocation = args['location'] ?? 'Unknown Location';
    final String selectedCategory = args['category'] ?? 'Unknown Category';
    final String selectedService = args['service'] ?? 'Unknown Service';
    final String selectedProvider = args['provider'] ?? 'Unknown Provider';

    final DateTime selectedStartTime = DateTime.parse(args['startTime']);

    String formattedStartTime =
        DateFormat('dd-MM-yyyy HH:mm').format(selectedStartTime);

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
              'CLIENT',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE49092)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    selectedService,
                    formattedStartTime,
                    selectedProvider,
                    selectedLocation,
                    selectedCategory,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildConfirmButton(context, args),
                  ),
                ],
              ),
            ),
          ),
          _buildNavBar(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String service,
    String formattedStartTime,
    String provider,
    String location,
    String category,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildInfoRow('Date:', formattedStartTime),
          _buildInfoRow('Provider:', provider),
          _buildInfoRow('Location:', location, isLink: true, isBold: true),
          _buildInfoRow('Category:', category),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isLink = false, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isLink ? Color(0xFFE49092) : Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, Map<String, dynamic> args) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details_confirm',
          arguments: args,
        ).then((result) {
          if (result != null) {
            Future.delayed(Duration.zero, () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(
                context,
                '/appointment',
                arguments: result,
              );
            });
          }
        });
      },
      child: Container(
        width: 220,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEDDDD), Color(0xFFE49092)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Booking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
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
