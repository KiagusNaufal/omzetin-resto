import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:omsetin_resto/controllers/connectivity_controlller.dart';
import 'package:omsetin_resto/providers/appVersionProvider.dart';
import 'package:omsetin_resto/providers/bluetoothProvider.dart';
import 'package:omsetin_resto/providers/cashierProvider.dart';
import 'package:omsetin_resto/providers/categoryProvider.dart';
import 'package:omsetin_resto/providers/productProvider.dart';
import 'package:omsetin_resto/providers/securityProvider.dart';
import 'package:omsetin_resto/providers/settingProvider.dart';
import 'package:omsetin_resto/providers/userProvider.dart';
import 'package:omsetin_resto/services/authService.dart';
import 'package:omsetin_resto/utils/toast.dart';
import 'package:omsetin_resto/view/page/home/home.dart';
import 'package:omsetin_resto/view/page/login.dart';
import 'package:omsetin_resto/view/page/splash_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// Future<void> deleteOldDatabase() async {
//   final path = join(await getDatabasesPath(), 'master_db.db');
//   await deleteDatabase(path);
//   print('📛 Database lama dihapus');
// }

void main(context) async {
  //*  format tanggal Indonesia
  //*  seperti kamis, jumat dll
  //*  usage: DateFormat.EEEE()
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await deleteOldDatabase();

  Get.put(ConnectivityController());

  await initializeDateFormatting('id_ID', null);

  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCashdrawerOn', false);
  } catch (e) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('Failed to set cashdrawer preference: $e')),
    );
    print('Failed to set cashdrawer preference: $e');
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstInstall = prefs.getBool('isFirstInstall') ?? true;

    if (!prefs.containsKey('queueNumber')) {
      await prefs.setInt('queueNumber', 1);
      print('queueNumber initialized to 1');
    }

    if (!prefs.containsKey('isAutoReset')) {
      await prefs.setBool('isAutoReset', false);
      print('isAutoReset initialized to false');
    }

    if (isFirstInstall) {
      await prefs.setBool('isCashdrawerOn', false);

      Map<String, dynamic> cashierData = {
        'cashierName': "Owner",
        'cashierPin': "123456",
        'cashierId': "1",
      };

      await prefs.setString('cashierData', jsonEncode(cashierData));
      print('Default cashier data set: $cashierData');

      await prefs.setInt("securityPassword", 123456);

      // Set the flag to false after initialization
      await prefs.setBool('isFirstInstall', false);
    }
  } catch (e) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('Failed to set cashdrawer preference: $e')),
    );
    print('Failed to set cashdrawer preference: $e');
  }

  runApp(
    Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => BluetoothProvider()),
          ChangeNotifierProvider(create: (_) => SettingProvider()),
          ChangeNotifierProvider(create: (_) => CashierProvider()),
          ChangeNotifierProvider(create: (_) => SecurityProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => AppVersionProvider()),
        ],
        child: MainApp(),
      );
    }),
  );

  // Check internet connection
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OMZETin Resto',
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
