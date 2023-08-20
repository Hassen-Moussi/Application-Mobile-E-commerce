
import 'package:dyno_mvp/screens/register_screen/register_submit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Models/user.dart';
import '../../routes/routes.dart';
import '../../services/services.dart';
import '../../utils/c_images.dart';


class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  userformservice service = userformservice();
  bool _obscureTextpd = true ;
  bool _obscureTextcpd = true;
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cnpassword = TextEditingController();
  final _phnumber = TextEditingController();
  final _cpname = TextEditingController();
  final _rhnumber = TextEditingController();
  final _birthdate = TextEditingController();
  final _cin = TextEditingController();
  bool _validatefirstname = false;
  bool _validatelastname = false;
  bool _validateemail = false;
  bool _validatepassword = false;
  bool _validatecnpassword = false;
  bool _validatephnumber = false;
  bool _validatecpname = false;
  bool _validaterhnumber = false;
  bool _validatebirthdate = false;
  bool _validatecin = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(CImages.registerimg), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child:
              Text(
                'Welcome to Dyno Create your Account',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _firstname,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Firstname",
                                errorText: _validatefirstname?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _lastname,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Lastname",
                                errorText: _validatelastname?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                errorText: _validateemail?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _password,
                            obscureText: _obscureTextpd,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _obscureTextpd=!_obscureTextpd;
                                    });

                                  },
                                  child: Icon(_obscureTextpd ? Icons.visibility : Icons.visibility_off ),
                                ),
                                errorText: _validatepassword?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _cnpassword,
                            obscureText: _obscureTextcpd,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Confirm Password",
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _obscureTextcpd=!_obscureTextcpd;
                                    });

                                  },
                                  child: Icon(_obscureTextcpd ? Icons.visibility : Icons.visibility_off ),
                                ),
                                errorText: _validatecnpassword?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _phnumber,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Phone Number",
                                errorText: _validatephnumber?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _cpname,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Company Name",
                                errorText: _validatecpname?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _rhnumber,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "RH Number",
                                errorText: _validaterhnumber?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _birthdate,
                            keyboardType: TextInputType.datetime,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Date of Birth",
                                errorText: _validatebirthdate?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _cin,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "National Identity Card (cin)",
                                errorText: _validatecin?"Empty Field":null,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      // final createuser = User(id: 4, firstname: _firstname.text, lastname: _lastname.text, email: _email.text, password: _password.text, cnpassword: _cnpassword.text, phnumber: _phnumber.text, cpname: _cpname.text, rhnumber: _rhnumber.text, birthdate: _birthdate.text, cin: _cin.text);
                                      // final result = await service.Create(createuser);
                                      setState(() {
                                        if(_firstname.text.isEmpty || _lastname.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty || _cnpassword.text.isEmpty || _phnumber.text.isEmpty || _cpname.text.isEmpty || _rhnumber.text.isEmpty || _birthdate.text.isEmpty || _cin.text.isEmpty){
                                          _validatefirstname = true;
                                          _validatelastname = true;
                                          _validateemail = true;
                                          _validatepassword = true;
                                          _validatecnpassword = true;
                                          _validatephnumber = true;
                                          _validatecpname = true ;
                                          _validaterhnumber = true ;
                                          _validatebirthdate = true ;
                                          _validatecin = true ;
                                        }
                                        else {
                                          Get.offAllNamed(Croutes.submit);
                                          _validatefirstname = false;
                                          _validatelastname = false;
                                          _validateemail = false;
                                          _validatepassword = false;
                                          _validatecnpassword = false;
                                          _validatephnumber = false;
                                          _validatecpname = false ;
                                          _validaterhnumber = false ;
                                          _validatebirthdate = false ;
                                          _validatecin = false ;
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () => Get.offAllNamed(Croutes.welcome),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 32,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
