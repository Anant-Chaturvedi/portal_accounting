// ignore_for_file: missing_return, lines_longer_than_80_chars

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:accounting_portal/screens/dashboard_screen.dart';
import 'package:accounting_portal/widgets/color.dart';
import 'package:dio/dio.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../service/generate_pdf_service.dart';
import '../widgets/loading_overlay.dart';

class DocScanScreen extends StatefulWidget {
  final String transactionType;
  final String companyId;

  const DocScanScreen({Key key, this.transactionType, this.companyId})
      : super(key: key);
  @override
  _DocScanScreenState createState() => _DocScanScreenState();
}

final _formKey = GlobalKey<FormState>();

class _DocScanScreenState extends State<DocScanScreen> {
  final List<String> _documents = [];
  final _textFieldController = TextEditingController();

  TextEditingController dateinput = TextEditingController();

  String dropdownvalue;
  String _selectedStore;
  List<String> _storeNames = [];
  final Map<String, String> _stores = Map();
  String _selectedStoreId;
  bool _isSelected = false;

  @override
  void initState() {
    dateinput.text = '';
    fetchStoreData();
    super.initState();
    _textFieldController.text = ' Upload Image';
  }

  String companyName;
  String total;
  String _billTotal;
  String _invoiceDate;
  bool _isLoading = false;
  bool _isImageLoaded = false;
  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
    for (final document in _documents) {
      File(document).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.accentColor));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (contex) => DashboardScreen()));
                },
                child: Icon(Icons.arrow_back)),
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
                  fontSize: 18, color: Colors.white, fontFamily: 'Lemon'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData.light(useMaterial3: false),
            child: Column(
              children: [
                // Add the three TextFields
          
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .042,
                      right: MediaQuery.of(context).size.width * .042,
                      top: MediaQuery.of(context).size.height * .02,
                      bottom: 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Store Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .0085,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: _storeNames.isEmpty
                              ? const Center(
                                          child: Text('Fetching Store Names...')
                                          // Image(
                                          //     image: AssetImage(
                                          //         'assets/images/load.gif'))
                                                  )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey.shade400)),
                                        child: InkWell(
                                          onTap: () async {
                                            final selected =
                                                await showCupertinoDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Center(
                                                          child:
                                                              CupertinoActionSheet(
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            "Select Store",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                    fontSize: 20,
                                                              ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        actions: List.generate(
                                                          _storeNames.length,
                                                          (index) =>
                                                              CupertinoActionSheetAction(
                                                            child: Text(
                                                                _storeNames[
                                                                    index]),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  _storeNames[
                                                                      index]);
                                                            },
                                                          ),
                                                        ),
                                                      ));
                                                    });
          
                                            if (selected != null) {
                                              setState(() {
                                                _selectedStore = selected;
                                                _selectedStoreId =
                                                    _stores[selected];
                                                _isSelected = true;
                                              });
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _isSelected
                                                    ? _selectedStore
                                                    : "  Select Store Name",
                                                style: TextStyle(
                                                    color: Colors.grey.shade500),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20.0),
                                                child: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .015,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Date of Invoice',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .0085,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .065,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required!';
                                  }
                                },
                                controller:
                                    dateinput, //editing controller of this TextField
                                decoration: InputDecoration(
                                  errorMaxLines: 2,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              .019,
                                      horizontal: 2),
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      height: 0.5),
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey.shade500,
                                  ), //icon of text field
                                  hintText: ' Enter Date',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500, fontSize: 14),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  final DateTime pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101));
          
                                  if (pickedDate != null) {
                                    final String formattedDate =
                                        DateFormat(' yyyy-MM-dd')
                                            .format(pickedDate);
          
                                    setState(() {
                                      dateinput.text = formattedDate;
                                      _invoiceDate = dateinput.text;
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .015,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Bill Total',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .0085,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .065,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.5, horizontal: 3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required!';
                                  }
                                },
                                onChanged: (value) => _billTotal = value,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.money,
                                    size: 22,
                                    color: Colors.grey.shade500,
                                  ),
                                  hintText: ' Input Bill Total',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      height: 0.5),
                                  errorMaxLines: 2,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              .023,
                                      horizontal: 2),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .04,
                        right: MediaQuery.of(context).size.width * .04,
                        top: MediaQuery.of(context).size.height * .015,
                        bottom: MediaQuery.of(context).size.height * .00),
                    child: Text(
                      'Document',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .041,
                            right: MediaQuery.of(context).size.width * .041,
                            top: MediaQuery.of(context).size.height * .005),
                        child: GestureDetector(
                          onTap: () async {
                            final isGranted = await checkPermission();
                            if (!isGranted) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Camera permission is required to scan documents');
                              return;
                            }
                            final temp =
                                (await getApplicationSupportDirectory()).path;
                            final String imagePath =
                                "$temp${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg";
                            await EdgeDetection.detectEdge(imagePath);
                            setState(() {
                              _documents.add(imagePath);
                              _documents.add(imagePath);
                              _textFieldController.text = " Image Uploaded";
                              _isImageLoaded = true;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .065,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade500),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height * .019,
                                    horizontal: 4),
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.upload,
                                      color: Colors.grey.shade500,
                                    ),
                                    onPressed: () async {},
                                  ),
                                ),
                              ),
                              controller: _textFieldController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isImageLoaded,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .0085,
                            right: MediaQuery.of(context).size.width * .04),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentColor,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * .14,
                                  MediaQuery.of(context).size.height * .04)),
                          child: Text(
                            "View",
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Center(
                                      child: Text("What do you want to do?",
                                          style: TextStyle(fontSize: 16))),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _documents.removeLast();
                                          _textFieldController.text = "";
                                          _isImageLoaded = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text("View"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        final file = File.fromUri(
                                            Uri.file(_documents.last));
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Image.file(file),
                                              );
                                            });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
          
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .06,
                      right: MediaQuery.of(context).size.width * .06,
                      top: MediaQuery.of(context).size.height * .35,
                      bottom: MediaQuery.of(context).size.height * .017),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: AppColors.accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * .99,
                              MediaQuery.of(context).size.height * .055)),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _documentMemo(widget.transactionType);
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Upload',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400,color: Colors.white),
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _documentMemo(String transaction) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_documents[0] == null) {
        Fluttertoast.showToast(msg: 'No image selected');
        return;
      }

      final imageFile = File(_documents[0]);

      if (imageFile == null) {
        Fluttertoast.showToast(msg: 'Error loading image file');
        return;
      }

      // Create a new PDF document
      final pdf = pw.Document();

      // Decode the image file
      final image = PdfImage.file(
        pdf.document,
        bytes: await imageFile.readAsBytes(),
      );

      // Add the image to the PDF document
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      // Get the temporary directory and create a new file
      final tempDir = await getTemporaryDirectory();
      final File file = await File('${tempDir.path}/temp.pdf').create();

      // Write the PDF document to the file
      await file.writeAsBytes(pdf.save());

      final dio = Dio();
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('user_data'));
      final String userId = userData['userId'];
      final formData = FormData.fromMap({
        'userId': userId,
        'companyId': widget.companyId,
        'transactionType': transaction,
        'invoiceDate': _invoiceDate,
        'storeId': _selectedStoreId,
        'billTotal': _billTotal,
        'document':
            await MultipartFile.fromFile(file.path, filename: 'document.pdf'),
      });
      final response = await dio.post(
          'https://mijnkontinu.nl/api/save-document-memo.php',
          data: formData);

      log(response.data.toString());

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //  behavior: SnackBarBehavior.floating,

          content: const Text(
            'Document Uploaded Successfully!',
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),

          backgroundColor: AppColors.accentColor,
          action: SnackBarAction(
            label: '',
            onPressed: () {},
          ),
        ));
        final generatePdfService = GetIt.I.get<GeneratePdfService>();

        LoadingOverlay.of(context)
            .during(
          generatePdfService.generatePdfFromImages(_documents),
        )
            .then((value) {
          Navigator.of(context).pop(value);
        });
      } else {
        Fluttertoast.showToast(msg: 'Error uploading document');
      }
    }
  }

  Future<void> fetchStoreData() async {
    try {
      final dio = Dio();
      final box = await Hive.openBox('user');
      final userData = jsonDecode(box.get('user_data'));
      final String userId = userData['userId'];
      dio.options.contentType = 'application/json';
      final Response response = await dio.post(
          'https://mijnkontinu.nl/api/fetch-stores-list.php',
          data: {'userId': userId});
      final Map<String, dynamic> jsonData = jsonDecode(response.data);
      if (jsonData['errorCode'] == '0000') {
        if (jsonData['dataList'].length != 0) {
          jsonData['dataList'].forEach((store) {
            _stores[store['storeName']] = store['storeId'];
          });
          _storeNames = _stores.keys.toList();
          if (_storeNames.isNotEmpty) {
            _selectedStore = _storeNames[0];
            _selectedStoreId = _stores[_selectedStore];
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

Future<bool> checkPermission() async {
  // Check permissions and request its
  bool isCameraGranted = await Permission.camera.request().isGranted;
  if (!isCameraGranted) {
    isCameraGranted =
        await Permission.camera.request() == PermissionStatus.granted;
  }

  return isCameraGranted;
}
