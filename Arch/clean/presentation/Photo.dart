// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import '../Confirm/finish_view.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../data/Data.dart';
// import '../ReI/Item.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

// class Photo extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String district;
//   final String amphoe;
//   final String province;
//   final String zipcode;
//   final Map<String, Object?> formValues;
//   Photo({
//     required this.latitude,
//     required this.longitude,
//     required this.district,
//     required this.amphoe,
//     required this.province,
//     required this.zipcode,
//     required this.formValues,
//   });

//   @override
//   _PhotoState createState() => _PhotoState();
// }

// class _PhotoState extends State<Photo> {
//   File? _imageFile;
//   String? value;

//   final ImagePicker picker = ImagePicker();

//   //we can upload image from camera or from gallery based on parameter
//   //COVERT TO BASE64
//   Future getImage(ImageSource media) async {
//     final XFile? image = await picker.pickImage(source: media);
//     if (image == null) {
//       return;
//     }
//     Uint8List imageBytes = await image.readAsBytes();
//     String _base64 = base64Encode(imageBytes);
//     print(_base64);

//     final imggettemppath = File(image.path);
//     setState(() {
//       this._imageFile = imggettemppath;
//     });

//     print(imggettemppath);
//   }

//   //show popup dialog
//   // void myAlert() {
//   //   showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           shape:
//   //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//   //           title: Text('Please choose media to select'),
//   //           content: Container(
//   //             height: MediaQuery.of(context).size.height / 6,
//   //             child: Column(
//   //               children: [
//   //                 ElevatedButton(
//   //                   //if user click this button, user can upload image from gallery
//   //                   onPressed: () {
//   //                     Navigator.pop(context);
//   //                     getImage(ImageSource.gallery);
//   //                   },
//   //                   child: Row(
//   //                     children: [
//   //                       Icon(Icons.image),
//   //                       Text('From Gallery'),
//   //                     ],
//   //                   ),
//   //                 ),
//   //                 ElevatedButton(
//   //                   //if user click this button. user can upload image from camera
//   //                   onPressed: () {
//   //                     Navigator.pop(context);
//   //                     getImage(ImageSource.camera);
//   //                   },
//   //                   child: Row(
//   //                     children: [
//   //                       Icon(Icons.camera),
//   //                       Text('From Camera'),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         );
//   //       });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take Photo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             _imageFile != null
//                 ? Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         //to show image, you type like this.
//                         File(_imageFile!.path),
//                         fit: BoxFit.cover,
//                         width: MediaQuery.of(context).size.width,
//                         height: 400,
//                       ),
//                     ),
//                   )
//                 //make to box to show text
//                 : Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'No image selected',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                     ),
//                   ),
//             ElevatedButton(
//               onPressed: () {
//                 myAlert();
//               },
//               child: Text('Upload Photo'),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_imageFile != null) {
//                   Uint8List imageBytes = _imageFile!.readAsBytesSync();
//                   String _base64 = base64Encode(imageBytes);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FinishScreen(
//                         imageFile: _base64,
//                         latitude: widget.latitude.toString(),
//                         longitude: widget.longitude.toString(),
//                         district: widget.district,
//                         amphoe: widget.amphoe,
//                         province: widget.province,
//                         zipcode: widget.zipcode,
//                         formValues: widget.formValues,
//                       ),
//                     ),
//                   );
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) => AlertDialog(
//                       title: Text('No image selected'),
//                       content: Text('Please select an image.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('OK'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//               child: Text('Next'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
