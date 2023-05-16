import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/auth/login_screen.dart';
import '../screen/admin/ReI/Item.dart';
import 'package:http/http.dart' as http;
import 'Page/categories.dart';
import 'package:intl/intl.dart';

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
  void logout(BuildContext context) {
    String newToken = '';

    // Navigate to the login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  CategoriesAll? _dataFromAPI;
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<CategoriesAll> getCategories() async {
    var url = Uri.parse("http://13.250.14.61:8765/v1/get");
    var response = await http.get(url);

    _dataFromAPI = categoriesAllFromJson(response.body);
    return _dataFromAPI!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCategories(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data as CategoriesAll;
            return ListView.builder(
              itemCount: result.items!.length,
              itemBuilder: (context, index) {
                var item = result.items![index];
                return Card(
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 210,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.img!.length,
                                    itemBuilder: (context, index) {
                                      final imageUrl = item.img![index];
                                      return Container(
                                        height: double.infinity,
                                        width: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                        child: Image.network(
                                          'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/$imageUrl',
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RealEstateForm(token: widget.token),
            ),
          );
        },
        child: const Icon(Icons.add_home_work_outlined),
      ),
    );
  }
}
