import 'package:flutter/services.dart';
import 'dart:convert';

import '../model/JsonData.dart';

class JsonService {
  Future<List<AddressData>> getAddressData() async {
    final data = await rootBundle.loadString('assets/address.json');
    var jsonData = json.decode(data) as List;
    return jsonData.map((e) => AddressData.fromJson(e)).toList();
  }

  List<AddressData> filterAddressDataByZipcode(
      List<AddressData> fetchedData, String input) {
    List<AddressData> filteredData = [];

    for (var data in fetchedData) {
      if (data.getZipcode() != null && data.getZipcode()!.contains(input)) {
        filteredData.add(data);
      }
    }

    return filteredData;
  }
}
