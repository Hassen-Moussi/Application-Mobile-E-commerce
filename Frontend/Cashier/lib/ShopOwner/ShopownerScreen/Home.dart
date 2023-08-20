import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import '../../../Services/service.dart';
import '../../../routes/routes.dart';

import '../../screens/ProfileManagementScreens/login.dart';
import '../../screens/Settings/ChangePassword.dart';
import 'CashierManager.dart';
import 'ChangePassword.dart';
import 'NewCashier.dart';
import 'ShopownerProfile.dart';






class ShopownerHomePage extends StatefulWidget {
  const ShopownerHomePage({ Key? key }) : super(key: key);

  @override
  _ShopownerHomePage createState() => _ShopownerHomePage();
}

class _ShopownerHomePage extends State<ShopownerHomePage> {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  userformservice service = userformservice();
  List<String>  _name =[];
  List<double>  _prix= [];
  List<DateTime> _dates= [];
  List<DateTime> sortedDates = [];
  List<Map<String, dynamic>> transactions = [];



  String searchText ='';
  String shopownerid = '';
  List<dynamic> balanceHistory = [];
  int balanceHistoryCount = 0;
  int displayedItems = 3;

  Future<void> getshopownerid() async {
    dynamic id = await storage.read(key: 'shopownerid');
    setState(() {
      shopownerid = id;
    });
  }


  Future<void> getShopownerAmountTakenHistory() async {
    List<dynamic> history =
    await service.getShopownerAmountTakenBalanceHistory(shopownerid);
    setState(() {
      balanceHistory = history;
      balanceHistoryCount = history.length;
    });
  }


