import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'calculator.dart';

class Detail extends StatefulWidget {
  const Detail({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isFavorite = false;
  final storage = FlutterSecureStorage();
  late Future<String?> email;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    email = _getEmail();
    email.then((value) {
      setState(() {
        currentUserEmail = value;
      });
    });
    checkFavorite();
  }

  Future<String?> _getEmail() async {
    return await storage.read(key: 'email');
  }

  void checkFavorite() {
    final item = widget.data['items'][widget.data['index']];
    final favorites = widget.data['favorite'];
    isFavorite = favorites.contains(item['item_id']);
    print(item['email']);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data['items'][widget.data['index']];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.network(
                'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' +
                    item['img'][0],
                width: screenWidth,
                height: screenHeight *
                    0.4, // กำหนดความสูงของรูปภาพเป็น 40% ของหน้าจอ
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8.0,
                left: 8.0, // ปรับตำแหน่งไอคอนไปทางซ้าย
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hotel,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        item['features']['bedroom'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Icon(
                        Icons.bathtub,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        item['features']['bathroom'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 240.0,
                right: 8.0, // ปรับตำแหน่งไอคอนหัวใจไปทางขวาด้านบน
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    widget.data['fn'] = 'favorite';
                    widget.data['body'] = {"item_id": item['item_id']};
                    Navigator.pushNamed(context, '/api');
                  },
                ),
              ),
            ],
          ),
          ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['features']['type'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "เขต",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "พื้นที่",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "ห้องนอน",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "ห้องนํ้า",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          item['amphoe'] + ', ' + item['province'],
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 35.0),
                        Text(
                          item['features']['area'].toString() + ' ตร.ม.',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          item['features']['bedroom'].toString() + ' ห้องนอน',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          item['features']['bathroom'].toString() + ' ห้องน้ำ',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calculator(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Calculator',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 360,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(item['lat']!, item['lng']!),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(item['item_id']!),
                  position: LatLng(item['lat']!, item['lng']!),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: currentUserEmail == item['email']
          ? FloatingActionButton(
              onPressed: () {
                //   Navigator.pushNamed(context, '/edit',
                //       arguments: item['item_id']);
              },
              child: const Icon(Icons.edit),
            )
          : FloatingActionButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/chat',
                //     arguments: item['item_id']);
                //add go to this link https://line.me/ti/p/~adisak-2457
                widget.data['fn'] = 'contact';
                widget.data['body'] = {"item_id": item['item_id']};

                Navigator.pushNamed(context, '/api')
                    .then((_) => launchMessenger());
              },
              child: Image.asset('assets/line.png', width: 24, height: 24),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void launchMessenger() async {
    //  String lineIdHere = item['fb_id'];
    print(widget.data['contact']);
    String lineIdHere = widget.data['contact'];

    String url() {
      if (Platform.isAndroid) {
        String uri = 'line://ti/p/~$lineIdHere';
        return uri;
      } else if (Platform.isIOS) {
        String uri = 'line://ti/p/$lineIdHere';
        return uri;
      } else {
        return 'error';
      }
    }

    String launchUrl = url();

    if (await canLaunch(launchUrl)) {
      await launch(launchUrl);
    } else {
      String webUrl = 'https://line.me/R/ti/p/~$lineIdHere';
      await launch(webUrl);
    }
  }
}
