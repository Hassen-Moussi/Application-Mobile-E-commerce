


import 'package:get_storage/get_storage.dart';

class LocalStorage{
  final box =GetStorage();


  void saveToken(jwtToken, value) async {
    print("saveToken called");
    await box.write(jwtToken,value);
    //await pref.re(jwtToken,value);
  }
  void saveEmail(email, value) async {
    print("saveEmail called");
    await box.write(email,value);
    //await pref.re(jwtToken,value);
  }
  readEmail() async {
    var email = await box.read("email");
    return email;
  }
  Future deleteEmail() async {
    box.remove('email');
  }

  readToken() async {
    var token = await box.read("token");
    return token;
  }
  Future deleteToken() async {
    box.remove('token');
  }

}