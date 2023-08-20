import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/routes.dart';
import '../../services/services.dart';

class EmployeeTransactionHistory extends StatefulWidget {
  final String id;
  final String username;

  const EmployeeTransactionHistory({Key? key, required this.id, required this.username})
      : super(key: key);

  @override
  _EmployeeTransactionHistory createState() => _EmployeeTransactionHistory();
}

class _EmployeeTransactionHistory extends State<EmployeeTransactionHistory> {
  final userformservice service = userformservice();
  List<dynamic> balanceHistory = [];
  int balanceHistoryCount = 0;
  int displayedItems = 3;
  String employerid = '';

  Future<void> getEmployeeBalanceHistory() async {
    List<dynamic> history = await service.getEmployeeBalanceHistory(widget.id);
    setState(() {
      balanceHistory = history;
      balanceHistoryCount = history.length;
    });
  }

  Future<void> getemployerid() async {
    dynamic id = await storage.read(key: 'idemployer');
    setState(() {
      employerid = id;
    });
  }

  @override
  void initState() {
    super.initState();
    getEmployeeBalanceHistory();
    getemployerid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'User Manager',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offAllNamed(Croutes.usermanager);
            },
          ),
        ),
        body:  Center(
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
                      "${widget.username} ",
                      style: GoogleFonts.poppins(
                          fontSize: 25, fontWeight: FontWeight.w400,color: Colors.white),

                    ),

                    Text(
                      "Balance Recieved",
                      style: GoogleFonts.poppins(
                          fontSize: 35, fontWeight: FontWeight.w500, color:Colors.black26),
                    ),

                  ],
                ),
              ),



              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  Last Amount Recive History", style: GoogleFonts.poppins(
                      fontSize: 15,  fontWeight: FontWeight.w400, color:Colors.black), ),
                  if (displayedItems < balanceHistoryCount) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          displayedItems += 3;
                        });
                      }, child: Text("Show More",style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.indigoAccent
                    ),),

                    ),
                  ],
                ],
              ),
              SizedBox(width: 50,),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: displayedItems,
                        itemBuilder: (context, index) {
                          if (index < balanceHistoryCount) {
                            var historyItem =
                                balanceHistory.reversed.toList()[index];
                            DateTime createdTime =
                                DateTime.parse(historyItem['datecreation'])
                                    .add(Duration(hours: 1));
                            String timeAgo =
                                DateFormat.yMMMd().add_jm().format(createdTime);
                            if (historyItem['employerid'] == employerid) {
                              return Card(
                                shadowColor: Colors.blue,
                                color: Colors.white,
                                elevation: 15,
                                shape: Border(),
                                child: SingleChildScrollView(
                                  child: ListTile(
                                    leading: Icon(
                                      Iconsax.money_recive,
                                      size: 35,
                                      color: Colors.black,
                                    ),
                                    trailing: Icon(
                                      Iconsax.arrow_down,
                                      size: 35,
                                      color: Colors.green,
                                    ),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Amount Added: ${historyItem['balancegiven']} DT',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text('$timeAgo'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
                  ],
                )
        )

        );
  }
}
