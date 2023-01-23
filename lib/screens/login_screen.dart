// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:developer';

import 'package:accounting_portal/screens/email_verify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../widgets/color.dart';
import 'dashboard_screen.dart';
import 'forgot.dart';

Size mq;
DateTime _lastPressedAt;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String _email;
  String _password;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Stack(
      children: [
        WillPopScope(
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq.height * .04, left: mq.width * .03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: mq.height *.03,),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: mq.height * .099,
                              child: Image.asset('assets/images/logo.png'),
                            ),
                          ),
                          const Text(
                            'SNO',
                            style: TextStyle(
                                fontSize: 34,
                                color: AppColors.primaryColor,
                                fontFamily: 'Lemon'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.06,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mq.width * .055),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .055, top: mq.height * .009),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please sign in to continue.',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: mq.width * .04,
                          right: mq.width * .04,
                          top: mq.height * .03),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 1,
                        shadowColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Builder(builder: (BuildContext context) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: mq.height * .03,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: mq.width * .035),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: const Text(
                                              'Email',
                                              style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: mq.height * .007,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.5, horizontal: 3.0),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 245, 250, 255),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SizedBox(
                                              height: mq.height * .063,
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.left,
                                                validator: (val) =>
                                                    validateUserName(
                                                        val.toString()),
                                                onSaved: (value) {
                                                  _email = value;
                                                },
                                                decoration: InputDecoration(
                                                    alignLabelWithHint: true,
                                                    prefixIcon: const Icon(
                                                      Icons.email,
                                                      size: 22,
                                                      color:
                                                          AppColors.accentColor,
                                                    ),
                                                    hintText:
                                                        'Enter your email',
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical: mq.height * .02,
                                                      horizontal:
                                                          mq.width * .01,
                                                    ),
                                                    prefixIconConstraints:
                                                        BoxConstraints(
                                                            minWidth: 30),
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 14),
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: mq.width * .035),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: const Text(
                                              '\nPassword',
                                              style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: mq.height * .007,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: mq.width * .000),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.6,
                                                      horizontal: 3.0),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 245, 250, 255),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: SizedBox(
                                                height: mq.height * .063,
                                                child: TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  obscureText:
                                                      !_passwordVisible,
                                                  validator: (val) {
                                                    if (val.length < 6) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        //  behavior: SnackBarBehavior.floating,

                                                        content: Text(
                                                          'Please fill all the fields',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        duration: Duration(
                                                            seconds: 2),

                                                        backgroundColor:
                                                            AppColors
                                                                .accentColor,
                                                        action: SnackBarAction(
                                                          label: '',
                                                          onPressed: () {},
                                                        ),
                                                      ));
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _password = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          _passwordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: AppColors
                                                              .accentColor,
                                                          size: 22,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _passwordVisible =
                                                                !_passwordVisible;
                                                          });
                                                        },
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  mq.height *
                                                                      .022,
                                                              horizontal:
                                                                  mq.width *
                                                                      .06),
                                                      prefixIconConstraints:
                                                          BoxConstraints(
                                                              minWidth: 30),
                                                      prefixIcon: const Icon(
                                                        Icons.lock,
                                                        size: 22,
                                                        color: AppColors
                                                            .accentColor,
                                                      ),
                                                      hintText:
                                                          'Enter your password',
                                                      hintStyle: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
                                                          fontSize: 14),
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/forgot',
                                                    (route) => false,
                                                  );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: mq.width * .035,
                                            top: mq.height * .01),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: const Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                                color: AppColors.accentColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: mq.width * .035,
                                        right: mq.width * .035,
                                      ),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 1,
                                              backgroundColor:
                                                  AppColors.accentColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              minimumSize: Size(mq.width * .9,
                                                  mq.height * .055)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                _isloading = true;
                                              });
                                              _formKey.currentState.save();
                                              try {
                                                final dio = Dio();
                                                final response = await dio.post(
                                                    'https://mijnkontinu.nl/api/login.php',
                                                    data: {
                                                      'email': _email,
                                                      'password': _password
                                                    });
                                                final Map<String, dynamic>
                                                    jsonData =
                                                    jsonDecode(response.data);
                                                if (jsonData['errorCode'] ==
                                                    '0000') {
                                                  final box =
                                                      await Hive.openBox(
                                                          'user');
                                                  box
                                                    ..put('isLogged', true)
                                                    ..put('user_data',
                                                        response.data);
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/dashboard',
                                                    (route) => false,
                                                  );
                                                } else {
                                                  if (jsonData['errorCode'] ==
                                                      '0001') {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Invalid Credentials');
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: jsonData[
                                                            'errorMessage']);
                                                  }
                                                }
                                              } catch (e) {
                                                // Fluttertoast.showToast(msg: 'No Internet Connection');
                                              } finally {
                                                setState(() {
                                                  _isloading = false;
                                                });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Fill All Fields');
                                              setState(() {
                                                _isloading = false;
                                              });
                                            }
                                          },
                                          child:
                                         Text(
                                            'Login',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                    ),
                                    SizedBox(
                                      height: mq.height * .03,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
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
    );
  }

  String validateUserName(String value) {}
}
