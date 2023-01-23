import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String _selectedStore;
  List<String> _storeNames = [];

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _storeNames.isEmpty
          ? Center(child: Image(image: AssetImage('assets/images/load.gif')))
          : SizedBox(
            width: double.infinity,
            child: Container(
               decoration: BoxDecoration(color: Colors.white),
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                  underline: Container(),
                  icon: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .5),
                      child: Icon(Icons.arrow_downward_rounded)),
                  elevation: 0,
                  value: _selectedStore,
                  items: _storeNames.map((store) {
                    return DropdownMenuItem<String>(
                      value: store,
                      child: Text(store),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedStore = newValue;
                    });
                  },
                ),
            ),
          ),
    );
  }

  Future<void> fetchStoreData() async {
    try {
      final dio = Dio();
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('user_data'));
      final String userId = userData['userId'];
      dio.options.contentType = 'application/json';
      final Response response = await dio.post(
          "https://mijnkontinu.nl/api/fetch-stores-list.php",
          data: {"userId": userId});
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      if (jsonData['errorCode'] == '0000') {
        if (jsonData['dataList'].length != 0) {
          _storeNames = jsonData['dataList']
              .map<String>((e) => e['storeName'].toString())
              .toList();
          if (_storeNames.isNotEmpty) _selectedStore = _storeNames[0];
          setState(() {});
        } else {
          print(jsonData['errorMessage']);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}

class StorePage2 extends StatefulWidget {
  @override
  _StorePage2State createState() => _StorePage2State();
}

class _StorePage2State extends State<StorePage2> {
  String _selectedStore;
  List<String> _storeNames = [];

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _storeNames.isEmpty
            ? Center(child: Image(image: AssetImage('assets/images/load.gif')))
            : SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(left: 8),
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    
                    dropdownColor: Colors.white,
                    underline: Container(),
                    isDense: true,
                    icon: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .5),
                        child: Icon(Icons.arrow_drop_down)),
                    elevation: 0,
                    value: _selectedStore,
                    items: _storeNames.map((store) {
                      return DropdownMenuItem<String>(
                        
                        value: store,
                        child: Text(store, style: TextStyle(fontSize: 14),),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedStore = newValue;
                      });
                    },
                  ),
                ),
              ));
  }

  Future<void> fetchStoreData() async {
    try {
      final dio = Dio();
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('user_data'));
      final String userId = userData['userId'];
      dio.options.contentType = 'application/json';
      final Response response = await dio.post(
          "https://mijnkontinu.nl/api/fetch-companies-list.php",
          data: {"userId": userId});
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      if (jsonData['errorCode'] == '0000') {
        if (jsonData['dataList'].length != 0) {
          _storeNames = jsonData['dataList']
              .map<String>((e) => e['companyName'].toString())
              .toList();
          if (_storeNames.isNotEmpty) _selectedStore = _storeNames[0];
          setState(() {});
        } else {
          print(jsonData['errorMessage']);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
