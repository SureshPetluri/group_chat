import 'package:academic/app/modules/login/login_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/utils/theme/color_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB9paVlKkB4PmJKhKU0aLRRjW-OVqNnXsM",
        appId: "1:695192526641:android:c525b3e3630b7e12179a10",
        messagingSenderId: "695192526641",
        projectId: "localstocks-bf5ed",
        storageBucket: "localstocks-bf5ed.appspot.com"),
  );
  FirebaseAppCheck.instance.activate();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context),
      home: const LoginPage(),
    );
  }

  ThemeData buildTheme(BuildContext context) {
    var themeData = Theme.of(context);
    return themeData.copyWith(
        inputDecorationTheme: buildInputDecorationTheme(themeData),
        checkboxTheme: themeData.checkboxTheme.copyWith(
          fillColor: WidgetStateColor.resolveWith((_) => whiteColor),
          checkColor: WidgetStateColor.resolveWith((_) => blackColor),
        ));
  }

  InputDecorationTheme buildInputDecorationTheme(ThemeData themeData) {
    return themeData.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: whiteColor,
      // isDense: true,
      // isCollapsed: true,

      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      // hintStyle: Colors.black38,
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }
}