  List<dynamic> _services = [
    ['Retrieve-Money', Iconsax.money_recive, Colors.blue],
    ['New Cashier', Iconsax.user_add, Colors.pink],
    ['C-Manager', Iconsax.user_edit4, Colors.orange],
  ];


  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    getshopownerid().then((_) => getShopownerAmountTakenHistory());
    _getData();
    super.initState();
  }
  void _logout() async {
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }
  final _advancedDrawerController = AdvancedDrawerController();
  String _paymentMethode='';
  String _username="";
  String _balance="";
  Future<void> _getData()async{
    dynamic value = await storage.read(key:'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _paymentMethode=dataresponse['paymentMethode'].toString();
      final dynamic employer3 = dataresponse["employer"];
      _username= employer3["userName"].toString();
      _balance = dataresponse['balance'].toString();
    });
  }
  // Future<void> _loadtransactions() async {
  //   dynamic EmployeeId = await storage.read(key: 'idvalue');
  //   final List<Map<String, dynamic>>? gettransactions =
  //   await service.getAllTransactions(EmployeeId);
  //   List<String> names = [];
  //   List<double> prices = [];
  //   List<DateTime> dates = [];
  //   for (var transaction in gettransactions!) {
  //     names.add(transaction['name']);
  //     double? price = double.tryParse(transaction['prix'] ?? '');
  //     if (price != null) {
  //       prices.add(price);
  //     }
  //     DateTime date = DateTime.parse(transaction['datecreation']);
  //     dates.add(date.toUtc());
  //   }
  //   setState(() {
  //     transactions = gettransactions;
  //     _name = names; // if you want to concatenate all the names into one string
  //     _prix = prices;
  //     _dates = dates;
  //     sortedDates = List.from(dates)..sort((a, b) => b.compareTo(a));
  //   });
  // }
  //
  //
  // String _getElapsedTimeString(DateTime transactionDate) {
  //   final now = DateTime.now();
  //   final difference = now.difference(transactionDate);
  //
  //   if (difference.inMinutes < 1) {
  //     return 'just now';
  //   } else if (difference.inMinutes < 60) {
  //     return '${difference.inMinutes} min';
  //   } else if (difference.inHours < 24) {
  //     return '${difference.inHours} h';
  //   } else {
  //     return '${difference.inDays} d';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        final value= await showDialog<bool>(context: context, builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,


            title: const Text('Exit'),
            content: Text('Do yo want to exit', style: TextStyle(color: Colors.black87, fontSize: 20),),
            actions: [
              TextButton(onPressed: ()=>
                  Navigator.of(context).pop(false),
                  child:Text("No", style: TextStyle(color: Colors.redAccent, fontSize: 20),)
              ),


              TextButton(onPressed: ()=>
                  Navigator.of(context).pop(true),
                  child:Text("Yes", style: TextStyle(color: Colors.green, fontSize: 20),)
              )


            ],
          );
        });
        if(value!=null){
          return Future.value(value);
        }
        else{
          return Future.value(false);
        }
      },
      child: AdvancedDrawer(
        backdropColor: Colors.black45,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade900,
              blurRadius: 30.0,
              spreadRadius: 7.0,
              offset: Offset(-40.0, 0.0),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        drawer: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminProfile()));

                    },
                    child: Container(
                        width: 80.0,
                        height: 80.0,
                        margin: EdgeInsets.only(
                          left: 20,
                          top: 24.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/avatar-1.png')
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Column(
                      children: [
                        Text("${_username} ",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                        Text(
                          "Total Balance : ${_balance} DT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade800,),

                  SizedBox(height: 50,),
                  Divider(color: Colors.grey.shade800),
                  ListTile(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ShopownerChangePassword()));},
                    leading: Icon(Iconsax.security_safe),
                    title: Text('Account Security'),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        _logout();
                      });
                    },
                    leading: Icon(Iconsax.logout),
                    title: Text('Log-out'),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Dyno Company', style: TextStyle(color: Colors.grey.shade500),),
                  )
                ],
              ),
            ),
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    elevation: 0,
                    pinned: true,
                    stretch: true,
                    toolbarHeight: 80,
                    backgroundColor: Colors.blue.shade900,
                    leading: IconButton(
                      color: Colors.tealAccent,
                      onPressed: _handleMenuButtonPressed,
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _advancedDrawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            child: Icon(
                              value.visible ? Iconsax.close_square : Iconsax.menu,
                              key: ValueKey<bool>(value.visible),
                            ),
                          );
                        },
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Iconsax.refresh, color: Colors.tealAccent),
                        onPressed: () async{
                          dynamic cashierdata = await storage.read(key:'cashierid');
                          final dynamic shopownerinfo = await service.getbyid(cashierdata);
                          setState(() {
                            shopownerinfo;
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>ShopownerHomePage()));
                          });

                        },
                      ),
                      IconButton(
                        icon: Icon(Iconsax.logout, color: Colors.tealAccent),
                        onPressed: () {

                          _logout();

                        },
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    centerTitle: true,
                    title: AnimatedOpacity(
                      opacity: _isScrolled ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          Text(
                            "Payment Methode",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),),
                          Text(
                            "${_paymentMethode} ",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,

                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: 30,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      titlePadding: const EdgeInsets.only(left: 20, right: 20),
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _isScrolled ? 0.0 : 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FadeIn(
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Current Account', style: TextStyle(color: Colors.greenAccent, fontSize: 10),),
                                  SizedBox(width: 3,),
                                  Text("ShopOwner ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50,),


                            Container(
                              width: 30,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(height: 8,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          height: 115,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _services.length,
                            itemBuilder: (context, index) {
                              return FadeInDown(
                                duration: Duration(milliseconds: (index + 1) * 100),
                                child: AspectRatio(
                                  aspectRatio: 1.2,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_services[index][0] == 'Retrieve-Money') {
                                        Get.offAllNamed(Croutes.contact);
                                      }
                                      if (_services[index][0] == 'New Cashier') {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewCashier()));
                                      }
                                      if (_services[index][0] == 'C-Manager') {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserManager()));
                                      }
                                    },
                                    child: Column(

                                      children: [

                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Icon(_services[index][1], color: Colors.white, size: 25,),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(_services[index][0], style: TextStyle(color: Colors.grey.shade800, fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ])
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: Column(
                        children: [
                          FadeInDown(
                            duration: Duration(milliseconds: 500),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Transactions History',
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (displayedItems < balanceHistoryCount) ...[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          displayedItems += 3;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Show More   ",style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey
                                          ),),
                                          Icon(Iconsax.more,size: 15,color: Colors.grey,)
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (displayedItems == balanceHistoryCount) ...[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          displayedItems -= 3;
                                        });
                                      },
                                      child: Text("Hidden",style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey
                                      ),),
                                    ),
                                  ],
                                  // Text('${balanceHistory.length}',
                                  //     style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w700,
                                  //     )),
                                ]),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchText = value;
                                    });
                                  },

                                  showCursor: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    prefixIcon: Icon(Icons.search, color: Colors.grey,),
                                    hintText: 'Search by username',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: displayedItems,
                                    itemBuilder: (context, index) {
                                      if (index < balanceHistoryCount) {
                                        var historyItem =
                                        balanceHistory.reversed.toList()[index];
                                        DateTime createdTime =
                                        DateTime.parse(historyItem['date'])
                                            .add(Duration(hours: 1));
                                        String timeAgo =
                                        DateFormat.yMd().add_jm().format(createdTime);
                                        return FutureBuilder<String>(
                                          future: service.getCashierUsername(historyItem['cashierid']),
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.hasData) {
                                              String casheirName = snapshot.data!;
                                              if (casheirName.toLowerCase().contains(searchText.toLowerCase())) {
                                                return  FadeInDown(
                                                    duration: Duration(milliseconds: 500),
                                                    child: Container(
                                                      margin: EdgeInsets.only(bottom: 10),
                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.shade200,
                                                            blurRadius: 5,
                                                            spreadRadius: 1,
                                                            offset: Offset(0, 6),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [



                                                          Row(

                                                            children: [
                                                              Icon(Iconsax.user,size:30),
                                                              FutureBuilder<String>(
                                                                future: service.getCashierUsername(historyItem['cashierid']),
                                                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    String casheirName = snapshot.data!;

                                                                    return Text(' $casheirName', style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 20),);
                                                                  } else {
                                                                    return Text('Employee Name : Loading');
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Text('            $timeAgo', style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 11),),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(' ${historyItem['balancetaken']} DT', style: TextStyle(color: Colors.grey.shade800, fontSize: 16, fontWeight: FontWeight.w700),),
                                                              Icon(Iconsax.arrow_down,size: 25,color: Colors.green,)
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )

                                                );
                                              }
                                            }
                                            return SizedBox.shrink();
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            )
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
