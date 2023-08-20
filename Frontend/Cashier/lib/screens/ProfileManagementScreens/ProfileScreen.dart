import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Services/service.dart';
import '../../routes/routes.dart';

class Profile extends StatefulWidget {

  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  userformservice service = userformservice();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _adresse = TextEditingController();
  bool isFocused = false;



  @override

  void initState() {
    super.initState();

    _focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });

    print('focus changed.');
  }
  Future<void> _getData()async {
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _adresse.text = dataresponse["adresse"].toString();
      final dynamic employer3 = dataresponse["cassier"];
      _username.text = employer3["userName"].toString();
      _email.text = employer3["email"].toString();
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
          title: Text('Profile', style: TextStyle(color: Colors.black),),
          leading:IconButton(
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
                SizedBox(height: 50,),
                FadeInDown(
                  from: 100,
                  duration: Duration(milliseconds: 1000),
                  child: Container(
                    width: 130,
                    height: 130,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: ClipRRect(

                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset('assets/avatar-1.png'),),
                    ),
                  ),
                ),
                SizedBox(height: 50,),



                SizedBox(height: 10,),
                // note textfield
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
                      border: Border.all(color: isFocused ? Colors.indigo.shade400 : Colors.grey.shade200, width: 2),
                      // // boxShadow:
                    ),
                    child: TextField(


                      controller: _username,
                      readOnly: true,
                      keyboardType: TextInputType.text,

                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          border: InputBorder.none
                      ),
                    ),


                  ),
                ),
                SizedBox(height: 20,),
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
                      border: Border.all(color: isFocused ? Colors.indigo.shade400 : Colors.grey.shade200, width: 2),
                      // // boxShadow:
                    ),
                    child: TextField(


                      controller: _email,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          border: InputBorder.none
                      ),
                    ),


                  ),
                ),
                SizedBox(height: 20,),
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
                      border: Border.all(color: isFocused ? Colors.indigo.shade400 : Colors.grey.shade200, width: 2),
                      // // boxShadow:
                    ),
                    child: TextField(


                      controller: _adresse,
                      readOnly: true,
                      keyboardType: TextInputType.text,

                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          labelText: "Adresse",
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          border: InputBorder.none
                      ),
                    ),


                  ),
                ),
                SizedBox(height: 50,),


              ],
            ),
          ),
        )
    );
  }
}