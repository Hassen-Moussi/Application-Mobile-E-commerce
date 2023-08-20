import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../Models/user.dart';
import '../data/LocalStrorage.dart';
import '../routes/routes.dart';



class MyHttpOverrides extends HttpOverrides{
  // @override
  // HttpClient createHttpClient(SecurityContext? context){
  //   return super.createHttpClient(context)
  //     ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  // }
}
final storage = new FlutterSecureStorage();
String URL='http://192.168.1.214:5031';
class userformservice {

  // Future<User?> Adduser(firstname, lastname, Email, Password, PasswordConfirmed,
  //     PhoneNumber, CompanyName, RhNumber, DateofBirth, Cin) async {
  //   // HttpOverrides.global = MyHttpOverrides();
  //   var url = 'http://192.168.1.61:5031/api/User/Adduser';
  //   var body = jsonEncode({
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'Email': Email,
  //     'Password': Password,
  //     'PasswordConfirmed': PasswordConfirmed,
  //     'PhoneNumber': PhoneNumber,
  //     'CompanyName': CompanyName,
  //     'RhNumber': RhNumber,
  //     'DateofBirth': DateofBirth,
  //     'Cin': Cin,});
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     // 'Charset':'utf-8',
  //     // 'connection': 'keep-alive',
  //     "Accept": "application/json",
  //     // "Access-Control_Allow_Origin": "*",
  //   };
  //   print(body);
  //   var response = await http.post(
  //       Uri.parse(url), headers: headers, body: body);
  //   print(response.statusCode);
  //   final data = jsonDecode(response.body);
  //   print(data);
  //   var status = data['status'];
  //   var errors = data['errors'];
  //   var message = data['message'];
  //   if (response.statusCode == 200) {
  //     print(status);
  //     print(message);
  //     print(errors);
  //   } else {
  //     print(status);
  //     print(message);
  //     print(errors);
  //   }
  // }


