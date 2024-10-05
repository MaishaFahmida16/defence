import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/login/Pages/loginPage.dart';
import 'package:firebase/profile.dart';
import 'package:firebase/trending_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'const/color_helper.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  OnboardingController onboardingController=Get.put(OnboardingController());
  ShopController shopController=Get.put(ShopController());
  @override
  void initState() {
   getDate();
    // TODO: implement initState
    super.initState();
  }
  void getDate() async{
    await onboardingController.getProfile();
    await shopController.getOrderList();
    await shopController.getShopList();
  }
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    TrendingPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

