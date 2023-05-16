import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/admin/Home.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import 'package:http/http.dart' as http;

class GetToken extends StatelessWidget {
  final Map<String, dynamic> formValues;

  const GetToken({
    Key? key,
    required this.formValues,
  }) : super(key: key);

  Future<void> sendRequest(BuildContext context, String body) async {
    final url = Uri.parse('http://13.250.14.61:8765/v1/login');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(token: data['token']),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // token is null, go back to LoginScreen
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Error'),
              content: Text('Email or password incorrect'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          );
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Request failed with error: $error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = json.encode({
      'email': formValues['email']?.text,
      'password': formValues['password']?.text,
    });

    // Send the request and navigate to the home screen
    sendRequest(context, body);

    // Return a loading indicator while waiting for the response
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
