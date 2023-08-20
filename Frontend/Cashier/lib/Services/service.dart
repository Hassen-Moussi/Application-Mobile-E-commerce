import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';


import 'dart:convert';



import '../Data/LocalStorage.dart';
import '../routes/routes.dart';


class MyHttpOverrides extends HttpOverrides {
  // @override
  // HttpClient createHttpClient(SecurityContext? context){
  //   return super.createHttpClient(context)
  //     ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  // }
}

final storage = new FlutterSecureStorage();
String URL='http://192.168.1.214:5031';
class userformservice {

  Future<dynamic> login(String email, String password) async {
    final url = '$URL/Authentification/login';
    final body = jsonEncode({'Email': email, 'Password': password});
    final headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 400 && email.isNotEmpty && password.isNotEmpty){
      Get.snackbar("Error", "Email or Password Incorrect",colorText: Colors.red);
    }
    if (response.statusCode == 500) {
      Get.offAllNamed(Croutes.NC);
    }
    final data = jsonDecode(response.body);
    final status = data['status'];
    final errors = data['errors'];
    final message = data['message'];
    final dataresponse = json.decode(response.body);
    final decodedtoken = JwtDecoder.decode(dataresponse['token']);
    final role = decodedtoken['role'];
    if (response.statusCode == 200 && (role == 'shopowner' || role == 'cashier')) {
      Get.offAllNamed(role == 'shopowner' ? Croutes.shopowner : Croutes.home);
      final id = decodedtoken['Id'];
      await storage.write(key: 'cashierid', value: id);
      Get.snackbar(
        'Login Successfuly',
        '',
        titleText: Text(
          'Login Successfuly',
          style: TextStyle(color: Colors.green),
        ),
        messageText: Text(
          'Welcome',
          style: TextStyle(color: Colors.green),
        ),
        colorText: Colors.green,
        icon: Icon(
          Icons.verified,
          color: Colors.green,
        ),
        shouldIconPulse: true,
      );
    } else {
      Get.snackbar(
        errors.toString(),
        '',
        titleText: Text(
          'Something went wrong',
          style: TextStyle(color: Colors.red),
        ),
        messageText: Text(
          errors.toString(),
          style: TextStyle(color: Colors.red),
        ),
        colorText: Colors.red,
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        shouldIconPulse: true,
      );
    }
  }


  Future<Object?> getbyid(employeeid) async {
    var url = '$URL/ManageUsers/GetUsersbYid?id=';
    Map<String, String> headersAuth = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    };
    var response = await http.get(
      Uri.parse(url + "${employeeid}"),
      headers: headersAuth,
    );
    final data = json.decode(response.body);
    var status = data['status'];
    var message = data['message'];
    var _data = data['data'];
    if (response.statusCode == 200) {
      var status = data['status'];
      var message = data['message'];
      var errors = data['errors'];
      print(response.body);
      var result = response.body;
      Map dataresponse = json.decode(result);
      print(dataresponse["casierId"]);
      print(dataresponse["shopOwnerIdMoreInfo"]);
      await storage.write(key: 'shopownerid', value: dataresponse["shopOwnerIdMoreInfo"]);
      await storage.write(key: 'idvalue', value: dataresponse["casierId"]);
      await storage.write(key: 'profilinfo', value: response.body);
    } else if (response.statusCode == 401) {
      Get.snackbar(
        'Something Wrong',
        'Please Reconnect ',
      );
    } else {
      return null;
    }
  }



  Future<dynamic> getall() async {
    var url = '$URL/ManageUsers/getall';
    Map<String, String> headersAuth = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
      'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjQ1NDQ2ZDIzLTQzNjAtNGI1Zi04YzkwLTk0MmJhOTQ4ZGQ3NiIsInN1YiI6Imhhc3Nlbi50bi5tb3Vzc2lAZ21haWwuY29tIiwiZW1haWwiOiJoYXNzZW4udG4ubW91c3NpQGdtYWlsLmNvbSIsImp0aSI6ImJkODEwODU1LTI5ODEtNDMwYi05M2UwLWQ0ODc2NmQyYTMzZCIsImlhdCI6MTY3ODM2ODcwMiwicm9sZSI6ImVtcGxveWVlIiwibmJmIjoxNjc4MzY4NzAyLCJleHAiOjE2NzgzNjg3NjJ9.yDIFB2jUfKMT9TiF13t8WnBzWjvwYLnOu9aJZtpli5E',
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headersAuth,
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else if (response.statusCode == 401) {
      Get.snackbar(
        'Something Wrong',
        'Please Reconnect ',
      );
    } else {
      return null;
    }
  }

  /******************************************************___Change Passward Service___***********************************************************************/
  void changePassword(
      username, currentPassword, newPassword, confirmNewPassword) async {
    final url = '$URL/Authentification/changepassword';
    var body = jsonEncode({
      'username': username,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    });

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if (response.statusCode == 200) {
      Get.snackbar(status, message, colorText: Colors.green);
      Get.offAllNamed(Croutes.Pcreated);
    } else if (response.statusCode == 400){
      print(data);
      Get.snackbar(status, message, colorText: Colors.orange);
    }
    else{
      Get.snackbar(status, message, colorText: Colors.red);
    }
  }

  /******************************************************___Forgot Passward Service___***********************************************************************/
  void forgotPassword(email) async {
    final url = '$URL/Authentification/SendPasswordResetCode';
    var body = jsonEncode({
      'email':email,
    });

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json', 'accept': '*/*'},
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if(response.statusCode == 400){
      Get.snackbar('Opps', 'You should type your email', colorText: Colors.red);
    }
    if (response.statusCode == 200) {
      Get.snackbar(status, message, colorText: Colors.green);
      Get.offAndToNamed(Croutes.otp);
    } else {
      print(data);
      Get.snackbar(status, message, colorText: Colors.red);
    }
  }
  /******************************************************___Verif OTP Service___***********************************************************************/


  void verifotp(
      otp,mail) async {
    final url = '$URL/Authentification/Verifotp';
    var body = jsonEncode({
      'email': mail,

      'otp': otp,

    });


    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if(response.statusCode == 400){
      Get.snackbar('Opps', 'You should typing the Code', colorText: Colors.red);
    }
    if (response.statusCode == 200) {
      Get.snackbar(status, message, colorText: Colors.green);
      Get.offAllNamed(Croutes.Cpassword);
    } else {
      print(data);
      Get.snackbar(status, message, colorText: Colors.red);
    }
  }
  /******************************************************___Restore_Password_ Service___***********************************************************************/


  LocalStorage strg =  LocalStorage();
  var Mail;

  void restore_password(
      mail, newPassword,Rpassword) async {
    final url = '$URL/Authentification/ResetPassword';
    var body = jsonEncode({
      'email': mail,

      'newPassword': newPassword,

    });


    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if(response.statusCode == 500) {
      Get.snackbar('Opps',
          'You sould type your New Password',
          colorText: Colors.red);
    }
    else
      if(newPassword!=Rpassword) {
      Get.snackbar('Opps',
          'You sould Repeat The Password',
          colorText: Colors.red);
    }

    else if (response.statusCode == 200) {
      Get.snackbar(status, message, colorText: Colors.green);
      Get.offAllNamed(Croutes.Pcreated);

    } else {
      print(data);
      Get.snackbar(status, message, colorText: Colors.red);
    }



  }
  Future<Object?> UpdateProfileusername(String? id, String? username) async {
    dynamic employid = await storage.read(key: 'idvalue');
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    final dynamic employer3 = dataresponse["cassier"];
    String username1 = employer3["userName"].toString();
    var url = '$URL/Authentification/updateemployeeUsername?id=$id&username=$username';
    var headersAuth = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    };
    String jsonBody = '{"emplyid":"$employid","username":"$username1"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headersAuth,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print(response.body);
      Get.snackbar(
        'Success',
        '${response.body}', colorText: Colors.green,
      );

    } else if (response.statusCode == 401) {

        Get.snackbar("Something Wrong", "Username has not been changed  ", colorText: Colors.red);





    } else {
      return null;
    }
  }
  /*______________________________________-update adresse-_________________________________________*/
  Future updateCashierAdresse(String id, String adresse) async {
    final url = Uri.parse('$URL/Authentification/updateCashierAdresse?id=$id&adresse=$adresse');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      Get.snackbar("Success", "${response.body}", colorText: Colors.green);
    } else if (response.statusCode == 401) {

      Get.snackbar("Something Wrong", "${response.body}", colorText: Colors.red);
      Get.offAllNamed(Croutes.home);





    } else {
      return null;
    }
}


