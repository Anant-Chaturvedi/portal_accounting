import 'dart:io';

import 'package:accounting_portal/widgets/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../model/scanned_document.dart';
import '../service/scanned_document_repository.dart';
import 'dashboard_screen.dart';
import 'doc_viewer_screen.dart';

bool isClicked = false;

Color offWhite = const Color.fromRGBO(245, 245, 245, 1.0);

class HistoryNew extends StatefulWidget {
  final ScannedDocumentRepository _scannedDocumentRepository =
      GetIt.I.get<ScannedDocumentRepository>();

  @override
  _HistoryNewState createState() => _HistoryNewState();
}

class _HistoryNewState extends State<HistoryNew> {
  List<ScannedDocument> _scannedDocuments = [];

  @override
  void initState() {
    super.initState();
    _updateView();
  }

  void _updateView() {
    setState(() {});

    widget._scannedDocumentRepository.getAll().then((value) {
      setState(() {
        _scannedDocuments = value;
      });
    }).catchError((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.accentColor));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
          onWillPop: () async {
           Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=> DashboardScreen()), (route) => false);
          return true;
        },
        child: SafeArea(
          child: Scaffold(
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
            title: Text('Uploaded Documents',style: TextStyle(fontSize: 16),),
            backgroundColor: AppColors.accentColor,
            elevation: 0,
           
          ),
              body: Theme(
                data: ThemeData.light(useMaterial3: true),
                child: SingleChildScrollView(
                          child: Column(children: [
                          
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .028),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Visibility(
                        visible: _scannedDocuments.isEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *.2),
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              
                                Icon(Icons.folder_open, color: Colors.grey, size: 76),
                                SizedBox(height: 10),
                                Text("No Documents Scanned Yet!",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        replacement: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 2.0,
                            childAspectRatio: 0.6,
                          ),
                          itemCount: _scannedDocuments.length,
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
                                height: MediaQuery.of(context).size.height * .25,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context).size.width *
                                              .028,
                                          right: MediaQuery.of(context).size.width *
                                              .028,
                                          top: MediaQuery.of(context).size.height *
                                              .02,
                                        ),
                                        child: Container(
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
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: FileImage(File(
                                                      _scannedDocuments[index]
                                                          .previewImageUri)),
                                                ),
                                              boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: Offset(0, 2),
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //     left: MediaQuery.of(context).size.width *
                                    //         .028,
                                    //     right: MediaQuery.of(context).size.width *
                                    //         .028,
                                    //   ),
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.only(
                                    //             bottomLeft: Radius.circular(8),
                                    //             bottomRight: Radius.circular(8)),
                                    //         color: AppColors.accentColor),
                                    //     width: double.infinity,
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Column(
                                    //       children: [
                                    //         Row(
                                    //           children: [
                                    //             Icon(
                                    //               Icons.calendar_today,
                                    //               color: Colors.white,
                                    //             ),
                                    //             SizedBox(width: 8),
                                    //             Text(
                                    //               _scannedDocuments[index]
                                    //                   .date
                                    //                   .split(" ")[0],
                                    //               style: TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 fontSize: 14,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         SizedBox(height: 8),
                                    //         Row(
                                    //           children: [
                                    //             Icon(
                                    //               Icons.access_time,
                                    //               color: Colors.white,
                                    //             ),
                                    //             SizedBox(width: 8),
                                    //             Text(
                                    //               _scannedDocuments[index]
                                    //                   .date
                                    //                   .split(" ")[1],
                                    //               style: TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 fontSize: 14,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                )
                          ]),
                        ),
              )),
        ),
      ),
    );
  }
}
