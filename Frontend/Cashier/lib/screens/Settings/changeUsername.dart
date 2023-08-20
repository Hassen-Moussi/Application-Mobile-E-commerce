import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Services/service.dart';
import '../../routes/routes.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<UpdateProfile> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  userformservice service = userformservice();
  final _username = TextEditingController();
  final _adresse = TextEditingController();
  bool isFocused = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getData();
    _focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });

    print('focus changed.');
  }

  String _Adresse = '';
  String _Username = "";
  Future<void> _getData()async {
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _Adresse = dataresponse["adresse"].toString();
      final dynamic employer3 = dataresponse["cassier"];
      _Username = employer3["userName"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _getData();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offAllNamed(Croutes.home);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                Text(
                  "Profile Updating ",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 120),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    child: const Text(
                      "You Can Change your Username and Address from here: ",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                // note textfield
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInUp(
                        from: 60,
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 1000),
                        child: AnimatedContainer(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isFocused
                                    ? Colors.indigo.shade400
                                    : Colors.grey.shade200,
                                width: 2),
                            // // boxShadow:
                          ),
                          child: TextFormField(
                          controller: _username,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              labelText: "Username: ${_Username}",
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username field is Empty';
                            }
                            return null;
                          },
                        ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                        from: 60,
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 1000),
                        child: AnimatedContainer(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isFocused
                                    ? Colors.indigo.shade400
                                    : Colors.grey.shade200,
                                width: 2),
                            // // boxShadow:
                          ),
                          child: TextFormField(
                            controller: _adresse,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                labelText: "Address: ${_Adresse}",
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Address field is Empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      child: MaterialButton(
                        onPressed: () async {
                          dynamic emplyid =
                              await storage.read(key: 'cashierid');
                          dynamic employid = await storage.read(key: 'idvalue');
                          final result1 = await service.updateCashierAdresse(
                              employid, _adresse.text);
                          final result2 = await service.UpdateProfileusername(
                              emplyid, _username.text);
                          setState(() {
                            if (_formKey.currentState != null &&
                                !_formKey.currentState!.validate()) {
                              Text(
                                '',
                                style: TextStyle(color: Colors.red),
                              );
                            }else {
                              result2;
                              result1;
                            }
                          });
                        },
                        minWidth: double.infinity,
                        height: 50,
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
