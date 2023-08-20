import 'package:align_positioned/align_positioned.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Services/service.dart';
import '../../routes/routes.dart';
import 'CashierTransactionHistory.dart';




class UserManager extends StatefulWidget {
  const UserManager({ Key? key }) : super(key: key);

  @override
  _UserManagerState createState() => _UserManagerState();

}

class _UserManagerState extends State<UserManager> {
  final userformservice service = userformservice();
  late List<dynamic> _cashiers;
  late List<dynamic> _filteredcashiers = [];

  @override
  void initState() {
    super.initState();
    _fetchCashiers();
  }

  Future<void> _fetchCashiers() async {
    try {
      _cashiers = await service.getCashiers();
      setState(() {
        _filteredcashiers = _cashiers;
      });
    } catch (e) {
      print('Failed to fetch cashiers: ${e.toString()}');
    }
  }

  void _searchCashiers(String query) {
    List<dynamic> results = [];
    if (query.isNotEmpty) {
      results = _cashiers.where((employee) => employee["employer"]!["userName"].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      results = List.from(_cashiers);
    }
    setState(() {
      _filteredcashiers = results;
    });
  }

  Future<void> _deleteCashier(dynamic cashier) async {
    if (cashier['casierId'] != null && cashier['casierId'] is String) {
      try {
        await service.deleteCashier(cashier['casierId']);
        Get.snackbar('Success', 'Cashier deleted successfully');
        _fetchCashiers();
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete cashier: ${e.toString()}');
      }
    } else {
      Get.snackbar('Error', 'Invalid cashier ID');
    }
  }

  List<dynamic> _contacts = [
    {

      'avatar': 'assets/avatar-1.png',
    },
    {

      'avatar': 'assets/avatar-2.png',
    },
    {

      'avatar': 'assets/avatar-3.png',
    },
    {

      'avatar': 'assets/avatar-4.png',
    },
    {

      'avatar': 'assets/avatar-5.png',
    },
    {

      'avatar': 'assets/avatar-6.png',
    },
    {

      'avatar': 'assets/avatar-1.png',
    },
    {

      'avatar': 'assets/avatar-2.png',
    },
    {

      'avatar': 'assets/avatar-3.png',
    },
    {

      'avatar': 'assets/avatar-4.png',
    },
    {

      'avatar': 'assets/avatar-5.png',
    },
    {

      'avatar': 'assets/avatar-6.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Back', style: TextStyle(color: Colors.black),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.offAllNamed(Croutes.shopowner);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: FadeInDown(
              duration: Duration(milliseconds: 500),
              child: Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (query) => _searchCashiers(query),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey,),
                    hintText: 'Search Cashier',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: 30,),
                  FadeInRight(
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 15.0, top: 10.0),
                      child: Text('Cashier List Manager', style: TextStyle(fontSize: 16,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w500),),
                    ),
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 200,
                    padding: EdgeInsets.only(left: 20),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _filteredcashiers.length,
                      itemBuilder: (context, index) {
                        var employee = _filteredcashiers[index];
                        var employer = employee['employer'];
                        return FadeInRight(
                          duration: Duration(milliseconds: (index * 100) + 500),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => CashierTransactionHistory(
                                        id:'${employee['casierId']}', username: '${employer['userName']}',
                                      )
                                  )
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.red[100],
                                      backgroundImage: AssetImage(
                                          _contacts[index]['avatar']),
                                    ),
                                    SizedBox(width: 10,),
                                    Text(employer['userName'], style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.delete_forever,
                                    color: Colors.black, size: 30,),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text('Delete Cashier'),
                                          content: Text('Are you sure you want to delete this Cashier?'),
                                          actions: [
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                await _deleteCashier(employee);
                                                Navigator.pop(context);
                                                Get.snackbar('Cashier Was Deleted', '',
                                                    snackPosition: SnackPosition.BOTTOM);
                                                setState(() {}); // Refresh the page after deleting.
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
            )
        )
    );
  }


}