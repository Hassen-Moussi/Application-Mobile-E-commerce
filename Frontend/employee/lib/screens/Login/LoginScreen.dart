import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/services.dart';
import '../Settings/forgotpassword.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _email = TextEditingController();
  final _password = TextEditingController();
  userformservice service = userformservice();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override

  void initState() {
    super.initState();
    _loadSavedCredentials();
  }


  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _email.text = prefs.getString('email') ?? '';
        _password.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      prefs.setString('email', _email.text);
      prefs.setString('password', _password.text);
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 40,),


              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SizedBox(

                      child: const Text(
                        "Welcome back !",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Center(

                      child: Image.asset('assets/login/loginicon.png', width: 250,height: 250,
                      alignment: Alignment.center,

                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              //email
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
                            controller: _email,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(
                                color: Color(0xFF8391A1),
                              ),
                              suffixIcon: Icon(
                                Icons.email,
                                color: Color(0xFF8391A1),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    //password
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your Password',
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
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Color(0xFF8391A1),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Password';
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
              const SizedBox(height: 8),
              CheckboxListTile(
                title: Text("Remember Me"),
                value: _rememberMe,
                onChanged: (value) {  setState(() {
                  _rememberMe = value ?? false;
                });  },
                controlAffinity: ListTileControlAffinity.leading, // <-- leading Checkbox
              ),




              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForgotPasswordScreen()));
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF6A707C),
                      ),
                    ),
                  ),
                ),
              ),
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
                        color: const Color(0xFF1E232C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          // Perform asynchronous operation here
                          Future.delayed(Duration(seconds: 10)).then((_) {
                            if(mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });

                          await  _saveCredentials();
                          final result =  Future.delayed(Duration(seconds: 2), () => service.login(_email.text, _password.text));
                          dynamic employeedata = await storage.read(key:'employeeid');
                          dynamic employerdata = await storage.read(key:'employerid');
                          final dynamic getemployees =  service.getbyid(employeedata);
                          final dynamic getemployers =  service.getbyid(employerdata);
                          setState(() {
                            if (_formKey.currentState != null &&
                                !_formKey.currentState!.validate()) {
                              Text(
                                '',
                                style: TextStyle(color: Colors.red),
                              );
                            }else {
                              result;
                              getemployees;
                              getemployers;
                            }
                          });

                        },
                        child:  Padding(
                          padding: EdgeInsets.all(15.0),

                          child:_isLoading ? CircularProgressIndicator(
                            color: Colors.blue,

                          ) : Text(
                            "Login",
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
    );
  }
}