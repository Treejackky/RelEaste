import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/admin/Address/Address.dart';

class RealEstateForm extends StatefulWidget {
  final String token;

  const RealEstateForm({Key? key, required this.token}) : super(key: key);

  @override
  _RealEstateFormState createState() => _RealEstateFormState();
}

class _RealEstateFormState extends State<RealEstateForm> {
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  final _formKey = GlobalKey<FormState>();

  final List<String> _propertyTypes = [
    'Apartment',
    'Condo',
    'Detached House',
    'Townhouse',
    'Land'
  ];

  final List<int> Number = [0, 1, 2, 3, 4, 5];
  String? token;
  String? _selectedPropertyType;
  int? _price;
  int? _area;
  int? _bedroom;
  int? _bathroom;
  int? _living;
  int? _kitchen;
  int? _dining;
  int? _parking;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(token.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressScreen(
            formValues: {
              'type': _selectedPropertyType,
              'price': _price,
              'area': _area,
              'bedroom': _bedroom,
              'bathroom': _bathroom,
              'living': _living,
              'kitchen': _kitchen,
              'dining': _dining,
              'parking': _parking,
              'token': token,
            },
            token: token.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Estate Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedPropertyType,
                decoration: InputDecoration(
                  labelText: 'Property type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home), // add icon
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedPropertyType = value;
                  });
                },
                items: _propertyTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a property type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money), // add icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (int.tryParse(value) == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.area_chart), // add icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an area';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _area = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of bedrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _bedroom = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of bedrooms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of bathrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bathroom), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _bathroom = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of bathrooms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of living',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.living), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _living = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of living';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of kitchens',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.kitchen), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _kitchen = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of kitchens';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of dining',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.dining), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _dining = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of dining';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Number of parking',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_parking), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _parking = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of parking';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
