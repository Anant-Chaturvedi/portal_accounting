import 'dart:convert';
import 'dart:developer';

import 'package:accounting_portal/screens/doc_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../widgets/color.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String userName;
  final _formKey = GlobalKey<FormState>();

  Future<String> getUserName() async {
    final box = await Hive.openBox('user');
    final userData = jsonDecode(box.get('user_data'));
    userName = userData['userName'];
    return userName;
  }

  bool _hasText = false;
  String _name;
  String _newP;
  String _oldP;
  bool _isloading = false;
  @override
  void initState() {
    getUserName();
    super.initState();
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
        child: Stack(
          children: [
            SafeArea(
              child: Scaffold(
                backgroundColor: offWhite,
                appBar: AppBar(
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contex) => DashboardScreen()));
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
                body: Theme(
                  data: ThemeData.light(useMaterial3: true),
                  child: CupertinoPageScaffold(
                
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 16.0, bottom: 16, left: 10, right: 10),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 20, bottom: 4),
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
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Update Name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.0, bottom: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.5, horizontal: 3.0),
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 245, 250, 255),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height * .055,
                                          child: FutureBuilder(
                                            future: getUserName(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return TextFormField(
                                                  textAlign: TextAlign.left,
                                                  decoration: InputDecoration(
                                                    hintText: snapshot.data,
                                                    alignLabelWithHint: true,
                                                    prefixIcon: const Icon(
                                                      Icons.person,
                                                      size: 22,
                                                      color: AppColors.accentColor,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .height *
                                                                    .017,
                                                            horizontal:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    .06),
                                                    border: InputBorder.none,
                                                    prefixIconConstraints:
                                                        BoxConstraints(minWidth: 30),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey.shade500,
                                                        fontSize: 14),
                                                  ),
                                                  onSaved: (value) => _name = value,
                                                  onChanged: (value) {
                                                    if (value.length > 0) {
                                                      setState(() {
                                                        _hasText = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _hasText = false;
                                                      });
                                                    }
                                                  },
                                                  // controller: _controller,
                                                  enabled: true,
                                                );
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 10, right: 10),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
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
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          'Update Password',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.5, horizontal: 3.0),
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 245, 250, 255),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height * .055,
                                          child: TextFormField(
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  size: 22,
                                                  color: AppColors.accentColor,
                                                ),
                                                hintText: 'Current Password',
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .017,
                                                    horizontal: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .06),
                                                prefixIconConstraints:
                                                    BoxConstraints(minWidth: 30),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 14),
                                                border: InputBorder.none),
                                            onSaved: (value) => _newP = value,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.0, bottom: 16),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.5, horizontal: 3.0),
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 245, 250, 255),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height * .055,
                                          child: TextFormField(
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  size: 22,
                                                  color: AppColors.accentColor,
                                                ),
                                                hintText: 'New Password',
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .017,
                                                    horizontal: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .06),
                                                prefixIconConstraints:
                                                    BoxConstraints(minWidth: 30),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 14),
                                                border: InputBorder.none),
                                            onSaved: (value) => _oldP = value,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                                right: 6,
                                top: 32,
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accentColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width * .9,
                                          MediaQuery.of(context).size.height * .055)),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _isloading = true;
                                      });
                                      _formKey.currentState.save();
                  
                                      try {
                                        final dio = Dio();
                                         final box = await Hive.openBox('user');
                      final userData = jsonDecode(box.get('user_data'));
                      final String userId = userData['userId'];
                                        final response = await dio.post(
                                            'https://mijnkontinu.nl/api/update-profile.php',
                                            data: {
                                              'userId': userId,
                                              'userName': _hasText ? _name : userName,
                                              'currentPassword': _oldP,
                                              'newPassword': _newP,
                                              'mode': _hasText ? 'name' : 'password'
                                            });
                                        log(response.data);
                                        final Map<String, dynamic> jsonData =
                                            jsonDecode(response.data);
                                        if (jsonData['errorCode'] == '0000') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              'Profile Updated',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: AppColors.accentColor,
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {},
                                            ),
                                          ));
                                         Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/settings',
                                            (route) => false,
                                          );
                                        } else {
                                          if (jsonData['errorCode'] == '0001') {
                                           
                                            // Fluttertoast.showToast(
                                            //     msg: 'Invalid Credentials');
                                          } else {
                   ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              'Old Password does not match!',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: AppColors.accentColor,
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {},
                                            ),
                                          ));
                                            // Fluttertoast.showToast(
                                            //     msg: jsonData['errorMessage']);
                                          }
                                        }
                                      } catch (e) {
                                        print(e);
                                      } finally {
                                        setState(() {
                                          _isloading = false;
                                        });
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Fill All Fields');
                                      setState(() {
                                        _isloading = false;
                                      });
                                    }
                                  },
                                 
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 16,color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
             Visibility(
            visible: _isloading,
            child: Positioned.fill(
              child: Scaffold(
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 29, 141, 252),
                  ))),
            )),
          ],
        ),
      ),
    );
  }
}
