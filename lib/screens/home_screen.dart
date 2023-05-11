import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/bottom_nav_icons_icons.dart';
import 'bottom_nav_screens/dashboard_screen.dart';
import 'bottom_nav_screens/orders_screen.dart';
import 'bottom_nav_screens/products_screen.dart';
import 'bottom_nav_screens/sold_products_screen.dart';
import 'bottom_nav_screens/user_profile.dart';
import 'package:shop_app/utilities/constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _children = [DashboardScreen(), ProductsScreen(), OrdersScreen(), UserProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Material(
        elevation: 10.0,
        child: Container(
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GNav(
                  activeColor: kPrimaryBrandColor,
                    tabBackgroundColor: Colors.purple.shade50,
                    color: Color(0xFF8F959E),
                    gap: 2.0,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                    tabs: [
                      GButton(
                        icon: BottomNavIcons.home,
                        text: 'Home',
                      ),
                      GButton(
                        icon: BottomNavIcons.product,
                        text: 'Products',
                      ),
                      GButton(
                        icon: BottomNavIcons.order,
                        text: 'Orders',
                      ),
                      GButton(
                        icon: BottomNavIcons.user,
                        text: 'Profile',
                      ),
                    ],
                  selectedIndex: _currentIndex,
                  onTabChange: onTabTapped,
                ),
              ),),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
//SvgPicture.asset('lib/icons/home.svg')
//SvgPicture.asset('lib/icons/product.svg')
//SvgPicture.asset('lib/icons/bookmark.svg')
//SvgPicture.asset('lib/icons/user-alt.svg')