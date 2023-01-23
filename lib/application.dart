import 'package:accounting_portal/screens/doc_history.dart';
import 'package:accounting_portal/screens/file.dart';
import 'package:accounting_portal/screens/stores.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/splash.dart';


class Application extends StatelessWidget {
  final ThemeData _lightTheme = ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    
    primaryColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter',useMaterial3: false,brightness: Brightness.light,visualDensity: VisualDensity.comfortable,),
      routes: routes,
      home: SplashScreen(),
      themeMode: ThemeMode.light,
    );
  }
}




