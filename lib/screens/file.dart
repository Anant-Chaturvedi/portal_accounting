import 'dart:convert';

import 'package:accounting_portal/widgets/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'dashboard_screen.dart';

class FileListPage extends StatefulWidget {
  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  Map<String, dynamic> _data;
  List<dynamic> _searchResults;
  int _currentPage = 0;
  final int _pageSize = 8;
  PageController _pageController;
  TextEditingController _searchController;

  @override
  void initState() {
    _fetchData();
    _pageController = PageController(initialPage: _currentPage);
    _searchController = TextEditingController();
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

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
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
    if (_searchResults == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    int totalPages = (_searchResults.length / _pageSize).ceil();
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex) => DashboardScreen()));
              },
              child: Icon(Icons.arrow_back)),
          toolbarHeight: MediaQuery.of(context).size.height * .06,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: AppColors.accentColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('assets/images/image.png'),
            ),
            Center(
              child: Text(
                'SNO  ',
                style: TextStyle(
                    fontSize: 18, color: Colors.white, fontFamily: 'Lemon'),
              ),
            )
          ],
        ),
        body: _data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .04,
                      right: MediaQuery.of(context).size.width * .04,
                      top: MediaQuery.of(context).size.height * .01),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade200, width: 3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .04,
                              top: MediaQuery.of(context).size.height * .0037),
                          width: MediaQuery.of(context).size.width * .12,
                          height: MediaQuery.of(context).size.height * .05,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100),
                          child: const Icon(
                            Icons.cloud_upload,
                            color: Colors.blue,
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
                                    fontWeight: FontWeight.w700, fontSize: 12),
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
                      left: MediaQuery.of(context).size.width * .04,
                      right: MediaQuery.of(context).size.width * .04,
                      top: MediaQuery.of(context).size.height * .01),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade200, width: 3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .04,
                              top: MediaQuery.of(context).size.height * .0037),
                          width: MediaQuery.of(context).size.width * .12,
                          height: MediaQuery.of(context).size.height * .05,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100),
                          child: const Icon(
                            Icons.cloud_upload,
                            color: Colors.green,
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
                                    fontWeight: FontWeight.w700, fontSize: 12),
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
                        top: MediaQuery.of(context).size.height * .025,
                        bottom: MediaQuery.of(context).size.height * .01),
                    child: const Text(
                      'Document Uploaded History',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .04,
                      top: MediaQuery.of(context).size.height * .0,
                      right: MediaQuery.of(context).size.width * .04),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .055,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          labelText: 'Search for documents',
                          labelStyle: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 4,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onChanged: (text) {
                        _searchData(text);
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: _searchResults == null || _searchResults.length == 0
                        ? Center(child: Text('No results found'))
                        : PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: _searchResults.length != 0
                                ? _searchResults.length
                                : 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .01,
                                    left: 4,
                                    right: 4),
                                child: Table(
                                
                                  children: [
                                    TableRow(
                                     
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 4, bottom: 4, top: 4),
                                          child: Text(
                                            "S/N",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 4, top: 4),
                                          child: Text(
                                            "Id",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 4, top: 4),
                                          child: Text(
                                            "Format",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 4, top: 4),
                                          child: Text(
                                            "Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            "Upload Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (var i = index * _pageSize;
                                        i < (index + 1) * _pageSize &&
                                            i < _searchResults.length;
                                        i++)
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, bottom: 4, top: 4),
                                            child: Text("${i + 1}",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4, top: 4),
                                            child: Text(
                                              "${_searchResults[i]['id']}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "${_searchResults[i]['fileType']}",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 4, top: 4, right: 4),
                                              child: Text(
                                                "${_searchResults[i]['fileName']}"
                                                    .substring(
                                                        "${_searchResults[i]['fileName']}"
                                                                .lastIndexOf(
                                                                    "-") +
                                                            1),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "${_searchResults[i]['uploadDate']}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            })),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${_currentPage + 1} of ${totalPages}'),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.blue,
                              ),
                              onPressed: _currentPage > 0
                                  ? () {
                                      _pageController.animateToPage(
                                        _currentPage - 1,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  : null,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.blue,
                              ),
                              onPressed: _currentPage <
                                      _searchResults.length - 1
                                  ? () {
                                      _pageController.animateToPage(
                                        _currentPage + 1,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ))
              ]));
  }
}
