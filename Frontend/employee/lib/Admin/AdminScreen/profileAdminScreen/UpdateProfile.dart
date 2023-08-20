import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../routes/routes.dart';
import '../../../services/services.dart';


class AdminUpdateProfile extends StatefulWidget {

  const AdminUpdateProfile({ Key? key }) : super(key: key);

  @override
  _AdminUpdateProfile createState() => _AdminUpdateProfile();
}

class _AdminUpdateProfile extends State<AdminUpdateProfile> {


  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  userformservice service = userformservice();
  final _username = TextEditingController();
  final _numtel = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Profile', style: TextStyle(color: Colors.black),),
          leading: IconButton(
          icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      onPressed: () {
        Get.offAllNamed(Croutes.AdminSettings);
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
                        child: Image.asset('assets/Profile_images/profile1.jpg'),),
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


                      controller: _numtel,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                          border: InputBorder.none
                      ),
                    ),


                  ),
                ),
                SizedBox(height: 50,),
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
                          dynamic emplyid = await storage.read(key: 'idvalue');
                          dynamic employid = await storage.read(key: 'employeeid');
                          final result1 = await  service.UpdateProfilenumtel(emplyid,_numtel.text);
                          final result2 = await service.UpdateProfileusername(employid, _username.text);
                          setState(() {
                            result1;
                            result2;
                          });
                        },
                        minWidth: double.infinity,
                        height: 50,
                        child: Text("Update", style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}