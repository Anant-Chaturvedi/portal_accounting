import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import '../widgets/color.dart';
import 'login_screen.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.accentColor));

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .04,
                          left: MediaQuery.of(context).size.width * .03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height:  MediaQuery.of(context).size.height *.03,),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .099,
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
                      height: MediaQuery.of(context).size.height * 0.079,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .055),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .055,
                          top: MediaQuery.of(context).size.height * .009),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please enter your email, a link with reset password would be sent to you.',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .00),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * .03,
                                vertical:
                                    MediaQuery.of(context).size.height * .05),
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              elevation: 1,
                              shadowColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                            .04),
                                width: MediaQuery.of(context).size.width * 95,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .015,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .03),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Email',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .007,
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .063,
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 15),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.email,
                                                    color:
                                                        AppColors.accentColor,
                                                  ),
                                                  border: InputBorder.none,
                                                  // labelText: "Email",
                                                  hintText: "example@email.com",
                                                  hintStyle: TextStyle(fontSize: 14)
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        'Please Enter an email address',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          AppColors.accentColor,
                                                      action: SnackBarAction(
                                                        label: '',
                                                        onPressed: () {},
                                                      ),
                                                    ));
                                                  }
                                                  if (!RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value)) {
                                                    //   ScaffoldMessenger.of(
                                                    //         context)
                                                    //     .showSnackBar(SnackBar(
                                                    //   content: Text(
                                                    //     'Please enter a valid email address',
                                                    //     style: TextStyle(
                                                    //         color:
                                                    //             Colors.white),
                                                    //   ),
                                                    //   duration:
                                                    //       Duration(seconds: 2),
                                                    //   backgroundColor:
                                                    //       AppColors.accentColor,
                                                    //   action: SnackBarAction(
                                                    //     label: '',
                                                    //     onPressed: () {},
                                                    //   ),
                                                    // ));
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) =>
                                                    _email = value,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .03,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .03,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .03,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .017),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.accentColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .053)),
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
                                                  'https://mijnkontinu.nl/api/verify-email.php',
                                                  data: {
                                                    'email': _email,
                                                  });
                                              log(response.data);
                                              final Map<String, dynamic>
                                                  jsonData =
                                                  jsonDecode(response.data);
                                              if (jsonData['errorCode'] ==
                                                  '0000') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  //  behavior: SnackBarBehavior.floating,

                                                  content: Text(
                                                    'Email Verified',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),

                                                  backgroundColor:
                                                      AppColors.accentColor,
                                                  action: SnackBarAction(
                                                    label: '',
                                                    onPressed: () {},
                                                  ),
                                                ));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SuccessPage(
                                                                email:
                                                                    _email)));
                                              } else {
                                                if (jsonData['errorCode'] ==
                                                    '0001') {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Invalid Email id');
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
                                                msg: 'Please Fill All Fields');
                                            setState(() {
                                              _isloading = false;
                                            });
                                          }
                                        },
                                        child: Text("Continue"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
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

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      verifyEmail(_email);
    }
  }

  void verifyEmail(String email) async {
    try {
      var response = await http.post(
          Uri.parse('https://mijnkontinu.nl/api/verify-email.php'),
          body: {'email': email});

      log(response.body);

      var jsonResponse = json.decode(response.body);
      if (jsonResponse["errorCode"] == "0000") {
        log("Email Verified!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessPage(email: _email)));
      } else {
        log("Invalid Email id");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class SuccessPage extends StatefulWidget {
  final String email;

  SuccessPage({Key key, @required this.email}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final _formKey = GlobalKey<FormState>();

  String _newPass;

  String _reTypePass;

  bool _isloading = false;
  bool _error = false;
  bool _errorF = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.accentColor));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login-screen',
          (route) => false,
        );
        return true;
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .04,
                            left: MediaQuery.of(context).size.width * .03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(height:  MediaQuery.of(context).size.height *.03,),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .099,
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
                        height: MediaQuery.of(context).size.height * 0.079,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .055),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .00),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .03,
                                  vertical:
                                      MediaQuery.of(context).size.height * .05),
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                elevation: 1,
                                shadowColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.width *
                                              .04),
                                  width: MediaQuery.of(context).size.width * 95,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .015,
                                      ),

                                      //copy
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .03),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'New Password',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .007,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.5,
                                                      horizontal: 3.0),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 245, 250, 255),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .063,
                                                child: TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 14),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .02,
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .01,
                                                    ),
                                                    prefixIconConstraints:
                                                        BoxConstraints(
                                                            minWidth: 30),
                                                    prefixIcon: Icon(
                                                      Icons.lock_outline_sharp,
                                                      size: 22,
                                                      color:
                                                          AppColors.accentColor,
                                                    ),
                                                    border: InputBorder.none,
                                                    // labelText: "Email",
                                                    hintText: _errorF
                                                        ? null
                                                        : "Enter here",
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    setState(() {
                                                      _error = true;
                                                    });
                                                    if (value.isEmpty) {
                                                      setState(() {
                                                        _errorF = true;
                                                      });
                                                      return 'This field is required';
                                                    }
                                                    
                                                  },
                                                  onSaved: (value) =>
                                                      _newPass = value,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .03),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Re-type New Password',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .007,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.5,
                                                      horizontal: 3.0),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 245, 250, 255),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .063,
                                                child: TextFormField(
                                                    style:
                                                      TextStyle(fontSize: 14),
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 14),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .022,
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .01,
                                                    ),
                                                    prefixIconConstraints:
                                                        BoxConstraints(
                                                            minWidth: 30),
                                                    prefixIcon: Icon(
                                                      Icons.lock_outline_sharp,
                                                      color:
                                                          AppColors.accentColor,
                                                          size: 22,
                                                    ),
                                                    border: InputBorder.none,
                                                    // labelText: "Email",
                                                    hintText: _error
                                                        ? null
                                                        : "Enter here",
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      setState(() {
                                                        _error = true;
                                                      });
                                                      return "This field is required";
                                                    }

                                                    return null;
                                                  },
                                                  onSaved: (value) =>
                                                      _reTypePass = value,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .03,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .03,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .03,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .017),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.accentColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .9,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .053)),
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
                                                    'https://mijnkontinu.nl/api/reset-password.php',
                                                    data: {
                                                      'email': widget.email,
                                                      'newPassword': _newPass,
                                                      'reTypePassword':
                                                          _reTypePass
                                                    });
                                                log(response.data);
                                                final Map<String, dynamic>
                                                    jsonData =
                                                    jsonDecode(response.data);
                                                if (jsonData['errorCode'] ==
                                                    '0000') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      'Password Updated Successfully',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
                                                    backgroundColor:
                                                        AppColors.accentColor,
                                                    action: SnackBarAction(
                                                      label: '',
                                                      onPressed: () {},
                                                    ),
                                                  ));
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen()));
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
                                                print(e);
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
                                          child: Text("Continue"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Text("Email Verified"), Text('$email')
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
      ),
    );
  }
}
