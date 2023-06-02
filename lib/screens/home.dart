import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'calculator.dart';
import 'serach_map.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  State<Home> createState() => _HomeState();
}

final storage = FlutterSecureStorage();
final Future<String?> email = _getEmail();

Future<String?> _getEmail() async {
  return storage.read(key: 'email');
}

class _HomeState extends State<Home> {
  String searchValue = '';
  final TextEditingController searchController = TextEditingController();
  int dropdownValue = 1;
  String dropdownSearchValue = 'province';

  void logout() async {
    await storage.deleteAll();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.data['nav_id'];
    bool showFloatingActionButton = value == 0 || value == 1;

    return Scaffold(
      appBar: value != 2
          ? AppBar(
              title: Text(widget.data['title']),
              centerTitle: true,
              bottom: value == 0 || value == 1
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight + 32),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.5)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search,
                                            color: Colors.black),
                                        onPressed: () {
                                          setState(() {
                                            searchValue = searchController.text;
                                          });
                                          widget.data['title'] = 'Search';
                                          widget.data['fn'] = 'get';
                                          widget.data['body'] = {
                                            "search": searchValue,
                                          };

                                          print(searchValue);
                                          Navigator.pushNamed(context, '/api')
                                              .then((_) => setState(() {}));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (value == 0 || value == 1)
                                  IconButton(
                                    icon: dropdownValue == 1
                                        ? Icon(Icons.view_agenda,
                                            color: Colors.white)
                                        : dropdownValue == 2
                                            ? Icon(Icons.grid_on,
                                                color: Colors.white)
                                            : Icon(Icons.map,
                                                color: Colors.white),
                                    color: dropdownValue != 0
                                        ? Colors.white
                                        : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        dropdownValue = (dropdownValue % 3) + 1;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  : null,
            )
          : null,
      body: (() {
        if (value == 0 || value == 1) {
          if (dropdownValue == 1) {
            return ListView.builder(
              itemCount: widget.data['items'].length,
              itemBuilder: (context, index) {
                if (index >= widget.data['items'].length) {
                  return Container();
                }
                return ListTile(
                  title: Image.network(
                    'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' +
                        widget.data['items'][index]['img'][0],
                    fit: BoxFit.cover,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.data['items'][index]['features']['type'] +
                            '   ' +
                            widget.data['items'][index]['features']['area']
                                .toString() +
                            ' ตร.ม.   ' +
                            widget.data['items'][index]['features']['bedroom']
                                .toString() +
                            ' ห้องนอน   ' +
                            widget.data['items'][index]['features']['bathroom']
                                .toString() +
                            ' ห้องน้ำ',
                      ),
                      Text(
                        widget.data['items'][index]['amphoe'] +
                            ', ' +
                            widget.data['items'][index]['province'],
                      ),
                    ],
                  ),
                  onTap: () {
                    widget.data['index'] = index;
                    Navigator.pushNamed(context, '/detail');
                  },
                );
              },
            );
          } else if (dropdownValue == 2) {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: widget.data['items'].length,
              itemBuilder: (context, index) {
                if (index >= widget.data['items'].length) {
                  return Container(); // Return an empty container if index is out of range
                }
                return GestureDetector(
                  onTap: () {
                    widget.data['index'] = index;
                    Navigator.pushNamed(context, '/detail');
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' +
                                widget.data['items'][index]['img'][0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          widget.data['items'][index]['features']['type'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          widget.data['items'][index]['amphoe'] +
                              ', ' +
                              widget.data['items'][index]['province'],
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (dropdownValue == 3) {
            return FilterMap(data: widget.data);
          }
        } else if (value == 3) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Wealthi Real Estate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(Icons.business),
              ),
              FutureBuilder<String?>(
                future: email,
                builder: (context, snapshot) {
                  final emailValue = snapshot.data;
                  return ListTile(
                    title: Text(
                      'Email: $emailValue',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(Icons.email),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Change Profile',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/profile')
                      .then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  widget.data['nav_id'] = 0;
                  widget.data['title'] = 'Home';
                  logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ],
          );
        } else if (value == 2) {
          return Center(
            child: Calculator(),
          );
        } else {
          return Container();
        }
      }()),
      floatingActionButton: showFloatingActionButton
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/property')
                    .then((_) => setState(() {}));
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.data['nav_id'],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.blue,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calculate,
              color: Colors.blue,
            ),
            label: "Calculator",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            label: "Settings",
          ),
        ],
        onTap: (value) {
          widget.data['nav_id'] = value;
          if (value == 0) {
            widget.data['title'] = 'Home';
            widget.data['fn'] = 'get';
            widget.data['body'] = {};
            Navigator.pushNamed(context, '/api').then((_) => setState(() {}));
          } else if (value == 1) {
            widget.data['title'] = 'Favorite';
            widget.data['fn'] = 'get';
            widget.data['body'] = {"favorite": widget.data['favorite']};
            Navigator.pushNamed(context, '/api').then((_) => setState(() {}));
          } else if (value == 2) {
            widget.data['title'] = 'Calculator';
            setState(() {});
            print(widget.data['property']);
          } else if (value == 3) {
            widget.data['title'] = 'Setting';
            setState(() {});
          }
          setState(() {
            showFloatingActionButton = value == 0 || value == 1;
          });
        },
      ),
    );
  }
}
