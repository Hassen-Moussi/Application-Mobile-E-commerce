import'package:flutter/material.dart';

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/MainPage.dart';
import '../../controllers/WalletPage.dart';
import '../profileScreen/ProfileEmployee.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              children: [
                 HomePage(),
                  Wallet(),
                  Wallet(),
                Profile(),


              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingNavbar(
                onTap: (i) {
                  setState(() {
                    index = i;
                    controller.jumpToPage(index);


                  });
                },


                currentIndex: index,
                borderRadius: 24,
                iconSize: 32,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                selectedBackgroundColor: Colors.transparent,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                backgroundColor: Color(0xff2f1155),
                items: [
                  FloatingNavbarItem(icon: Iconsax.home),

                  FloatingNavbarItem(icon: Iconsax.wallet),
                  FloatingNavbarItem(icon: Iconsax.notification),
                  FloatingNavbarItem(icon: Iconsax.user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
