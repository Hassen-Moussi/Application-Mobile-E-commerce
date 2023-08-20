import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:pinput/pinput.dart';

import '../../Services/service.dart';

class CashierBalancePage extends StatefulWidget {
  final String name;
  final String avatar;
  final String cashierid;
  const CashierBalancePage({ Key? key, required this.name, required this.cashierid, required this.avatar}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<CashierBalancePage> {
  double? _balance;
  var amount = TextEditingController(text: "0.00");
  final userformservice service = userformservice();
  bool _isLoading = false;

  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  bool isFocused = false;

  Future<void> getcashierbalance() async {
    final result = await service.getCashierById(widget.cashierid);

    setState(() {
      _balance = result['balance'].toDouble(); // cast the int value to a double
    });
  }
  @override
  void initState() {
    super.initState();
    getcashierbalance();
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
    setState(() {
      getcashierbalance();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Receive Money', style: TextStyle(color: Colors.black),),
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
                    width: 130,
                    height: 130,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(widget.avatar)),
                  ),
                ),


                SizedBox(height: 50,),
                FadeInUp(
                    from: 60,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text("${widget.name} has ", style: TextStyle(color: Colors.grey),)),
                SizedBox(height: 10,),
                FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text('$_balance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                SizedBox(height: 20,),
                FadeInUp(
                  from: 40,
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      controller: amount,
                      maxLength:6,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                      onSubmitted: (value) {
                        setState(() {
                          amount.text = value ;
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (amount.text == "0.00") {
                            amount.text = "";
                          }
                        });
                      },
                      inputFormatters: [
                        // ThousandsFormatter()
                      ],
                      decoration: InputDecoration(
                          hintText: "Enter Amount",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      child: MaterialButton(
                        onPressed: () async{
                          setState(() {
                            _isLoading = true;
                          });

                          // Perform asynchronous operation here
                          Future.delayed(Duration(seconds: 5)).then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                          final shopid = await storage.read(key: 'shopownerid');
                          double balance = double.parse(amount.text);
                          String  result = await Future.delayed(Duration(seconds: 5), () => service.updateCashierBalancebyamount(widget.cashierid,balance,shopid!));
                          setState(() {
                            result;

                          });
                        },
                        minWidth: double.infinity,
                        height: 50,
                        child:_isLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Processing ..",
                            style: TextStyle(fontSize: 15,color: Colors.white),
                            ),
                            CircularProgressIndicator(

                              color: Colors.blue,


                            ),
                          ],
                        ): Text("Send", style: TextStyle(color: Colors.white, fontSize: 16),),
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