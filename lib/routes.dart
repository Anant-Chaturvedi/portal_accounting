import 'package:accounting_portal/screens/doc_history.dart';
import 'package:accounting_portal/screens/email_verify.dart';
import 'package:accounting_portal/screens/file.dart';
import 'package:accounting_portal/screens/forgot.dart';
import 'package:accounting_portal/screens/login_screen.dart';
import 'package:accounting_portal/screens/settings_page.dart';

import 'screens/dashboard_screen.dart';
import 'screens/doc_scan_screen.dart';

final routes = {
  '/dashboard': (_) => DashboardScreen(),
  '/docscan': (_) => const DocScanScreen(),
  '/login-screen': (_) => const LoginScreen(),
  '/settings':(_)=> const SettingsPage(),
'/file':(_)=> FileListPage(),
'/hist':(_)=>FilePage(),
'/forgot':(_)=> EmailVerificationPage(),

};
