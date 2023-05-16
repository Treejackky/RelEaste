import 'package:flutter/material.dart';
import '../Address/model/JsonData.dart';
import '../Address/services/json_services.dart';
import '../Map/MapScreen.dart';

class AddressScreen extends StatefulWidget {
  final Map<String, Object?> formValues;
  final String token;

  const AddressScreen({
    Key? key,
    required this.formValues,
    required this.token,
  }) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<AddressData> _data = [];
  List<AddressData> _filteredData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Enter zipcode',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (input) async {
                if (input.isNotEmpty) {
                  List<AddressData> fetchedData =
                      await JsonService().getAddressData();
                  List<AddressData> filteredData = JsonService()
                      .filterAddressDataByZipcode(fetchedData, input);
                  setState(() {
                    _data = fetchedData;
                    _filteredData = filteredData;
                  });
                } else {
                  setState(() {
                    _data = [];
                    _filteredData = [];
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                AddressData data = _filteredData[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Address Details'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('District: ${data.district}'),
                            Text('Amphoe: ${data.amphoe}'),
                            Text('Province: ${data.province}'),
                            Text('Zipcode: ${data.zipcode}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    district: data.district!,
                                    amphoe: data.amphoe!,
                                    province: data.province!,
                                    zipcode: data.zipcode!,
                                    formValues: widget.formValues,
                                    token: widget.token,
                                  ),
                                ),
                              );
                            },
                            child: Text('Pin Map'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(data.getDistrict()!),
                    subtitle:
                        Text('${data.getAmphoe()}, ${data.getProvince()}'),
                    trailing: Text(data.getZipcode()!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
