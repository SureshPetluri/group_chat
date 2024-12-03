import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../modules/login/login_screen.dart';
import '../widgets/snackbars_widget.dart';

class FirebaseMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> logOut(BuildContext context) async {
    await _auth.signOut();

  }
}
