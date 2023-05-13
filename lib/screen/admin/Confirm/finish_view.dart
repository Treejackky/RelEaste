import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Home.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class FinishScreen extends StatelessWidget {
  final List<String> imageFiles;
  final String latitude;
  final String longitude;
  final String district;
  final String amphoe;
  final String province;
  final String zipcode;
  final Map<String, Object?> formValues;
  final String token;

  const FinishScreen({
    Key? key,
    required this.imageFiles,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.amphoe,
    required this.province,
    required this.zipcode,
    required this.formValues,
    required this.token,
  }) : super(key: key);

  Future<void> sendRequest(String body) async {
    final url = Uri.parse('http://13.250.14.61:8765/v1/add');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);
        print('Received data: $data');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Request failed with error: $error.');
    }
  }

  void buildUI(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => HomeScreen(
                token: '',
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = json.encode({
      'img': imageFiles,
      'lat': latitude,
      'lng': longitude,
      'district': district,
      'amphoe': amphoe,
      'province': province,
      'zipcode': zipcode,
      'type': formValues['type'],
      "price": formValues['price'],
      "area": formValues['area'],
      "bedroom": formValues['bedroom'],
      "bathroom": formValues['bathroom'],
      "living": formValues['living'],
      "kitchen": formValues['kitchen'],
      "dining": formValues['dining'],
      "parking": formValues['parking'],
      "token": token,
    });

    print('Sending data: $body');
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                return Image.memory(
                  base64Decode(imageFiles[index]),
                  width: 100,
                  height: 100,
                );
              },
            ),
            Text(
              'latitude File: $latitude                  longitude File: $longitude',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'district: $district ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'amphoe: $amphoe ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'province: $province ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'zipcode: $zipcode ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Type: ${formValues['type']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Price: ${formValues['price']} ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Area: ${formValues['area']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Bedroom: ${formValues['bedroom']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Bathroom: ${formValues['bathroom']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Living: ${formValues['living']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Kitchen: ${formValues['kitchen']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Dining: ${formValues['dining']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Parking: ${formValues['parking']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Toeken: ${formValues['token']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                sendRequest(body);
                buildUI(context);
              },
              child: Text('Accept'),
            ),
          ],
        ),
      ),
    );
  }
}
