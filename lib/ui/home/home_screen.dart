import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dustbin/ui/home/dustbin_screen.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../auth/profile_screen.dart';
import 'default.dart';
import 'dustbin_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.firebaseAuth}) : super(key: key);

  final FirebaseAuth firebaseAuth;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller;
  Future<UserModel> userModel;
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
    print('eta');
    final uid = SharedPreferences.getInstance()
        .then((value) => (value.getString('uid')));

    userModel = uid.then(
      (value) => AuthService(widget.firebaseAuth).getCurrentUser(value),
    );

    // user = user.then((value) => userModel = value);
    // .then((value) => userModel = value);
    print(uid);
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: Theme.of(context).accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.home,
          color: Colors.white,
        ),
        title: ("Home"),
        activeColorPrimary: Theme.of(context).accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.trash),
        title: ("Dustbins"),
        activeColorPrimary: Theme.of(context).accentColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      ProfileScreen(userModel: userModel),
      // Container(),
      DefaultScreen(),
      DustbinScreen(),
    ];
  }
}
