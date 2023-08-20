import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../routes/routes.dart';
import '../../services/services.dart';

class EmployeeBalanceHistoryPage extends StatefulWidget {
  @override
  _EmployeeBalanceHistoryPageState createState() => _EmployeeBalanceHistoryPageState();
}

class _EmployeeBalanceHistoryPageState extends State<EmployeeBalanceHistoryPage> {
  userformservice service = userformservice();
  String employeeid='';
  List<dynamic> balanceHistory = [];
  int balanceHistoryCount = 0;
  int displayedItems = 3;
  String _balance="";

  Future<void> getemployeeid() async {
    dynamic id = await storage.read(key:'idvalue');
    setState(() {
      employeeid=id;
    });
  }
  Future<void> _getData()async{
    dynamic value = await storage.read(key:'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _balance=dataresponse['balance'].toString();

    });
  }

  Future<void> getEmployeeBalanceHistory() async {
    List<dynamic> history = await service.getEmployeeBalanceHistory(employeeid);
    setState(() {
      balanceHistory = history;
      balanceHistoryCount = history.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
    getemployeeid().then((_) => getEmployeeBalanceHistory());
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text('Back', style: TextStyle(color: Colors.black),),
        leading: IconButton(color: Colors.black, onPressed: () {
          Get.offAllNamed(Croutes.home);
        }
          , icon: Icon(Icons.arrow_back),),

      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
                width: 500,
                height: 200,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),



           child:   Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    "Total Amount ",
                    style: GoogleFonts.poppins(
                        fontSize: 25, fontWeight: FontWeight.w400,color: Colors.white),

                  ),

                  Text(
                    "${_balance} DT ",
                    style: GoogleFonts.poppins(
                        fontSize: 35, fontWeight: FontWeight.w500, color:Colors.black26),
                  ),

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("  Last Amount Recive History", style: GoogleFonts.poppins(
          fontSize: 15,  fontWeight: FontWeight.w400, color:Colors.black), ),
              ],
            ),
            SizedBox(width: 50,),




            Expanded(

              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: displayedItems,
                itemBuilder: (context, index) {
                  if (index < balanceHistoryCount) {
                    var historyItem = balanceHistory.reversed.toList()[index];
                    DateTime createdTime = DateTime.parse(historyItem['datecreation']).add(Duration(hours: 1));
                    String timeAgo = DateFormat.yMMMd().add_jm().format(createdTime);
                    return Card(
                      shadowColor: Colors.blue,
                      color: Colors.white,
                      elevation: 15,
                      shape: Border(),

                      child: SingleChildScrollView(
                        child: ListTile(

                          leading: Icon(Iconsax.money_recive,size: 35,color: Colors.black,),


                          trailing: Icon(Iconsax.arrow_down,size: 35,color: Colors.green,),

                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder<String>(
                                future: service.getEmployerUsername(historyItem['employerid']),
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    String employerName = snapshot.data!;
                                    return

                                      Text('Employer Name : $employerName', style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),);
                                  } else {
                                    return Text('Employer Name : N/A');
                                  }
                                },
                              ),
                              Text('Amount Added: ${historyItem['balancegiven']} DT',style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),),
                              Text('$timeAgo'),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            if (displayedItems < balanceHistory.length)
              TextButton(
                onPressed: () {
                  setState(() {
                    displayedItems += 3;
                    if (displayedItems > balanceHistory.length) {
                      displayedItems = balanceHistory.length;
                    }
                  });
                },
                child: Text('See More'),
              ),
          ],
        ),
      ),
    );
  }
}
