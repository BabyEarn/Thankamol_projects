import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadmoreLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String title = args?['title'] ?? 'Unknown';
    final String address = args?['address'] ?? 'Unknown';
    final String details = args?['details'] ?? '';
    final double lat = args?['lat'] ?? 13.743877;
    final double lng = args?['lng'] ?? 100.533834;

    final String mapUrl =
        'https://www.openstreetmap.org/export/embed.html?bbox=${lng - 0.0015},${lat - 0.001},${lng + 0.0015},${lat + 0.001}&layer=mapnik&marker=$lat,$lng';

    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LOCATION',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE49092)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: 250,
                                  child: WebView(
                                    initialUrl: mapUrl,
                                    javascriptMode: JavascriptMode.unrestricted,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'GadyPadie Clinic, $title ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE49092),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                details,
                                style: TextStyle(fontSize: 15, height: 1.5),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(googleMapsUrl);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    } else {
                                      throw 'Could not launch Google Maps';
                                    }
                                  },
                                  child: Text(
                                        address,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFE49092),
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 10),
                              
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(Icons.close, size: 24, color: Colors.grey[800]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
        
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 30), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}
