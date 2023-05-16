import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../../auth/categories.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  final String itemId;

  const Detail({
    Key? key,
    required this.itemId,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: FutureBuilder(
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

                  if (item.itemId == widget.itemId) {
                    return Card(
                      child: ListTile(
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
                            SizedBox(
                              height: 8,
                            ),
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
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Number Photo : ${item.img!.length}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              "\฿ ${NumberFormat('#,##0', 'en_US').format(item.price)} ",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'Type : ${item.features?.type ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              "bedroom :${item.features?.bedroom ?? 'N/A'} ",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              "bathroom :${item.features?.bathroom ?? 'N/A'} ",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'living : ${item.features?.living ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'kitchen :${item.features?.kitchen ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'dining :${item.features?.dining ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'parking :${item.features?.parking ?? 'N/A'}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              'Email: ${item.email}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
