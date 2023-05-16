import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth/login_screen.dart';
import 'Item/Item.dart';
import 'package:http/http.dart' as http;
import '../auth/categories.dart';
import 'package:intl/intl.dart';
import 'Detail/detail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  String _token = '';

  void logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<CategoriesAll> _categoriesFuture = getCategories();

  static Future<CategoriesAll> getCategories() async {
    var url = Uri.parse("http://13.250.14.61:8765/v1/get");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return categoriesAllFromJson(response.body);
    } else {
      throw Exception("Failed to get categories from API");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await storage.read(key: 'token');
    setState(() {
      _token = token ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: _infoDrawer(context, logout),
      ),
      body: _CallApi(_categoriesFuture),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RealEstateForm(token: _token),
            ),
          );
        },
        child: const Icon(Icons.add_home_work_outlined),
      ),
    );
  }
}

Widget _infoDrawer(context, logout) {
  return ListView(
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text('Hi, User'),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          //don't rebuild
          Navigator.pop(context);
        },
      ),
      const Divider(
        height: 1,
        thickness: 1,
      ),
      ListTile(
        leading: const Icon(Icons.book),
        title: const Text('booking'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      const Divider(
        height: 1,
        thickness: 1,
      ),
      ListTile(
        leading: const Icon(Icons.chat),
        title: const Text('chat'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      const Divider(
        height: 1,
        thickness: 1,
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('logout'),
        onTap: () {
          logout(context);
        },
      ),
      const Divider(
        height: 1,
        thickness: 1,
      ),
    ],
  );
}

Widget _CallApi(_categoriesFuture) {
  return FutureBuilder(
    future: _categoriesFuture,
    builder: (BuildContext context, AsyncSnapshot<CategoriesAll> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          var result = snapshot.data!;
          return ListView.builder(
            itemCount: result.items!.length,
            itemBuilder: (context, index) {
              var item = result.items![index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Detail(itemId: item.itemId.toString()),
                      ),
                    );
                  },
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "itemId : ${item.itemId}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Title(
                        color: Colors.black,
                        child: Text(
                          "\$ ${NumberFormat('#,##0', 'en_US').format(item.price)} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("Address: ${item.amphoe}, ${item.district} "),
                      Text(
                          " P:${item.features?.parking ?? 'N/A'} B:${item.features?.bedroom ?? 'N/A'} K ${item.features?.kitchen ?? 'N/A'} | ${item.features?.type ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
