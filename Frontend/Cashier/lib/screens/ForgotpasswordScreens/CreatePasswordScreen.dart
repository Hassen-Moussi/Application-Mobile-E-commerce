import 'package:banking_app/screens/ForgotpasswordScreens/PasswordCreatedScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Data/LocalStorage.dart';
import '../../Services/service.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  LocalStorage storage = LocalStorage();
  final _newPassword = TextEditingController();
  final _Rpassword = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();

  userformservice service = userformservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
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
                          controller: _newPassword,
                          obscureText: _obscureText2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'New Password',
                            hintStyle: TextStyle(
                              color: Color(0xFF8391A1),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                              child: Icon(
                                _obscureText2
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
                          controller: _Rpassword,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confirm password',
                            hintStyle: TextStyle(
                              color: Color(0xFF8391A1),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                              child: Icon(
                                _obscureText1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFF8391A1),
                              ),
                            ), //
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
                        var mail = await storage.readEmail();
                        // _changePassword(_username.text,_currentpassword.text,_newpassword.text,_confirmpassword.text);
                        setState(() {
                          if (_formKey.currentState != null &&
                              !_formKey.currentState!.validate()) {
                            Text(
                              '',
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            service.restore_password(
                                mail, _newPassword.text, _Rpassword.text);
                          }
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Reset Password",
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
    );
  }
}
