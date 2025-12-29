import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsConfirmPage extends StatefulWidget {
  @override
  _DetailsConfirmPageState createState() => _DetailsConfirmPageState();
}

class _DetailsConfirmPageState extends State<DetailsConfirmPage> {
  late Map<String, dynamic> args;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final rawArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (rawArgs != null) {
        args = rawArgs;
        _sendEmail();
      }
    });
  }

  Future<void> _sendEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = user.displayName ?? "Unknown";
    final email = user.email ?? "no-email@example.com";
    final service = args['service'];
    final location = args['location'];

    final DateTime startTime = DateTime.parse(args['startTime']);
    final formattedTime = "${startTime.day}-${startTime.month}-${startTime.year} "
        "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";

    await sendEmailJS(
      name: name,
      email: email,
      service: service,
      location: location,
      time: formattedTime,
    );
  }

  Future<void> sendEmailJS({
    required String name,
    required String email,
    required String service,
    required String location,
    required String time,
  }) async {
    const serviceId = 'service_n2gsqsp';
    const templateId = 'template_ou6x73l';
    const userId = 'sbNy48btJ8FYDlOI5';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'service': service,
          'location': location,
          'time': time,
        }
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Email sent successfully!');
    } else {
      print('❌ Failed to send email: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};

    if (args.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFFF6F1EB),
        body: Center(child: Text("No appointment details available.")),
      );
    }

    DateTime startTime = DateTime.parse(args['startTime']);
    DateTime endTime = DateTime.parse(args['endTime']);

    String formattedDate =
        "${startTime.day}-${startTime.month}-${startTime.year} ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";
    String formattedEndTime =
        "${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}";

    Map<String, dynamic> appointmentData = {
      'service': args['service'],
      'date': formattedDate,
      'startTime': args['startTime'],
      'endTime': args['endTime'],
      'provider': args['provider'],
      'location': args['location'],
      'category': args['category'],
      'status': 'Confirmed',
    };

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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildInfoCard(context, args, formattedDate, formattedEndTime),
            SizedBox(height: 20),
            _buildShowBookingsButton(context, appointmentData),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(context),
    );
  }

  Widget _buildInfoCard(BuildContext context, Map<String, dynamic> args,
      String formattedDate, String formattedEndTime) {
    return Container(
      width: double.infinity,
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
          Text(args['service'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildInfoRow('Date:', formattedDate),
          _buildInfoRow('Ends at:', formattedEndTime),
          _buildInfoRow('Provider:', args['provider'] ?? 'N/A'),
          _buildInfoRow('Location:', args['location'] ?? 'N/A', isLink: true,isBold: true),
          _buildInfoRow('Category:', args['category'] ?? 'N/A'),
          _buildInfoRow('Status:', 'Confirmed', isBold: true),
          SizedBox(height: 20),
          _buildCancelButton(context),
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
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
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

  Widget _buildCancelButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/cancel');
        },
        child: Container(
          width: 130,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF9C9389),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.block,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowBookingsButton(
      BuildContext context, Map<String, dynamic> appointmentData) {
    if (appointmentData['startTime'] == null) {
      return Text("Error: startTime is missing"); 
    }

    DateTime startTime = DateTime.parse(appointmentData['startTime']);

    String formattedDate =
        "${startTime.day}-${startTime.month}-${startTime.year} ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          appointmentData['date'] = formattedDate;
          Navigator.pop(context, appointmentData);
        },
        child: Container(
          width: 169,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF9C9389), width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 14),
          child: Text(
            'Show all bookings',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9C9389)),
          ),
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
