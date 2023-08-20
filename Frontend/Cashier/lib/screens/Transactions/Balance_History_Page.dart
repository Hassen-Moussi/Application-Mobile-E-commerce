import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../Services/service.dart';
import '../../routes/routes.dart';
import 'package:intl/intl.dart';

class CashierBalanceHistoryPage extends StatefulWidget {
  @override
  _CashierBalanceHistoryPageState createState() =>
      _CashierBalanceHistoryPageState();
}

class _CashierBalanceHistoryPageState extends State<CashierBalanceHistoryPage> {
  userformservice service = userformservice();
  String cashierid = '';
  String _balance = "";
  String balanceHistory = "";

  int _itemCount = 3;

  Future<void> getemployeeid() async {
    dynamic id = await storage.read(key: 'idvalue');
    setState(() {
      cashierid = id;
    });
  }

  Future<void> _getData() async {
    dynamic value = await storage.read(key: 'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _balance = dataresponse['balance'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getemployeeid();
    _getData();
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.all(20),
            width: 500,
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Total Amount ",
                  style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(
                  "${_balance} DT ",
                  style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.black26),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount Taken History",
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              if (_itemCount < balanceHistory.length) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _itemCount += 3;
                      if (_itemCount > balanceHistory.length) {
                        _itemCount = balanceHistory.length;
                      }
                    });
                  },
                  child: Text(
                    "Show More",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.indigoAccent),
                  ),
                ),
              ],
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: service.getCashierBalanceHistory(cashierid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> balanceHistory = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _itemCount,
                          itemBuilder: (context, index) {
                            if (index < balanceHistory.length) {
                              var historyItem =
                                  balanceHistory.reversed.toList()[index];
                              DateTime createdTime =
                                  DateTime.parse(historyItem['date'])
                                      .add(Duration(hours: 1));
                              String formattedDate =
                                  DateFormat.yMd().add_jm().format(createdTime);
                              return Card(
                                shadowColor: Colors.blue,
                                color: Colors.white,
                                elevation: 15,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<String>(
                                          future: service.getShopownerUsername(
                                              historyItem['shopownerid']),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.hasData) {
                                              String employeeName =
                                                  snapshot.data!;
                                              return Text(
                                                  'Shopowner Name : $employeeName');
                                            } else {
                                              return Text(
                                                  'Shopowner Name : N/A');
                                            }
                                          },
                                        ),
                                        Text(
                                            'Balance Added: ${historyItem['balancetaken']}'),
                                        Text('Date: $formattedDate'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                      if (_itemCount < balanceHistory.length)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _itemCount += 3;
                              if (_itemCount > balanceHistory.length) {
                                _itemCount = balanceHistory.length;
                              }
                            });
                          },
                          child: Text('See More'),
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Failed to load balance history: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
