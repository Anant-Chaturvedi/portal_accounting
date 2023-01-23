import 'dart:convert';
import 'dart:io';

import 'package:accounting_portal/screens/doc_scan_screen.dart';
import 'package:accounting_portal/screens/file.dart';
import 'package:accounting_portal/screens/history_new.dart';
import 'package:accounting_portal/screens/login_screen.dart';
import 'package:accounting_portal/screens/settings_page.dart';
import 'package:accounting_portal/widgets/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../model/scanned_document.dart';
import '../service/scanned_document_repository.dart';
import 'doc_history.dart';
import 'doc_viewer_screen.dart';

bool isClicked = false;
bool _isSelected = false;
DateTime _lastPressedAt;
Color offWhite = const Color.fromRGBO(245, 245, 245, 1.0);

class DashboardScreen extends StatefulWidget {
  final ScannedDocumentRepository _scannedDocumentRepository =
      GetIt.I.get<ScannedDocumentRepository>();

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ScannedDocument> _scannedDocuments = [];
  bool _loaded = false;
  bool _error = false;
  String _seletedCompany;
  List<String> _storeNames = [];
  final Map<String, String> _stores = Map();
  String _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    fetchStoreData();
    _updateView();
  }

  void _updateView() {
    setState(() {
      _loaded = false;
    });

    widget._scannedDocumentRepository.getAll().then((value) {
      setState(() {
        _scannedDocuments = value;
        _loaded = true;
      });
    }).catchError((_) {
      setState(() {
        _loaded = true;
        _error = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: AppColors.accentColor));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt) >
                    Duration(seconds: 1)) {
              _lastPressedAt = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blue,
                content: Text('Double tap back again to exit'),
                duration: Duration(seconds: 1),
              ));
              return false;
            }
            SystemNavigator.pop(); // This will close the app
            return true;
          },
          child: Scaffold(
              backgroundColor: Color.fromARGB(255, 250, 251, 255),

              // backgroundColor: offWhite,
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height * .06,
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                backgroundColor: AppColors.accentColor,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, right: 4, bottom: 10),
                    child: Image.asset('assets/images/image.png'),
                  ),
                  const Center(
                    child: Text(
                      'SNO   ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Lemon'),
                    ),
                  )
                ],
              ),
              drawer: Drawer(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: double.infinity,
                      decoration:
                          const BoxDecoration(color: AppColors.accentColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .0275,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .1,
                              child: Image.asset('assets/images/image.png')),
                          const Center(
                            child: Text(
                              'SNO',
                              style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontFamily: 'Lemon'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  SizedBox(
                    //   height: MediaQuery.of(context).size.height *.01 ,
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => DashboardScreen()),
                                      (route) => false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .04,
                                      top: MediaQuery.of(context).size.height *
                                          .023),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.home_filled,
                                        size: 24,
                                        color: AppColors.accentColor,
                                      ),
                                      const Text(
                                        '  Dashboard',
                                        style: TextStyle(
                                            color: AppColors.accentColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .06,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .01),
                                child: Divider(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => HistoryNew()),
                                      (route) => false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .04,
                                      top: MediaQuery.of(context).size.height *
                                          .00),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.history,
                                        size: 24,
                                        color: AppColors.accentColor,
                                      ),
                                      const Text(
                                        '  History',
                                        style: TextStyle(
                                            color: AppColors.accentColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .06,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .01),
                                child: Divider(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SettingsPage()),
                                      (route) => false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .035,
                                      top: MediaQuery.of(context).size.height *
                                          .003),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.settings,
                                        size: 24,
                                        color: AppColors.accentColor,
                                      ),
                                      const Text(
                                        '  Settings',
                                        style: TextStyle(
                                            color: AppColors.accentColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .06,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .01),
                                child: Divider(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                },
                                icon: Image.asset('assets/images/logout.png',
                                    height: 20),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDB3022),
                                    shape: const RoundedRectangleBorder(),
                                    minimumSize: Size(
                                        double.infinity,
                                        MediaQuery.of(context).size.height *
                                            .066)),
                                label: const Text(
                                  'Logout',
                                  style: TextStyle(
                                      // color: AppColors.accentColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Theme(
                  data: ThemeData.light(useMaterial3: true),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .00,
                          top: MediaQuery.of(context).size.height * .0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .042,
                                top: 24,
                                right: 4,
                                bottom: 1),
                            child: Text(
                              '👋',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const Text(
                            '\nWelcome back',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .042,
                          right: MediaQuery.of(context).size.width * .042,
                          top: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 212, 233, 250),
                                  offset: Offset(0, 2),
                                  blurRadius: 3,
                                  spreadRadius: 2)
                            ]),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * .03,
                                    right:
                                        MediaQuery.of(context).size.width * .03,
                                    top: MediaQuery.of(context).size.height *
                                        .017,
                                    bottom: MediaQuery.of(context).size.height *
                                        .0035),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.business,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    const Text(
                                      "Company's Name",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .03),
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width: MediaQuery.of(context).size.width,
                                  child: _storeNames.isEmpty
                                      ? const Center(
                                          child:
                                              Text('Fetching Company Names...')
                                          // Image(
                                          //     image: AssetImage(
                                          //         'assets/images/load.gif'))
                                          )
                                      : SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        Colors.grey.shade100),
                                                padding: const EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: InkWell(
                                                  onTap: () async {
                                                    final selected =
                                                        await showCupertinoDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Center(
                                                      child: CupertinoActionSheet(
                                                        title: Text(
                                                          "Select Company",
                                                          style: TextStyle(
                                                              fontSize: 20,color: Colors.black),
                                                        ),
                                                        actions: List.generate(
                                                          _storeNames.length,
                                                          (index) =>
                                                              CupertinoActionSheetAction(
                                                            child: Text(
                                                              _storeNames[index],
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  _storeNames[
                                                                      index]);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }); 

                                                    if (selected != null) {
                                                      setState(() {
                                                        _seletedCompany =
                                                            selected;
                                                        _selectedCompanyId =
                                                            _stores[selected];
                                                        _isSelected = true;
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(_isSelected
                                                          ? _seletedCompany
                                                          : "   Select Company Name"),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 14.0),
                                                        child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        )),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .017,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .042,
                          right: MediaQuery.of(context).size.width * .042,
                          top: MediaQuery.of(context).size.height * .03),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 212, 233, 250),
                                  offset: Offset(0, 2),
                                  blurRadius: 3,
                                  spreadRadius: 2)
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .03,
                                  top: MediaQuery.of(context).size.height *
                                      .017),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // const SizedBox(
                                  //   height: 15.0,
                                  // ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Kindly select a transaction type',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 21.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isClicked = !isClicked;
                                          });
                                        },
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: !isClicked
                                                        ? Colors.blue.shade400
                                                        : Colors.grey.shade200,
                                                    width: 2)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.holiday_village_sharp,
                                                  color: Colors.blue.shade300,
                                                ),
                                                Text(' Bank Transaction',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade400,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12))
                                              ],
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isClicked = true;
                                          });
                                        },
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: isClicked
                                                        ? Colors.blue.shade400
                                                        : Colors.grey.shade200,
                                                    width: 2)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.blue.shade300,
                                                ),
                                                Text(' Cash Transaction',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade400,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12))
                                              ],
                                            )),
                                      )
                                    ],
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 18.0,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                .018),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .05,
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (_) => DocScanScreen(
                                                      companyId:
                                                          _selectedCompanyId,
                                                      transactionType: isClicked
                                                          ? 'cash'
                                                          : 'bank')));

                                          _updateView();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            backgroundColor:
                                                AppColors.accentColor),
                                        label: const Text('Proceed to Scan',style: TextStyle(color: Colors.white),),
                                        icon: const Icon(
                                            Icons.camera_alt_outlined,color: Colors.white,size: 22,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .042,
                          top: MediaQuery.of(context).size.height * .03,
                          bottom: MediaQuery.of(context).size.height * .02),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cloud_upload_sharp,
                                color: Colors.green,
                              ),
                              const Text(
                                '  Uploaded Documents',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .028),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        child: Visibility(
                          visible: _scannedDocuments.isEmpty,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .067,
                              ),
                              Icon(Icons.folder_open,
                                  color: Colors.grey, size: 76),
                              SizedBox(height: 10),
                              Text("No Documents Scanned Yet!",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ))
                            ],
                          ),
                          replacement: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 2.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: _scannedDocuments.length > 4
                                ? 4
                                : _scannedDocuments.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DocViewer(_scannedDocuments[index]),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .02,
                                      right: MediaQuery.of(context).size.width *
                                          .02,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .02,
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: FileImage(File(
                                                    _scannedDocuments[index]
                                                        .previewImageUri)),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 3)),
                                        ),
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              )),
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
          "https://mijnkontinu.nl/api/fetch-companies-list.php",
          data: {"userId": userId});
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      if (jsonData['errorCode'] == '0000') {
        if (jsonData['dataList'].length != 0) {
          jsonData['dataList'].forEach((store) {
            _stores[store['companyName']] = store['companyId'];
          });
          _storeNames = _stores.keys.toList();
          if (_storeNames.isNotEmpty) {
            _seletedCompany = _storeNames[0];
            _selectedCompanyId = _stores[_seletedCompany];
          }
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
