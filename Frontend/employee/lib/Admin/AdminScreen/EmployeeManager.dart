import 'package:align_positioned/align_positioned.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/routes.dart';
import '../../services/services.dart';
import 'EmployeeTransactionHistory.dart';


class UserManager extends StatefulWidget {
  const UserManager({ Key? key }) : super(key: key);

  @override
  _UserManagerState createState() => _UserManagerState();

}

class _UserManagerState extends State<UserManager> {
  final userformservice service = userformservice();
  late List<dynamic> _employees;
  late List<dynamic> _filteredEmployees = [];


  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  void _searchEmployees(String query) {
    List<dynamic> results = [];
    if (query.isNotEmpty) {
      results = _employees.where((employee) =>
          employee["employer"]!["userName"].toLowerCase().contains(
              query.toLowerCase())).toList();
    } else {
      results = List.from(_employees);
    }
    setState(() {
      _filteredEmployees = results;
    });
  }
  Future<void> _deleteEmployee(dynamic employee) async {
    if (employee['employeeId'] != null && employee['employeeId'] is String) {
      try {
        await service.deleteEmployee(employee['employeeId']);
        Get.snackbar('Success', 'Employee deleted successfully');
        _fetchEmployees();
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete employee: ${e.toString()}');
      }
    } else {
      Get.snackbar('Error', 'Invalid employee ID');
    }
  }

  Future<void> _fetchEmployees() async {
    try {
      _employees = await service.getEmployees();
      setState(() {
        _filteredEmployees = _employees;
      });
    } catch (e) {
      print('Failed to fetch employees: ${e.toString()}');
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
              Get.offAllNamed(Croutes.EmployerPage);
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
                  onChanged: (query) => _searchEmployees(query),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey,),
                    hintText: 'Search Employee',
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
                      child: Text('All Employee', style: TextStyle(fontSize: 16,
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
                      itemCount: _filteredEmployees.length,
                      itemBuilder: (context, index) {
                        var employee = _filteredEmployees[index];
                        var employer = employee['employer'];
                        return FadeInRight(
                          duration: Duration(milliseconds: (index * 100) + 500),
                          child: GestureDetector(
                            onTap: () {
                              print(employee['employeeId']);
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeeTransactionHistory(
                                        id:'${employee['employeeId']}', username: '${employer['userName']}',
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
                                          title: Text('Delete Employee'),
                                          content: Text('Are you sure you want to delete this Employee?'),
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
                                                 await _deleteEmployee(employee);
                                                Navigator.pop(context);
                                                Get.snackbar('Employee Was Deleted', '',
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