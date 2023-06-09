import 'package:flutter/material.dart';
import 'screens/add/address_add.dart';
import 'screens/add/form.dart';
import 'screens/add/map_add.dart';
import 'screens/add/photo_add.dart';
import 'screens/add/property_add.dart';
import 'screens/auth/otp.dart';
import 'screens/auth/register.dart';
import 'screens/edit/profile_edit.dart';
import 'screens/login.dart';
import 'screens/api.dart';
import 'screens/detail.dart';
import 'screens/calculator.dart';
import 'screens/profile.dart';
import 'screens/home.dart';
import 'screens/serach_map.dart';

void main() {
  runApp(const MainApp());
}

Map<String, dynamic> _data = {
//api
  'fn': 'get',
  'body': {},
//items
  'index': 0,
  'items': [], //from server
//NavBar
  'nav_id': 0,
  'title': 'Home',
//profile
  'favorite': [], //from server
  'contact': '',
//admin
  'type': '',
  'lat': 0.0,
  'lng': 0.0,
};

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(
              data: _data,
            ),
        '/login': (BuildContext context) => Login(data: _data),
        '/register': (BuildContext context) => Register(data: _data),
        '/otp': (BuildContext context) => Otp(data: _data),
        '/api': (BuildContext context) => Api(data: _data),
        '/detail': (BuildContext context) => Detail(data: _data),
        '/calculator': (BuildContext context) => Calculator(),
        '/property': (BuildContext context) => Property(),
        '/address': (BuildContext context) => AddressPage(),
        '/map': (BuildContext context) => MapPage(),
        '/photo': (BuildContext context) => Photo(),
        '/form': (BuildContext context) => FormPage(data: _data),
        '/profile': (BuildContext context) => Profile(),
        '/profile_edit': (BuildContext context) => ProfileEdit(data: _data),
        '/search_map': (BuildContext context) => FilterMap(data: _data),
      },
    );
  }
}