  Future<dynamic> login(Email, Password) async {
    late String id;
    String valide_MESSAGE = 'Welcome';
    // HttpOverrides.global = MyHttpOverrides();
    var url = '$URL/Authentification/login';
    var body = jsonEncode({
      'Email': Email,
      'Password': Password});
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
    if (response.statusCode == 400 && Email.isNotEmpty && Password.isNotEmpty){
      Get.snackbar("Error", "Email or Password Incorrect",colorText: Colors.red);
    }
    if (response.statusCode == 500 ) {
      // Redirect the user to the home page
      Get.offAllNamed(Croutes.NC);}
    final data = jsonDecode(response.body);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    Map dataresponse = json.decode(response.body);
    Map <String, dynamic> decodedtoken = JwtDecoder.decode(
        dataresponse['token']);
    String role = decodedtoken['role'];
    if (response.statusCode == 200 && role == 'employer') {
      // Redirect the user to the admin page
      Get.offAllNamed(Croutes.EmployerPage);

      Get.snackbar(
          valide_MESSAGE,
          '!!',
          titleText: Text(
              "Login Successfuly", style: TextStyle(color: Colors.green)),
          messageText: Text(
            valide_MESSAGE, style: TextStyle(color: Colors.green),),
          colorText: Colors.green,
          icon: Icon(
            Icons.verified,
            color: Colors.green,
          ),
          shouldIconPulse: true
      );
      String id = decodedtoken['Id'];
      print(role);
      print(id);
      await storage.write(key: 'employerid', value: id);
    } else if (response.statusCode == 200 && role == 'employee') {
      // Redirect the user to the home page
      Get.offAllNamed(Croutes.home);

      Get.snackbar(
          valide_MESSAGE,
          '!!',
          titleText: Text(
              "Login Successfuly", style: TextStyle(color: Colors.green)),
          messageText: Text(
            valide_MESSAGE, style: TextStyle(color: Colors.green),),
          colorText: Colors.green,
          icon: Icon(
            Icons.verified,
            color: Colors.green,
          ),
          shouldIconPulse: true
      );
      String id = decodedtoken['Id'];
      print(role);
      print(id);
      await storage.write(key: 'employeeid', value: id);
    }
    else {
      Get.snackbar(
          errors.toString(),
          '!!',
          // snackPosition: SnackPosition.BOTTOM
          titleText: Text(
              "somthing went wrong", style: TextStyle(color: Colors.red)),
          messageText: Text(
            errors.toString(), style: TextStyle(color: Colors.red),),
          colorText: Colors.red,
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
          shouldIconPulse: true
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
      print(dataresponse["employeeId"]);
      await storage.write(key: 'idemployer', value: dataresponse["idMoreInfo"]);
      await storage.write(key: 'idvalue', value: dataresponse["employeeId"]);
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


  Future<Object?> UpdateProfilenumtel(String? id, String? NumTel) async {
    dynamic emplyid = await storage.read(key: 'idvalue');
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    String NumTel1 = dataresponse["numTel"].toString();
    var url = '$URL/Authentification/UpdateEmployeenumtel?id=$id&NumTel=$NumTel';
    var headersAuth = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
    };
    String jsonBody = '{"emplyid":"$emplyid","numTel":"$NumTel1"}';
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
      Get.snackbar(
          'Something Wrong',
          'Please Reconnect ', colorText: Colors.red
      );
    } else {
      return null;
    }
  }

  Future<Object?> UpdateProfileusername(String? id, String? username) async {
    dynamic employid = await storage.read(key: 'employeeid');
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    final dynamic employer3 = dataresponse["employer"];
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
        '${response.body}',colorText: Colors.green,
      );
    } else if (response.statusCode == 401) {
      Get.snackbar(
          'Something Wrong',
          'Please Reconnect ', colorText: Colors.red
      );
    } else {
      return null;
    }
  }


  // Future<Object?> UpdateProfileUsername(String? id ,String? username) async {
  //   dynamic emplyid = await storage.read(key: 'idvalue');
  //   dynamic value = await storage.read(key:'profilinfo');
  //   Map dataresponse = json.decode(value);
  //   String NumTel1 = dataresponse["numTel"].toString();
  //   var url = 'http://192.168.1.213:5031/Authentification/updateemployee?id=$id&NumTel=$NumTel';
  //   var headersAuth = {
  //     'Content-Type': 'application/json',
  //     "Accept": "application/json",
  //     "Access-Control_Allow_Origin": "*",
  //   };
  //   String jsonBody= '{"emplyid":"$emplyid","numTel":"$NumTel1"}';
  //   var response = await http.put(
  //     Uri.parse(url),
  //     headers: headersAuth,
  //     body: jsonBody,
  //   );
  //
  //   if (response.statusCode == 200) {
  //
  //     print(response.body);
  //   }else if(response.statusCode==401){
  //     Get.snackbar(
  //       'Something Wrong',
  //       'Please Reconnect ',
  //     );
  //   }else{
  //     return null;
  //   }
  // }

  Future<http.Response> UpdateBalance(String? idemployee, String? idcashier,
      double value) async {
    dynamic emplyid = await storage.read(key: 'idvalue');
    dynamic value1 = await storage.read(key: 'prixdb');
    var url = '$URL/Authentification/updatebalance?idemployee=$idemployee&idcashier=$idcashier&value=$value';
    Map<String, String> headersAuth = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    String jsonBody = '{"id": "$emplyid", "value": $value1}';
    var response = await http.put(
      Uri.parse(url),
      headers: headersAuth,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else if (response.statusCode == 401) {
      Get.snackbar(
        'Something Wrong',
        'Please Reconnect ',
      );
    }
    return response;
  }


  // Future logout() async {
  //   var url = 'http://192.168.1.61:5031/Authentification/logout';
  //   Map<String, String> headersAuth = {
  //     'Content-Type': 'application/json',
  //     "Accept": "application/json",
  //     "Access-Control_Allow_Origin": "*",
  //
  //   };
  //   var response = await http.put(
  //     Uri.parse(url),
  //     headers: headersAuth,
  //   );
  //   if (response.statusCode == 200) {
  //     Get.offAllNamed(Croutes.login);
  //   }else if(response.statusCode==401){
  //     Get.snackbar(
  //       'Something Wrong',
  //       'Please Reconnect ',
  //     );
  //   }else{
  //     return null;
  //   }
  // }


  Future<Object?> AddTransaction(String? Employeeid, String? name,
      String prix) async {
    dynamic prname = await storage.read(key: 'productname');
    dynamic EmployeeId = await storage.read(key: 'idvalue');
    dynamic prprix = await storage.read(key: 'productvalue');
    var url = '$URL/ManageUsers/AddTransactions?Employeeid=$Employeeid&name=$name&prix=$prix';
    String jsonBody = '{"Employeeid":"$EmployeeId","name": "$prname", "value": $prprix}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var response = await http.post(
        Uri.parse(url), headers: headers, body: jsonBody);
    print(response.statusCode);
    final data = jsonDecode(response.body);
    print(data);
    print(data["id"]);
    await storage.write(key: 'transactionid', value: data["id"]);
    var status = data['status'];
    var errors = data['errors'];
    var message = data['message'];
    if (response.statusCode == 200) {
      print(status);
      print(message);
      print(errors);
    } else {
      print(status);
      print(message);
      print(errors);
    }
  }


  Future<Object> AcceptTransaction(String id, String employeeid) async {
    final url = '$URL/ManageUsers/AcceptTransaction?id=$id&employeeid=$employeeid';
    String jsonBody = '{"id": "$id", "employeeid": $employeeid}';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.statusCode);
        throw Exception('Failed to accept transaction');
      }
    } catch (error) {
      throw Exception('Failed to accept transaction');
    }
  }






  Future<List<Map<String, dynamic>>?> getTransactionsbyid(String? id) async {
    var url = '$URL/ManageUsers/getallEmployeetransactions?id=$id';
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

  Future<String?> addMessage(String employeeId, String message) async {
    final url = Uri.parse(
        '$URL/ManageUsers/AddMessage?employeeId=$employeeId&message=$message');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    final body = jsonEncode(
        <String, String>{'employeeId': employeeId, 'message': message});
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['message'];
    } else {
      return null;
    }
  }


  Future<List<dynamic>?> getMessages(String employeeId) async {
    try {
      Map<String, String> headersAuth = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
      };
      final response = await http.get(Uri.parse(
          '$URL/ManageUsers/GetMessages?employeeId=$employeeId'),
        headers: headersAuth,);
      if (response.statusCode == 200) {
        final jsonMessages = json.decode(response.body) as List<dynamic>;
        List<dynamic> messages = [];
        for (var message in jsonMessages) {
          if (message['message'] is String) {
            messages.add(message['message']);
          }
        }
        return messages;
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading messages: $e');
      return null;
    }
  }


  Future<List<dynamic>> getEmployees() async {
    final response = await http.get(
        Uri.parse('$URL/ManageUsers/GetEmployees'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to load employees');
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


  Future<void> deleteEmployee(String employeeId) async {
    final url = Uri.parse(
        '$URL/ManageUsers/DeleteEmployee/$employeeId');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      // Employee deleted successfully
    } else {
      throw Exception('Failed to delete employee');
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


  Future<dynamic> getEmployeeById(String id) async {
    final response = await http.get(
        Uri.parse('$URL/ManageUsers/GetEmployeeById/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load employee');
    }
  }

  Future<dynamic> getCashierById(String id) async {
    final response = await http.get(
        Uri.parse('$URL/ManageUsers/GetCashierById/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cashier');
    }
  }


  Future updateEmployeeBalance(String id, double balance, String employerId) async {
    final url = Uri.parse('$URL/ManageUsers/updateemployeeBalance?employeeid=$id&balance=$balance&employerId=$employerId');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      Get.snackbar(
        'Notification',
        'Successfuly',

        titleText: Text(
            "Money Added 👍🏼", style: TextStyle(color: Colors.green)),
      );
    } else {
      Get.snackbar(
        'Notification',
        'Eroor',

        titleText: Text(
            "Transaction Faild 😒", style: TextStyle(color: Colors.red)),
      );
    }
  }


  void changePassword(username, currentPassword, newPassword,
      confirmNewPassword) async {
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
    } else {
      print(data);
      Get.snackbar(status, message, colorText: Colors.red);
    }
  }


  void forgotPassword(email) async {
    final url = '$URL/Authentification/SendPasswordResetCode';
    var body = jsonEncode({
      'email': email,
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
    if (response.statusCode == 400) {
      Get.snackbar(
          'Opps', 'You should typing your email', colorText: Colors.red);
    }
    if (response.statusCode == 200) {
      Get.snackbar(status, message, colorText: Colors.green);
      Get.offAndToNamed(Croutes.otp);
    } else {
      print(data);
      Get.snackbar(status, message, colorText: Colors.red);
    }
  }


  void verifotp(otp, mail) async {
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
    if (response.statusCode == 400) {
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


  LocalStorage strg = LocalStorage();
  var Mail;

  void restore_password(mail, newPassword, Rpassword) async {
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
    if (response.statusCode == 500) {
      Get.snackbar('Opps',
          'You sould type your New Password',
          colorText: Colors.red);
    }
    else if (newPassword != Rpassword) {
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
      throw Exception('Failed to get cashier username');
    }
  }


  /** get Employer username **/
  Future<String> getEmployerUsername(String id) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/getEmployerusername?id=$id'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get cashier username');
    }
  }

  /** Employee Balance Added History **/

  Future<List<dynamic>> getEmployeeBalanceHistory(String employeeid) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/employeebalancehistory/$employeeid'));
    if (response.statusCode == 200) {
      final List<dynamic> balanceHistory = jsonDecode(response.body);
      return balanceHistory;
    } else {
      throw Exception('Failed to load balance history: ${response.statusCode}');
    }
  }



  /*_______________________________________---Register-New-Employee---______________________________________________________*/
  Future<Object?> AddNewuser(userName, password, Email, role, phone,balance
      ) async {
    // HttpOverrides.global = MyHttpOverrides();
    var url = '$URL/Authentification/RegisterEmployee';
    var body = jsonEncode({
      'name': userName,
      'email': Email,
      'Password': password,
      'role': role,
      'numTel': phone,
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


  Future<List<dynamic>> getEmployerBalanceAddedHistory(String employerid) async {
    final response = await http.get(Uri.parse('$URL/ManageUsers/employerbalanaddedcehistory/$employerid'));
    if (response.statusCode == 200) {
      final List<dynamic> balanceHistory = jsonDecode(response.body);
      return balanceHistory;
    } else {
      throw Exception('Failed to load balance history: ${response.statusCode}');
    }
  }

}