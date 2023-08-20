import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../routes/routes.dart';
import '../../services/services.dart';
import 'ListUser.dart';

String URL='http://192.168.1.12:5031';

class SendMoney extends StatefulWidget {
  final String name;
  final String avatar;
  final String id;

  const SendMoney({ Key? key, required this.name, required this.avatar, required this.id }) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final userformservice service = userformservice();

  TextEditingController _amount = TextEditingController(text: "0.00");



  FocusNode _focusNode = new FocusNode();
  TextEditingController _editingController = new TextEditingController();
  bool isFocused = false;
 String EmployerId="";

void getdata() async{
 dynamic id = await storage.read(key: 'idemployer');
 setState(() {
   EmployerId=id;
 });
}

  @override
  void initState() {
    super.initState();
    getdata();
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
          title: Text('Send Money', style: TextStyle(color: Colors.black),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offAllNamed(Croutes.list);
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
                    child: Text("Send Money To", style: TextStyle(color: Colors.grey),)),
                SizedBox(height: 10,),
                FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(widget.name, style: TextStyle(fontSize:
                    24, fontWeight: FontWeight.bold),)),
                SizedBox(height: 20,),
                FadeInUp(
                  from: 40,
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TextField(
                      controller: _amount,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                      onSubmitted: (value) {
                        setState(() {
                          _amount.text =   value ;
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (_amount.text == "0.00") {
                            _amount.text = "";
                          }
                        });
                      },
                      inputFormatters: [
                        //ThousandsFormatter()
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
                        onPressed: () async{
    String? value = _amount.text.trim();
    if (value.isNotEmpty) {
      double newBalanceValue = double.parse(value);

      await service.updateEmployeeBalance(widget.id, newBalanceValue,EmployerId);

      // Navigator.of(context).pop(newBalanceValue);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListUser()));


      //Navigator.of(context).pushReplacementNamed('/');
    }},
                        minWidth: double.infinity,
                        height: 50,
                        child: Text("Send", style: TextStyle(color: Colors.white, fontSize: 16),),
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