/** Add Transactions for Cashier **/
  Future<http.Response> addTransaction(String cashierid, String name, double prix) async {
    final String apiUrl = '$URL/ManageUsers/AddTransaction?cashierid=$cashierid&name=$name&prix=$prix';
    final http.Response response = await http.post(Uri.parse(apiUrl));
    print(response.body);
    final data = jsonDecode(response.body);
    print(data);
    print(data["id"]);
    await storage.write(key: 'transactionid', value: data["id"]);
    return response;
  }


  /** get Cashier Transactions **/
  Future<List<Map<String, dynamic>>?> getAllTransactions(String? id) async {
    var url = '$URL/ManageUsers/getallCashiertransactions?id=$id';
    Map<String, String> headersAuth = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headersAuth,
    );
    if (response.statusCode == 200) {
      List<dynamic> dataList = json.decode(response.body);
      List<Map<String, dynamic>> transactions = dataList.map((item) {
        Map<String, dynamic> transaction = Map<String, dynamic>.from(item);
        // Convert 'prix' value to double if it exists
        if (transaction.containsKey('prix') && transaction['prix'] != null) {
          transaction['prix'] = double.parse(transaction['prix'].toString());
        }
        return transaction;
      }).toList();
      for (var transaction in transactions) {
        await storage.write(key: 'transname', value: transaction["name"]);
        await storage.write(key: 'transprix', value: transaction["prix"].toString());
      }
      return transactions;
    }
    return null;
  }




  Future<List<dynamic>> getCashiers() async {
    final response = await http.get(
        Uri.parse('$URL/ManageUsers/GetCashiers'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to load cashiers');
    }
  }

  Future<List<dynamic>> fetchTransactions() async {
    final response = await http.get(
        Uri.parse('$URL/ManageUsers/GetTransactions'));
    final data = json.decode(response.body);
    var result = response.body;
    List<dynamic> dataresponse = json.decode(result);

    for (int i = 0; i < dataresponse.length; i++) {
      print(dataresponse[i]["employeeid"]);
    }
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('Failed to load transactions');
    }
  }


  Future<void> deleteCashier(String cashierId) async {
    final url = Uri.parse('$URL/ManageUsers/DeleteCashier/$cashierId');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Cashier deleted successfully');
    } else {
      throw Exception('Failed to delete cashier');
    }
  }


  Future<void> deleteTransactions(String transactionid) async {
    final url = Uri.parse(
        '$URL/ManageUsers/Deletetransaction/$transactionid');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      // Employee deleted successfully
    } else {
      throw Exception('Failed to delete transaction');
    }
  }

  /** take all balance from cashier as a shopowner **/
  Future<bool> updateCashierBalance(String id, String shopOwnerId) async {
    var url = Uri.parse('$URL/ManageUsers/TakeAllCashierBalance?id=$id&shopOwnerId=$shopOwnerId');
    var response = await http.put(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      return true;
    } else {
      // Handle error
      return false;
    }
  }

