import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5000);
  print('Server listening on port ${server.port}');

  await for (var req in server) {
    try {
      if (req.method == 'POST') {
        final body = await utf8.decoder.bind(req).join();
        final params = json.decode(body);

        final imageFile = params['img'];
        final latitude = params['lat'];
        final longitude = params['long'];
        final district = params['district'];
        final amphoe = params['amphoe'];
        final province = params['province'];
        final zipcode = params['zipcode'];
        final type = params['type'];
        final price = params['price'];
        final area = params['area'];
        final bedroom = params['bedroom'];
        final bathroom = params['bathroom'];
        final living = params['living'];
        final kitchen = params['kitchen'];
        final dining = params['dining'];
        final parking = params['parking'];

        print('Received data:');
        print(body);
        final data = {
          'img': imageFile,
          'lat': latitude,
          'long': longitude,
          'district': district,
          'amphoe': amphoe,
          'province': province,
          'zipcode': zipcode,
          'type': type,
          'price': price,
          'area': area,
          'bedroom': bedroom,
          'bathroom': bathroom,
          'living': living,
          'kitchen': kitchen,
          'dining': dining,
          'parking': parking,
        };
        final jsonData = json.encode(data);

        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonData);
      } else {
        req.response.write('Hello, world!');
      }
    } on FormatException catch (error) {
      req.response.statusCode = HttpStatus.badRequest;
      req.response.write('Invalid request body: ${error.message}');
    } catch (error) {
      req.response.statusCode = HttpStatus.internalServerError;
      req.response.write('Internal server error: ${error.toString()}');
    } finally {
      await req.response.close();
    }
  }
}
