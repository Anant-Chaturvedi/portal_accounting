import 'package:flutter/material.dart';

import '../widgets/color.dart';
import 'splash.dart';

Size mq;

class Forgot extends StatefulWidget {
  const Forgot();

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
             Padding(
                padding:
                    EdgeInsets.only(top: mq.height * .04, left: mq.width * .03),
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
                    height: mq.height * 0.079,
                  ),
               Padding(
                    padding: EdgeInsets.only(left: mq.width * .055),
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
                        left: mq.width * .055, top: mq.height * .009),
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
              padding: EdgeInsets.only(top: mq.height * .00),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * .03, vertical: mq.height * .05),
                    child: Card(
                          margin: const EdgeInsets.all(8),
                      elevation: 1,
                      shadowColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: mq.width * .04),
                        width: mq.width * 95,
                                    
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                    
                           
                            SizedBox(
                              height: mq.height * .015,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: mq.width * .03),
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
                                    height: mq.height * .007,
                                  ),
                                   Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.5, horizontal: 3.0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 245, 250, 255),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: SizedBox(
                                            height: mq.height * .063,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.left,
                                            
                                              decoration: InputDecoration(
                                                
                                                  alignLabelWithHint: true,
                                                  prefixIcon: const Icon(
                                                    Icons.email,
                                                    size: 22,
                                                    color: AppColors.accentColor,
                                                  ),
                                                  hintText: 'Enter your email',
                                                  contentPadding:
                                                  
                                                      EdgeInsets.symmetric(
                                                          vertical: mq.height * .02,
                                                          horizontal: mq.width * .01,),
                                                          
                                                  prefixIconConstraints:
                                                      BoxConstraints(minWidth: 30),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey.shade500,
                                                      fontSize: 14),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: mq.width * .03,
                                  right: mq.width * .03,
                                  top: mq.height * .03,
                                  bottom: mq.height * .017),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accentColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      minimumSize:
                                          Size(mq.width * .9, mq.height * .053)),
                                  onPressed: () {
                                  },
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(fontSize: 15),
                                  )),
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
    );
  }
}
