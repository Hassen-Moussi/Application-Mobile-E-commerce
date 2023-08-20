import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../Services/service.dart';
import 'QR-generator.dart';



class Producte extends StatefulWidget {

  const Producte({ Key? key }) : super(key: key);

  @override
  _ProducteState createState() => _ProducteState();
}

class _ProducteState extends State<Producte> {


  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  userformservice service = userformservice();

  final _ProductName = TextEditingController();
  final _ProductValue = TextEditingController();
  final _adresse = TextEditingController();
  bool isFocused = false;
  final _formKey = GlobalKey<FormState>();



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
          title: Text('Producte Process', style: TextStyle(color: Colors.black),),
          leading: BackButton(color: Colors.black,),
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
                    width: 400,
                    height: 300,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: ClipRRect(

                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/cashier.jpg'),),
                    ),
                  ),
                ),
                SizedBox(height: 50,),


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
                            color: _ProductName.text.isEmpty || _formKey.currentState!.validate() ? Colors.white : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isFocused ? Colors.indigo.shade400 : Colors.grey.shade200, width: 2),
                            // // boxShadow:
                          ),
                          child: TextFormField(
                            controller: _ProductName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              hintText: "Producte Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter product name';
                              }
                              final nameRegex = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s!@#\$%^&*()_\-\+=0-9]+$');
                              if (!nameRegex.hasMatch(value)) {
                                return 'Please enter a valid product name';
                              }
                              return null;
                            },
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
                            color: _ProductValue.text.isEmpty || _formKey.currentState!.validate() ? Colors.white : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isFocused ? Colors.indigo.shade400 : Colors.grey.shade200, width: 2),
                            // // boxShadow:
                          ),
                          child: TextFormField(
                            controller: _ProductValue,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              hintText: "Product Price",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter product price';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // note textfield


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
                          if (_formKey.currentState!.validate()) { // check if the form is valid
                            await storage.write(key: 'productname', value: _ProductName.text);
                            await storage.write(key: 'productvalue', value: _ProductValue.text);
                            dynamic CashierId = await storage.read(key: 'idvalue');
                            double prixpr = double.parse(_ProductValue.text);
                            final savetransaction = await service.addTransaction(CashierId,_ProductName.text, prixpr);
                            setState(() {
                              savetransaction;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyQrGenPage()));
                            });
                          }
                        },
                        minWidth: double.infinity,
                        height: 50,
                        child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 16),),
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