import 'package:flutter/material.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/signup_screen.dart';
import 'screen/admin/ReI/Item.dart';
import 'screen/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "my app",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/logout': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(
              token: '',
            ),
        '/item': (context) => RealEstateForm(
              token: '',
            ),
      },
    );
  }
}