/** take by amount from cashier as a shopowner **/

  Future<String> updateCashierBalancebyamount(String id, double amount, String shopOwnerId) async {
    final response = await http.put(
      Uri.parse('$URL/ManageUsers/updateCashierBalanceByAmount?id=$id&amount=$amount&shopOwnerId=$shopOwnerId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar('Notification', 'Balance Retrieved Successfuly', colorText: Colors.green);
      return 'balance updated';
      Get.snackbar('Notification', 'Balance Retrieved Successfuly');
    } else if (response.statusCode == 400) {
      Get.snackbar('Errror', 'Cashier balance is not sufficient to complete the transaction', colorText: Colors.orange);
      return 'Cashier balance is not sufficient to complete the transaction.';
    } else {
      Get.snackbar('Error', 'Cashier not found', colorText: Colors.red);
      return 'Cashier not found.';
    }
  }

  /** get cashier by id **/
  Future<Map<String, dynamic>> getCashierById(String id) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/GetCashierById/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to get cashier by ID.');
    }
  }

  /** get shopowner username **/
  Future<String> getShopownerUsername(String id) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/getShopownerusername?id=$id'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get shopowner username');
    }
  }
  /** get Cashier username **/
  Future<String> getCashierUsername(String id) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/getCashierusername?id=$id'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get cashier username');
    }
  }
  /** get Employee username **/
  Future<String> getEmployeeUsername(String id) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/getEmployeeusername?id=$id'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get Employee username');
    }
  }


  /** Get Cashier Balance History **/
  Future<List<dynamic>> getCashierBalanceHistory(String cashierId) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/Cashierbalancehistory?Cashierid=$cashierId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to load cashier balance history');
    }
  }

  /*_______________________________________---Register-New-Employee---______________________________________________________*/
  Future<Object?> AddNewuser(userName, password, Email, role, adresse,balance
      ) async {
    // HttpOverrides.global = MyHttpOverrides();
    var url = '$URL/Authentification/RegisterCasier';
    var body = jsonEncode({
      'name': userName,
      'email': Email,
      'Password': password,
      'role': role,
      'adresse': adresse,
      'balance': balance,
    });
    var headers = {
      'Content-Type': 'application/json',
      // 'Charset':'utf-8',
      // 'connection': 'keep-alive',
      "Accept": "application/json",
      // "Access-Control_Allow_Origin": "*",
    };
    print(body);
    var response = await http.post(
        Uri.parse(url), headers: headers, body: body);
    print(response.statusCode);
    final data = jsonDecode(response.body);
    print(data);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if (response.statusCode == 200) {
      Get.offAllNamed(Croutes.tomail);
      Get.snackbar(status, message, colorText: Colors.green);

    } else {
      Get.snackbar("Error", '$errors', colorText: Colors.red);
      print(status);
      print(message);
      print(errors);
    }
  }


/*_______________________________________________--- End-Register---______________________________________________________*/


  /** Get Shopowner Amount Taken History **/
  Future<List<dynamic>> getShopownerAmountTakenBalanceHistory(String shopownerid) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/Shopowneramounttakenehistory?Shopownerid=$shopownerid'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to load cashier balance history');
    }
  }



}


