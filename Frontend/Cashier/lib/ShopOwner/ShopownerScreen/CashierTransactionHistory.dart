import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/service.dart';
import '../../routes/routes.dart';

class CashierTransactionHistory extends StatefulWidget {
  final String id;
  final String username;

  const CashierTransactionHistory({Key? key, required this.id, required this.username})
      : super(key: key);

  @override
  _CashierTransactionHistory createState() => _CashierTransactionHistory();
}

class _CashierTransactionHistory extends State<CashierTransactionHistory> {
  final userformservice service = userformservice();
  List<String>  _name =[];
  List<double>  _prix= [];
  List<DateTime> _dates= [];
  List<DateTime> sortedDates = [];
  List<Map<String, dynamic>> transactions = [];
  int balanceHistoryCount = 0;
  int displayedItems = 3;

  Future<void> _loadtransactions() async {
    final List<Map<String, dynamic>>? gettransactions = await service.getAllTransactions(widget.id);
    List<String> names = [];
    List<double> prices = [];
    List<DateTime> dates = [];

    for (var transaction in gettransactions!) {
      names.add(transaction['name']);
      double? price = double.tryParse('${transaction['prix']}' ?? '');
      if (price != null) {
        prices.add(price);
      }
      DateTime date = DateTime.parse(transaction['datecreation']);
      dates.add(date.toUtc()); // Convert to UTC time to ensure consistency
    }

    setState(() {
      transactions = gettransactions;
      balanceHistoryCount=gettransactions.length;
      _name = names; // if you want to concatenate all the names into one string
      _prix = prices;
      _dates = dates;
      sortedDates = List.from(dates)..sort((a, b) => b.compareTo(a));
    });
  }

  String _getElapsedTimeString(DateTime transactionDate) {
    final now = DateTime.now();
    final difference = now.difference(transactionDate);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else {
      return '${difference.inDays} d';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadtransactions();
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
                        "Transactions",
                        style: GoogleFonts.poppins(
                            fontSize: 35, fontWeight: FontWeight.w500, color:Colors.black26),
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Successful transactions history", style: GoogleFonts.poppins(
                        fontSize: 15,  fontWeight: FontWeight.w400, color:Colors.black), ),
                    if (displayedItems < transactions.length) ...[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            displayedItems += 3;
                            if (displayedItems > transactions.length) {
                              displayedItems = transactions.length;
                            }
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
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: displayedItems <= sortedDates.length ? displayedItems : sortedDates.length,
                    itemBuilder: (BuildContext context, int index) {
                      int sortedIndex = _dates.indexOf(sortedDates[index]);
                      return Card(
                        shadowColor: Colors.blue,
                        color: Colors.white,
                        elevation: 15,
                        child: Container(
                          child: ListTile(
                            leading: Icon(Iconsax.money_recive,size: 35,color: Colors.black,),
                            trailing: Icon(Iconsax.arrow_down,size: 35,color: Colors.green,),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _name[sortedIndex],
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "${_prix[sortedIndex]} DT",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${_getElapsedTimeString(_dates[sortedIndex])} ago',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                ),
              ],
            )
        )

    );
  }
}
