import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadypadieclinic/notification_service.dart';

class DateTimePage extends StatefulWidget {
  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime? _selectedTime;
  int _serviceDuration = 0;

  final currentUser = FirebaseAuth.instance.currentUser;
  String get uid => currentUser?.uid ?? 'unknown';

  Future<List<Map<String, dynamic>>> loadBookings(String provider) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('provider', isEqualTo: provider)
        .get();

    final bookings = snapshot.docs
        .map((doc) => doc.data())
        .where((booking) => booking['startTime'] != null)
        .toList();

    print("\n📦 ${bookings.length} bookings loaded for $provider");
    for (var b in bookings) {
      print("→ ${b['startTime']} → ${b['endTime']}");
    }

    return bookings;
  }

  List<Map<String, DateTime>> getBookedSlotsForDay(
      DateTime date, List<Map<String, dynamic>> allBookings) {
    return allBookings
        .where((booking) {
          try {
            final start = DateTime.parse(booking['startTime']);
            return start.year == date.year &&
                start.month == date.month &&
                start.day == date.day;
          } catch (e) {
            return false;
          }
        })
        .map((booking) {
          try {
            final start = DateTime.parse(booking['startTime']);
            final end = DateTime.parse(booking['endTime']);
            return {
              'start': start,
              'end': end,
            };
          } catch (e) {
            return null;
          }
        })
        .whereType<Map<String, DateTime>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String selectedLocation = arguments?['location'] ?? 'Unknown';
    final String selectedAddress = arguments?['address'] ?? 'Unknown';
    final String selectedCategory = arguments?['category'] ?? 'Unknown';
    final String selectedService = arguments?['service'] ?? 'Unknown';
    final String selectedProvider = arguments?['provider'] ?? 'Unknown';
    final String selectedDayName = arguments?['day'] ?? 'Monday';

    _serviceDuration =
        int.tryParse(arguments?['duration']?.split(' ')?.first ?? '0') ?? 0;

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DATE & TIME',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE49092))),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildCalendar(selectedDayName),
                  SizedBox(height: 20),
                  _buildTimeSelection(selectedProvider),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (_selectedTime != null) {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) {
                      print("❌ No user logged in");
                      return;
                    }

                    DateTime endTime =
                        _selectedTime!.add(Duration(minutes: _serviceDuration));

                    await FirebaseFirestore.instance.collection('booking').add({
                      'userId': uid,
                      'location': selectedLocation,
                      'address': selectedAddress,
                      'category': selectedCategory,
                      'service': selectedService,
                      'provider': selectedProvider,
                      'day': selectedDayName,
                      'startTime': _selectedTime!.toIso8601String(),
                      'endTime': endTime.toIso8601String(),
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    final now = DateTime.now();
                    final appointmentTime = _selectedTime!;
                    final notify1DayBefore =
                        appointmentTime.subtract(Duration(days: 1));
                    final notify2HoursBefore =
                        appointmentTime.subtract(Duration(hours: 2));

                    final title = "Upcoming Appointment Reminder";
                    final body =
                        "You have an appointment for ${selectedService} at ${selectedLocation}";

                    if (notify1DayBefore.isAfter(now)) {
                      await scheduleNotification(
                        id: appointmentTime.millisecondsSinceEpoch ~/ 1000,
                        title: title,
                        body: "$body in 1 day",
                        scheduleTime: notify1DayBefore,
                      );
                    }

                    if (notify2HoursBefore.isAfter(now)) {
                      await scheduleNotification(
                        id: (appointmentTime.millisecondsSinceEpoch ~/ 1000) +
                            1,
                        title: title,
                        body: "$body in 2 hours",
                        scheduleTime: notify2HoursBefore,
                      );
                    }

                    Navigator.pushNamed(
                      context,
                      '/confirm',
                      arguments: {
                        'location': selectedLocation,
                        'address': selectedAddress,
                        'category': selectedCategory,
                        'service': selectedService,
                        'provider': selectedProvider,
                        'day': selectedDayName,
                        'startTime': _selectedTime!.toIso8601String(),
                        'endTime': endTime.toIso8601String(),
                      },
                    );
                  }
                },
                child: Container(
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEEDDDD), Color(0xFFE49092)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text('Next',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 10),
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
              Navigator.pushNamed(
                  context, user != null ? '/profile' : '/account');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.rate_review_outlined), label: 'REVIEWS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'APPOINTMENTS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ballot_rounded), label: 'SERVICES'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildCalendar(String availableDay) {
    final allowedWeekday = _getWeekdayIndex(availableDay);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: EdgeInsets.all(16),
      child: TableCalendar(
        focusedDay: _selectedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        enabledDayPredicate: (day) {
          final isCorrectWeekday = day.weekday == allowedWeekday;
          return day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
              isCorrectWeekday;
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() => _selectedDay = selectedDay);
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C9389)),
          leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFFE49092)),
          rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFFE49092)),
        ),
        daysOfWeekStyle:
            DaysOfWeekStyle(weekendStyle: TextStyle(color: Color(0xFFE49092))),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEEDDDD), Color(0xFFE49092)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: BoxShape.circle,
          ),
          todayDecoration:
              BoxDecoration(color: Color(0xFFEEDDDD), shape: BoxShape.circle),
          disabledTextStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTimeSelection(String selectedProvider) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadBookings(selectedProvider),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final bookedSlots = getBookedSlotsForDay(_selectedDay, snapshot.data!);

        List<String> timeSlots = [];
        DateTime startTime = DateTime(0, 0, 0, 10, 0);
        DateTime endTime = DateTime(0, 0, 0, 18, 0);

        while (startTime.isBefore(endTime)) {
          final candidateStart = DateTime(
            _selectedDay.year,
            _selectedDay.month,
            _selectedDay.day,
            startTime.hour,
            startTime.minute,
          );

          final candidateEnd =
              candidateStart.add(Duration(minutes: _serviceDuration));

          bool isOverlap =
              isOverlapping(candidateStart, _serviceDuration, bookedSlots);

          // เพิ่มให้หมอพักกลางวัน 12:00–13:00
          bool isDuringLunchBreak =
              candidateStart.hour >= 12 && candidateStart.hour < 13;

          if (!isOverlap &&
              !isDuringLunchBreak &&
              candidateEnd.isBefore(DateTime(
                _selectedDay.year,
                _selectedDay.month,
                _selectedDay.day,
                endTime.hour,
                endTime.minute,
              ))) {
            timeSlots.add(DateFormat('HH:mm').format(candidateStart));
          }

          startTime = startTime.add(Duration(minutes: 10));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available start times',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C9389))),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((time) {
                final slotTime = DateTime(
                  _selectedDay.year,
                  _selectedDay.month,
                  _selectedDay.day,
                  int.parse(time.split(':')[0]),
                  int.parse(time.split(':')[1]),
                );

                bool isSelected = _selectedTime != null &&
                    DateFormat('HH:mm').format(_selectedTime!) == time;

                return GestureDetector(
                  onTap: () {
                    print('✅ Selected time: $slotTime');
                    setState(() => _selectedTime = slotTime);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFE49092) : Colors.white,
                      border: Border.all(color: Color(0xFFE49092), width: 1.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Color(0xFFE49092)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  int _getWeekdayIndex(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        return 1;
    }
  }

  bool isOverlapping(DateTime slot, int durationInMin,
      List<Map<String, DateTime>> bookedSlots) {
    final slotEnd = slot.add(Duration(minutes: durationInMin));
    for (var booked in bookedSlots) {
      final start = booked['start']!;
      final end = booked['end']!;

      final isOverlap = slot.isBefore(end) && slotEnd.isAfter(start);
      if (isOverlap) {
        print('⛔ OVERLAP: $slot ~ $slotEnd กับ $start - $end');
        return true;
      }
    }
    return false;
  }
}
