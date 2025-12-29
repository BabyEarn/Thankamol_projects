import 'package:flutter/material.dart';

class ReadmoreCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String category = args?['category'] ?? 'Unknown Category';

    final details = _getDetailsForCategory(category);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CATEGORY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE49092),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE49092), Color(0xFFEBE6E0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          ...details
                              .map((detail) => _buildItem(detail))
                              .toList(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.white, size: 26),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF6F1EB),
        selectedItemColor: Color(0xFFE49092),
        unselectedItemColor: Color(0xFF9C9389),
        currentIndex: 3,
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
              Navigator.pushNamed(context, '/account');
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

  Widget _buildItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            padding: EdgeInsets.all(9),
            child: Image.asset(item['icon']!, fit: BoxFit.contain),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Text(item['desc']!, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getDetailsForCategory(String category) {
    switch (category) {
      case 'Thermage (Korea)':
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Procedure Time',
            'desc': '10–30 minutes',
          },
          {
            'icon': 'assets/image/6.png',
            'title': 'Main purpose',
            'desc': 'Tightens, smooths and contours skin',
          },
          {
            'icon': 'assets/image/5.png',
            'title': 'Numbing Cream',
            'desc': '40–60 minutes',
          },
          {
            'icon': 'assets/image/4.png',
            'title': 'Face wash & make up ',
            'desc': 'Right after',
          },
          {
            'icon': 'assets/image/7.png',
            'title': 'Downtime',
            'desc': 'None',
          },
          {
            'icon': 'assets/image/8.png',
            'title': 'Final results',
            'desc': 'After 2–3 months',
          },
        ];

      case 'Ultraformer':
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Procedure Time',
            'desc': '20–45 minutes',
          },
          {
            'icon': 'assets/image/6.png',
            'title': 'Main purpose',
            'desc': 'Stimulates collagen and tightens skin',
          },
          {
            'icon': 'assets/image/5.png',
            'title': 'Numbing Cream',
            'desc': '30–50 minutes',
          },
          {
            'icon': 'assets/image/4.png',
            'title': 'Face wash & make up',
            'desc': 'Right after',
          },
          {
            'icon': 'assets/image/7.png',
            'title': 'Downtime',
            'desc': 'Minimal (1–2 days redness)',
          },
          {
            'icon': 'assets/image/8.png',
            'title': 'Final results',
            'desc': 'After 1–2 months',
          },
        ];

      case 'Filler / Sculptra':
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Procedure Time',
            'desc': '15–30 minutes',
          },
          {
            'icon': 'assets/image/6.png',
            'title': 'Main purpose',
            'desc': 'Add volume and smooth fine lines',
          },
          {
            'icon': 'assets/image/5.png',
            'title': 'Numbing Cream',
            'desc': 'Optional (15 mins)',
          },
          {
            'icon': 'assets/image/4.png',
            'title': 'Face wash & make up',
            'desc': 'Next day',
          },
          {
            'icon': 'assets/image/7.png',
            'title': 'Downtime',
            'desc': 'Slight swelling (1–2 days)',
          },
          {
            'icon': 'assets/image/8.png',
            'title': 'Final results',
            'desc': 'Instant to 1 month',
          },
        ];

      case 'IV Injection':
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Procedure Time',
            'desc': '30–45 minutes',
          },
          {
            'icon': 'assets/image/6.png',
            'title': 'Main purpose',
            'desc': 'Boost energy and skin brightness',
          },
          {
            'icon': 'assets/image/5.png',
            'title': 'Numbing Cream',
            'desc': 'Not needed',
          },
          {
            'icon': 'assets/image/4.png',
            'title': 'Face wash & make up',
            'desc': 'Immediately',
          },
          {
            'icon': 'assets/image/7.png',
            'title': 'Downtime',
            'desc': 'None',
          },
          {
            'icon': 'assets/image/8.png',
            'title': 'Final results',
            'desc': 'After several sessions',
          },
        ];

      case 'Fat Bomb / Botox':
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Procedure Time',
            'desc': '10–20 minutes',
          },
          {
            'icon': 'assets/image/6.png',
            'title': 'Main purpose',
            'desc': 'Reduce fat or muscle movement (wrinkles)',
          },
          {
            'icon': 'assets/image/5.png',
            'title': 'Numbing Cream',
            'desc': 'Optional (20 mins)',
          },
          {
            'icon': 'assets/image/4.png',
            'title': 'Face wash & make up',
            'desc': 'Same day',
          },
          {
            'icon': 'assets/image/7.png',
            'title': 'Downtime',
            'desc': 'Minimal (redness or bruising)',
          },
          {
            'icon': 'assets/image/8.png',
            'title': 'Final results',
            'desc': 'Within 7–14 days',
          },
        ];

      default:
        return [
          {
            'icon': 'assets/image/3.png',
            'title': 'Coming Soon',
            'desc': 'This category is under update.',
          },
        ];
    }
  }
}
