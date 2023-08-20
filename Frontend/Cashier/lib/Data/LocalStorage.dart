


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

   saveId(Id, value) async {
    print("saveId called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readId() async {
    var Id = await box.read("cashierid");
    return Id;
  }
  Future deleteId() async {
    box.remove('cashierid');
  }
  saveIdshop(Id, value) async {
    print("saveIdshop called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
    readIdshop() async {
    var Id = await box.read("shopownerid");
    return Id;
  }
  Future deleteIdshop() async {
    box.remove('shopownerid');
  }
  saveIduser(Id, value) async {
    print("saveId user called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readIduser() async {
    var Id = await box.read("idvalue");
    return Id;
  }
  Future deleteIduser() async {
    box.remove('idvalue');
  }
  saveIdprofile(Id, value) async {
    print("saveIdprofile called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
    readIdprofile() async {
    var Id = await box.read("profilinfo");
    return Id;
  }
  Future deleteIdprofile() async {
    box.remove('profilinfo');
  }
  saveIdtransaction(Id, value) async {
    print("saveId transaction called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readIdtransaction() async {
    var Id = await box.read("transactionid");
    return Id;
  }
  Future deleteIdtransaction() async {
    box.remove('transactionid');
  }


  saveTransaction_info(Id, value) async {
    print("save transaction called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readname() async {
    var Id = await box.read("transname");
    return Id;
  }
  Future deletename() async {
    box.remove('transname');
  }
  saveprix(Id, value) async {
    print("save prix called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readprix() async {
    var Id = await box.read("transprix");
    return Id;
  }
  Future deleteprix() async {
    box.remove('transprix');
  }
  savePname(Id, value) async {
    print("save product name called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readPname() async {
    var Id = await box.read("productname");
    return Id;
  }
  Future deletePname() async {
    box.remove('productname');
  }
  savePprix(Id, value) async {
    print("save Pprix called");
    await box.write(Id,value);
    //await pref.re(jwtToken,value);
  }
  readPprix() async {
    var Id = await box.read("productvalue");
    return Id;
  }
  Future deletePprix() async {
    box.remove('productvalue');
  }

  logout_clear(){
    // deletePprix();
    // deletePname();
    // deleteprix();
    // deletename();
    // deleteIdtransaction();
    // deleteIdprofile();
    // deleteIduser();
    // deleteIdshop();
     deleteId();
   //deleteToken();


}
  load(){
    print("load called");
    readPprix();
    readPname();
     readprix();
    readname();
     readIdtransaction();
     readIdprofile();
    readIduser();
    readIdshop();
     readId();
    readToken();


  }


}