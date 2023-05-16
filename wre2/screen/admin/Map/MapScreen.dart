import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Photo/Photo.dart';

class MapScreen extends StatefulWidget {
  final String district;
  final String amphoe;
  final String province;
  final String zipcode;
  final Map<String, Object?> formValues;
  final String token;

  MapScreen({
    required this.district,
    required this.amphoe,
    required this.province,
    required this.zipcode,
    required this.formValues,
    required this.token,
  });

  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  LatLng _center = const LatLng(13.7248785, 100.4683012);
  LatLng _markerLocation = LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 11.0)));
  }

  void _onMarkerTapped(LatLng location) {
    setState(() {
      _markerLocation = location;
    });

    print('Pin : ${location.latitude}, ${location.longitude}');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Your Location '),
            //text show latitude and longitude
            content: Text(
                'latitude ${location.latitude}, longitude :${location.longitude} \n\nDo you want to take a photo?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Photo(
                                latitude: location.latitude,
                                longitude: location.longitude,
                                district: widget.district,
                                amphoe: widget.amphoe,
                                province: widget.province,
                                zipcode: widget.zipcode,
                                formValues: widget.formValues,
                                token: widget.token,
                              )),
                    );
                  },
                  child: Text('Take Photo')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pin Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        onTap: _onMarkerTapped,
        markers: _markerLocation == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('Pin_1'),
                  position: _markerLocation,
                ),
              },
      ),
    );
  }
}
