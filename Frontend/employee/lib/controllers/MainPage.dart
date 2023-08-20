import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../routes/routes.dart';
import '../screens/Login/LoginScreen.dart';
import '../screens/Settings/ChangePassword.dart';

import '../screens/Settings/UpdateProfile.dart';
import '../screens/profileScreen/ProfileEmployee.dart';
import '../services/services.dart';
import 'ScanCodeQr.dart';



class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  bool _isScrolled = false;
  userformservice service = userformservice();
  List<String>  _name =[];
  List<double>  _prix= [];
  List<DateTime> _dates= [];
  List<DateTime> sortedDates = [];
  List<Map<String, dynamic>> transactions = [];
  int displayedItems = 3;
  List<dynamic> _services = [
    ['Scan', Iconsax.scan, Colors.blue],

    ['Bill', Iconsax.wallet_3, Colors.orange],

  ];
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
  String _balance='';
  String _username="";
  Future<void> _getData()async{
    dynamic value = await storage.read(key:'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _balance=dataresponse['balance'].toString();
      final dynamic employer3 = dataresponse["employer"];
      _username = employer3["userName"].toString();

    });
  }
  Future<void> _loadtransactions() async {
    if (!mounted) {
      return;
    }
    dynamic EmployeeId = await storage.read(key: 'idvalue');
    final List<Map<String, dynamic>>? gettransactions =
    await service.getTransactionsbyid(EmployeeId);
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
      dates.add(date.toUtc());
    }
    if (!mounted) {
      return;
    }
    setState(() {
      transactions = gettransactions;
      _name = names; // if you want to concatenate all the names into one string
      _prix = prices;
      _dates = dates;
      sortedDates = List.from(dates)..sort((a, b) => b.compareTo(a));
    });
  }

  void load()async {
    dynamic userdata = await storage.read(key:'employeeid');
    final dynamic data = await service.getbyid(userdata);
    setState(() {
      data;
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
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    load();
    _getData();
    _loadtransactions();

    super.initState();
  }
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
        backdropColor: Colors.grey.shade900,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900,
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: Offset(-20.0, 0.0),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));

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
                        child: Image.asset('assets/Profile_images/profile1.jpg')
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
                  SizedBox(height: 60,),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                    leading: Icon(Iconsax.security_safe),
                    title: Text('Account Security'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfile()));
                    },
                    leading: Icon(Iconsax.edit),
                    title: Text('Edit Profile'),
                  ),
                  SizedBox(height: 200,),
                  Divider(color: Colors.grey.shade800,),
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
                    child: Text('Dyno.app', style: TextStyle(color: Colors.grey.shade500),),
                  )
                ],
              ),
            ),
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body:  CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 250.0,
                      elevation: 0,
                      pinned: true,
                      stretch: true,
                      toolbarHeight: 80,
                      backgroundColor: Colors.indigo,



                      leading: IconButton(
                        color: Colors.cyanAccent,
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
                          icon: Icon(Iconsax.refresh, color: Colors.cyanAccent),
                          onPressed: ()async{
                            dynamic userdata = await storage.read(key:'employeeid');
                            final dynamic data = await service.getbyid(userdata);
                            setState(() {
                              data;
                              _getData();
                              _loadtransactions();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Iconsax.logout, color: Colors.cyanAccent),
                          onPressed: () {

                                  setState(() {
                                  _logout();
                                  });
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
                              "Total Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),),
                            Text(
                              "${_balance} DT",
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
                                    Text("Employee ",
                                      style: TextStyle(
                                        fontSize: 30,
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
                        delegate:SliverChildListDelegate([


                          SizedBox(height: 20,),
                          Container(
                            alignment: Alignment.topCenter,

                            padding: EdgeInsets.only(top: 10),
                            height: 100,
                            width: double.infinity,
                            child: ListView.builder(


                              scrollDirection: Axis.horizontal,


                              itemCount: _services.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FadeInDown(
                                      duration: Duration(milliseconds: (index + 1) * 100),
                                      child: AspectRatio(
                                        aspectRatio: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_services[index][0] == 'Scan') {
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample()));
                                            }
                                            if (_services[index][0] == 'Bill') {
                                              Get.offAllNamed(Croutes.balancehistory);
                                             //Navigator.push(context, MaterialPageRoute(builder: (context) => Balance()));
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Container(
                                                width: 80,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade900,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Icon(_services[index][1], color: Colors.white, size: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Text(_services[index][0], style: TextStyle(color: Colors.grey.shade800, fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    Text('Transactions History', style: TextStyle(color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.w600),),
                                    SizedBox(width: 10,),
                                    Text('${transactions.length}', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700,)),
                                  ]
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                if (displayedItems == transactions.length) ...[
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
                              ],

                            ),

                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 20),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: displayedItems <= sortedDates.length ? displayedItems : sortedDates.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int sortedIndex = _dates.indexOf(sortedDates[index]);
                                  return FadeInDown(
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



                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              _name[sortedIndex],
                                        style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 20),
                                            ),
                                            Text(
                                              '${_getElapsedTimeString(_dates[sortedIndex])} ago',
                                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${_prix[sortedIndex]} DT", style: TextStyle(color: Colors.grey.shade800, fontSize: 16, fontWeight: FontWeight.w700),
                                            ),
                                            Icon(Iconsax.arrow_up, size: 30,color: Colors.red,),
                                          ],
                                        ),

                                      ],
                                    ),
                                  )
                                  );
                                },
                              ),
                            ),

                            ],
                          ),
                        ),
                      )
                  ]
              ),
            )
        ),
    );

  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}