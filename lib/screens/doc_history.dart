import 'dart:convert';

import 'package:accounting_portal/screens/dashboard_screen.dart';
import 'package:accounting_portal/screens/file.dart';
import 'package:accounting_portal/screens/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../widgets/color.dart';
import 'login_screen.dart';
import 'package:flutter/animation.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage>
    with SingleTickerProviderStateMixin {
  bool _showSearchField = false;
  FocusNode _focusNode = FocusNode();
  AnimationController _animationController;
  Map<String, dynamic> _data;
  List<dynamic> _searchResults;
  TextEditingController _searchController;

  @override
  void initState() {
    _fetchData();
    _searchController = TextEditingController();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
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

  void _searchData(String searchTerm) {
    setState(() {
      _searchResults = _data['dataList']
          .where((item) =>
              item['fileName']
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()) ||
              item['id'].toString().contains(searchTerm))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
       Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=> DashboardScreen()), (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 251, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 29, 141, 252),
          toolbarHeight: MediaQuery.of(context).size.height * .06,
          leading: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex) => DashboardScreen()));
              },
              child: Icon(Icons.arrow_back)),
          elevation: 0,
          title: _showSearchField
              ? TextField(
                  showCursor: true,
                  cursorColor: Colors.white,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  focusNode: _focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search documents . . .",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    _searchData(text);
                  },
                )
              : Text(''),
          actions: [
            if (!_showSearchField)
              IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.search_ellipsis,
                    progress: _animationController,
                  ),
                  onPressed: () {
                    setState(() {
                      _showSearchField = true;
                    });
                    _animationController.forward();
                    FocusScope.of(context).requestFocus(_focusNode);
                  }),
            if (_showSearchField)
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _showSearchField = false;
                    _searchController.clear();
                  });
                  _animationController.reverse();
                },
              ),
          ],
        ),
        body: _data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .048,
                        right: MediaQuery.of(context).size.width * .048,
                        top: MediaQuery.of(context).size.height * .015),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .1,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(0, 2),
                                blurRadius: 1,
                                spreadRadius: 1)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .04,
                                top:
                                    MediaQuery.of(context).size.height * .0037),
                            width: MediaQuery.of(context).size.width * .12,
                            height: MediaQuery.of(context).size.height * .05,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200),
                            child: Icon(
                              Icons.cloud_upload,
                              color: Color.fromARGB(255, 29, 141, 252),
                              size: 25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .04,
                                top: MediaQuery.of(context).size.height * .01,
                                right: MediaQuery.of(context).size.width * .04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Upload',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${_data['totalUpload']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .048,
                        right: MediaQuery.of(context).size.width * .048,
                        top: MediaQuery.of(context).size.height * .025),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .1,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(0, 2),
                                blurRadius: 1,
                                spreadRadius: 1)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .04,
                                top:
                                    MediaQuery.of(context).size.height * .0037),
                            width: MediaQuery.of(context).size.width * .12,
                            height: MediaQuery.of(context).size.height * .05,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200),
                            child: Icon(
                              Icons.cloud_upload,
                              color: Color.fromARGB(255, 29, 141, 252),
                              size: 25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .04,
                                top: MediaQuery.of(context).size.height * .01,
                                right: MediaQuery.of(context).size.width * .04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Today Upload',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${_data['todayUpload']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .04,
                          right: MediaQuery.of(context).size.width * .04,
                          top: MediaQuery.of(context).size.height * .02,
                          bottom: MediaQuery.of(context).size.height * .02),
                      child: const Text(
                        'Uploaded Documents',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _searchResults == null || _searchResults.length == 0
                        ? Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * .02,
                                    right:
                                        MediaQuery.of(context).size.width * .02,
                                    top: MediaQuery.of(context).size.height *
                                        .00),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.grey.shade200,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              .014),
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.insert_drive_file,
                                              size: 40,
                                              color: Color.fromARGB(
                                                  255, 29, 141, 252)),
                                          title: Text(
                                              "${_searchResults[index]['fileName'].substring(_searchResults[index]['fileName'].lastIndexOf("-") + 1)}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.black87)),
                                          subtitle: Text(
                                              _searchResults[index]['fileType'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blueGrey)),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .055,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .017),
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: "Uploaded on ",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blueGrey,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        "${_searchResults[index]['uploadDate']}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ]),
                                            )),
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
      ),
    );
  }
}
