import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth/services/singup_otp.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class GetToken extends StatelessWidget {
  final Map<String, dynamic> formValues;

  const GetToken({
    Key? key,
    required this.formValues,
  }) : super(key: key);

  Future<void> sendRequest(BuildContext context, String body) async {
    final url = Uri.parse('http://13.250.14.61:8765/v1/create');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetOTP(token: data['token']),
          ),
        );
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
