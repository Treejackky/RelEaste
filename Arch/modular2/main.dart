import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/address/views/address_screen.dart';

class MyController extends GetxController {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("Go to next screen"),
            onPressed: () => Get.to(AddressScreen()),
          ),
        ),
      ),
    );
  }
}
