import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:jmsmart_project/modules/community_page/alba_page.dart';
import 'package:jmsmart_project/modules/walking_page/walking_page.dart';
import 'package:jmsmart_project/modules/care_page/care_page.dart';
import 'package:jmsmart_project/modules/chatting_page/chatting_page.dart';
import 'package:jmsmart_project/modules/profile_page/profile_page.dart';

import '../color/colors.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  @override

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    WalkingPage(),
    CommunityPage(),
    CarePage(),
    ChattingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat used firebase',
      theme: ThemeData(primaryColor: Colors.white),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.green[400],
            selectedItemColor: Colors.black,
            selectedFontSize: 10,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.w500),
            unselectedFontSize: 10,
            unselectedLabelStyle: TextStyle(fontFamily: 'GmarketSans', fontWeight: FontWeight.w500),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              BottomNavigationBarItem(
                label: '산책',
                icon: Image.asset(
                  'assets/images/nav/dog_walking_white.png',
                  width: 25,
                  height: 25,
                ),
                activeIcon: Image.asset(
                  'assets/images/nav/dog_walking_dark.png',
                  width: 25,
                  height: 25,
                ),
              ),
              BottomNavigationBarItem(
                  label: '커뮤니티',
                  icon: Image.asset(
                    'assets/images/nav/community_white.png',
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav/community_dark.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  label: '펫 케어',
                  icon: Image.asset(
                    'assets/images/nav/care_white.png',
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav/care_dark.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  label: '채팅',
                  icon: Image.asset(
                    'assets/images/nav/chat_white.png',
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav/chat_dark.png',
                    width: 25,
                    height: 25,
                  )),
              BottomNavigationBarItem(
                  label: '마이페이지',
                  icon: Image.asset(
                    'assets/images/nav/user_white.png',
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav/user_dark.png',
                    width: 25,
                    height: 25,
                  )),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
