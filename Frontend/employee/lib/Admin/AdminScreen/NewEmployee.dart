import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/services.dart';






class NewEmployee extends StatefulWidget {
  const NewEmployee({Key? key}) : super(key: key);

  @override
  _NewEmployeeState createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
String role="employee";
double balance=0;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
bool _obscureText = true;
  userformservice service = userformservice();
final _formKey = GlobalKey<FormState>();


  @override







  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Back', style: TextStyle(color: Colors.black),),
    leading: BackButton(color: Colors.black,),),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(
      //     color: Colors.black,
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: SizedBox(

                    child: const Text(
                      "New Employee",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/new.png",
                  width:500,
                  height: 300,
                ),
                const SizedBox(height: 15),
                //email
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
                        controller: _username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an UserName';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Entre the Username',
                          hintStyle: TextStyle(
                            color: Color(0xFF8391A1),
                          ),
                          suffixIcon: Icon(
                            Icons.supervised_user_circle_outlined,
                            color: Color(0xFF8391A1),
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //email
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
                        controller: _email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Entre the Email',
                          hintStyle: TextStyle(
                            color: Color(0xFF8391A1),
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF8391A1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                        controller: _password,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Entre the Password',
                          hintStyle: TextStyle(
                            color: Color(0xFF8391A1),

                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF8391A1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //email
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
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: _phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          } else if (value.length != 8) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Entre Phone Number',
                          hintStyle: TextStyle(
                            color: Color(0xFF8391A1),
                          ),
                          suffixIcon: Icon(
                            Icons.phone_android,
                            color: Color(0xFF8391A1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),







                //forgot password

                const SizedBox(height: 25),
                //login button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              service.AddNewuser(
                                _username.text,
                                _password.text,
                                _email.text,
                                role,
                                _phone.text,
                                balance,
                              );
                            }

                          },
                          child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                //  Padding(
                //    padding: const EdgeInsets.symmetric(
                //      horizontal: 20,
                //      vertical: 10,
                //    ),
                //    child: Row(
                //      children: const [
                //        Expanded(
                //          child: Divider(
                //            color: Color(0xFFE8ECF4),
                //            thickness: 1,
                //          ),
                //        ),
                //
                //
                //      ],
                //    ),
                //  ),


                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Don’t have an account? ",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const RegisterScreen()));
                //       },
                //       child: const Text(
                //         "Register",
                //         style: TextStyle(
                //           color: Color(0xFF35C2C1),
                //           fontSize: 16,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}