import 'package:flutter/material.dart';
import 'page/home_page.dart';
import 'page/reviews_page.dart';
import 'page/appointment/appointment_page.dart';
import 'page/services_page.dart';
import 'page/account/login_page.dart';
import 'page/account/account_page.dart';
import 'page/account/creataccount_page.dart';
import 'page/account/forgotpassword_page.dart';
import 'page/appointment/location_page.dart';
import 'page/appointment/category_page.dart';
import 'page/appointment/service_page.dart';
import 'page/appointment/provider_page.dart';
import 'page/appointment/datetime_page.dart';
import 'page/appointment/confirm_page.dart';
import 'page/appointment/details_confirm_page.dart';
import 'page/appointment/details_category_page.dart';
import 'page/appointment/cancel_page.dart';
import 'page/appointment/details_location_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:gadypadieclinic/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();

  await initializeNotification();

  final user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(
    initialRoute: user != null ? '/profile' : '/account',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => HomePage(),
        '/reviews': (context) => ReviewsPage(),
        '/appointment': (context) => AppointmentPage(),
        '/services': (context) => ServicesPage(),
        '/account': (context) => AccountPage(),
        '/creataccount': (context) => CreateAccountPage(),
        '/profile': (context) => LoginPage(),
        '/location': (context) => LocationPage(),
        '/category': (context) => CategoryPage(),
        '/service_selection': (context) => ServicePage(),
        '/provider_selection': (context) => ProviderPage(),
        '/datetime': (context) => DateTimePage(),
        '/confirm': (context) => ConfirmPage(),
        '/details_confirm': (context) => DetailsConfirmPage(),
        '/cancel': (context) => CancelPage(),
        '/details_location': (context) => ReadmoreLocationPage(),
        '/details_category': (context) => ReadmoreCategoryPage(),
        '/passwordpage': (context) => ForgotPasswordPage(),
      },
    );
  }
}
