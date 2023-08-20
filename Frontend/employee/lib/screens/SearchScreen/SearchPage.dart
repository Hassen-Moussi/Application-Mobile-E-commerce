import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../routes/routes.dart';
import '../../services/services.dart';

class SearchForUsersPage extends StatefulWidget {
  @override
  _SearchForUsersPageState createState() => _SearchForUsersPageState();
}

class _SearchForUsersPageState extends State<SearchForUsersPage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  final storage = new FlutterSecureStorage();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query == null || query.isEmpty) { // add a null check here
      setState(() {
        _users = [];
      });
      return;
    }
    var url = 'http://192.168.1.213:5031/ManageUsers/searchUsers?username=$query';
    Map<String, String> headersAuth = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headersAuth,
    );
    if (response.statusCode == 200) {
      List<dynamic> dataList = json.decode(response.body);
      List<Map<String, dynamic>> searchlist = dataList.map((item) => Map<String, dynamic>.from(item)).toList();
      print(searchlist);
      setState(() {
        _users = searchlist;
      });
    } else {
      setState(() {
        _users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for users...',
            border: InputBorder.none,
          ),
          onChanged: _searchUsers,
        ),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return GestureDetector(
            onTap: () async {
              final saveid = await storage.write(key: 'empId', value: user["employeeId"]);
              setState(() {
                saveid;
                print(user["employeeId"]);
                Get.offAllNamed(Croutes.chatscreen);
              });
            },
            child: Card(
              child: ListTile(
                title: Text(user['userName']),
                subtitle: Text(user['email']),
              ),
            ),
          );
        },
      ),
    );
  }
}