import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Confirm/finish_view.dart';
import 'package:image_picker/image_picker.dart';

class Photo extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String district;
  final String amphoe;
  final String province;
  final String zipcode;
  final Map<String, Object?> formValues;
  final String token;
  Photo({
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.amphoe,
    required this.province,
    required this.zipcode,
    required this.formValues,
    required this.token,
  });

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  List<File> _imageFiles = [];

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    final XFile? image = await picker.pickImage(source: media);
    if (image == null) {
      return;
    }
    Uint8List imageBytes = await image.readAsBytes();
    String _base64 = base64Encode(imageBytes);
    print(_base64);

    final imggettemppath = File(image.path);
    setState(() {
      this._imageFiles.add(imggettemppath);
    });

    print(imggettemppath);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(_imageFiles.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.file(
                  _imageFiles[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -10,
                right: -15,
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    setState(() {
                      _imageFiles.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: buildGridView()),
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('upload image'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (_imageFiles.isNotEmpty) {
                  List<String> base64List = [];
                  for (File imageFile in _imageFiles) {
                    Uint8List imageBytes = imageFile.readAsBytesSync();
                    String _base64 = base64Encode(imageBytes);
                    base64List.add(_base64);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinishScreen(
                        imageFiles: base64List,
                        latitude: widget.latitude.toString(),
                        longitude: widget.longitude.toString(),
                        district: widget.district,
                        amphoe: widget.amphoe,
                        province: widget.province,
                        zipcode: widget.zipcode,
                        formValues: widget.formValues,
                        token: widget.token,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('No image selected'),
                      content: Text('Please select at least one image.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
