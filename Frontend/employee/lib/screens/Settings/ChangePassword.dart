import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../routes/routes.dart';
import '../../services/services.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  String _name = "";

  final _currentpassword = TextEditingController();
  final _newpassword = TextEditingController();
  final _confirmpassword = TextEditingController();
  bool _obscureTextCurrent = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirme = true;
  final _formKey = GlobalKey<FormState>();

  userformservice service = userformservice();
  Future<void> _getData() async {
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      final dynamic employer3 = dataresponse["employer"];
      _name = employer3["userName"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _getData();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: 450,
                  child: const Text(
                    "Create new password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "Your new password must be unique from those previously used.",
                  style: TextStyle(
                    color: Color(0xFF8391A1),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //password
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F9),
                          border: Border.all(
                            color: const Color(0xFFE8ECF4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: _currentpassword,
                            obscureText: _obscureTextCurrent,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Current Password',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureTextCurrent = !_obscureTextCurrent;
                                  });
                                },
                                child: Icon(
                                  _obscureTextCurrent
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xFF8391A1),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Current Password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    //confirm password
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F9),
                          border: Border.all(
                            color: const Color(0xFFE8ECF4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: _newpassword,
                            obscureText: _obscureTextNew,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'New password',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureTextNew = !_obscureTextNew;
                                  });
                                },
                                child: Icon(
                                  _obscureTextNew
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xFF8391A1),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your New Password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F9),
                          border: Border.all(
                            color: const Color(0xFFE8ECF4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: _confirmpassword,
                            obscureText: _obscureTextConfirme,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm your password',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureTextConfirme =
                                    !_obscureTextConfirme;
                                  });
                                },
                                child: Icon(
                                  _obscureTextConfirme
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color(0xFF8391A1),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Confirmed Password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              //register button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: const Color(0xFF1E232C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          setState(() {
                            if (_formKey.currentState != null &&
                                !_formKey.currentState!.validate()) {
                              Text(
                                '',
                                style: TextStyle(color: Colors.red),
                              );
                            } else {
                              service.changePassword(
                                  _name,
                                  _currentpassword.text,
                                  _newpassword.text,
                                  _confirmpassword.text);
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
