
// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  Map<String, dynamic> _data;
  final int _pageSize = 6;
  int _currentPage = 0;
  List _searchResults;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() async {
    Dio dio = Dio();
    final box = await Hive.openBox('user');
    final userData = jsonDecode(box.get('user_data'));
    final String userId = userData['userId'];
    try {
      Response response = await dio.post(
        'https://mijnkontinu.nl/api/fetch-document-history.php',
        data: {'userId': userId},
      );
      Map<String, dynamic> data = json.decode(response.data);
      setState(() {
        _data = data;
        _searchResults = _data['dataList'];
      });
    } catch (e) {
      print(e);
    }
  }

  void _searchData(String text) {
    if (text.isEmpty) {
      setState(() {
        _searchResults = _data['dataList'];
        _currentPage = 0;
      });
    } else {
      List newResults = _data['dataList']
          .where((result) =>
              result['fileName'].contains(text) || result['id'].contains(text))
          .toList();
      setState(() {
        _searchResults = newResults;
        _currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: 'Search documents',
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        _searchController.clear();
                        _searchData("");
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10)),
          onChanged: (text) {
            _searchData(text);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 251, 255),
      body: _data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: _searchResults == null || _searchResults.length == 0
                      ? Center(child: Text('No results found'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .02,
                                  right:
                                      MediaQuery.of(context).size.width * .02,
                                  top:
                                      MediaQuery.of(context).size.height * .01),
                              child: Card(
                                color: Colors.blue.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.insert_drive_file,
                                            size: 40, color: Colors.white70),
                                        title: Text(
                                            "${_searchResults[index]['fileName'].substring(_searchResults[index]['fileName'].lastIndexOf("-") + 1)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white)),
                                        subtitle: Text(
                                            _searchResults[index]['fileType'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text(
                                            "Uploaded on ${_searchResults[index]['uploadDate']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}