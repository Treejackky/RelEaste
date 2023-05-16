import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/admin/Home.dart';
import 'package:flutter_application_1/screen/auth/login_screen.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class GetOTP extends StatefulWidget {
  final String token;

  const GetOTP({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _GetOTPState createState() => _GetOTPState();
}

class _GetOTPState extends State<GetOTP> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> sendRequest(String body) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://13.250.14.61:8765/v1/otp');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);
        print('Received data: $data');
        if (data['token'] != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // token is null, go back to LoginScreen
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Request failed with error: $error.');
    }

    // Delay for 10 seconds and then enable the button
  }

  @override
  Widget build(BuildContext context) {
    final body = json.encode({
      'token': widget.token.toString(),
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null // button is disabled
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final otp = _otpController.text.trim();
                          final body = json.encode({
                            'token': widget.token.toString(),
                            'otp': otp,
                          });
                          sendRequest(body);
                        }

                        CircularProgressIndicator();
                      },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
