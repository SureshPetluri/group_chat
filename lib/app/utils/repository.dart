

import 'package:get_storage/get_storage.dart';

class SignInRepository {
 static GetStorage signInStorage = GetStorage("SIGN_IN_REPOSITORY");

 static void eraseSignInData() {
    signInStorage.erase();
  }
 static void setUserId(String userId) => signInStorage.write("userId", userId);
  static String getUserId() => signInStorage.read("userId") ?? "";

}