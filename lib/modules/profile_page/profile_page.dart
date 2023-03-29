import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:jmsmart_project/modules/http_api/myprofile_api.dart';
import 'package:jmsmart_project/modules/login_page/login_page.dart';
import 'package:jmsmart_project/modules/login_page/pet_signup.dart';
import 'package:jmsmart_project/modules/profile_page/friends_page.dart';
import 'package:jmsmart_project/modules/profile_page/pet_settings_page.dart';
import 'package:jmsmart_project/modules/profile_page/profile_settings_page.dart';
import 'package:jmsmart_project/modules/profile_page/wepet_settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition/transition.dart';

import '../color/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Future<List>? user_info;
  Future<List>? pet_info;

  int _userid = 0;
  int _petid = 0;
  String _usernickname = "";
  String _accesstoken = "";


  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userid = (prefs.getInt('userId') ?? 0);
      _usernickname = (prefs.getString('userNickname') ?? "");
      _accesstoken = (prefs.getString('accessToken') ?? "");
      _petid = (prefs.getInt('petId') ?? 0);
    });
    pet_info = pet_profile_get(_petid);
    user_info = user_profile_get();
    print(_userid);
    print(_petid);
    print(_usernickname);
    print(_accesstoken);
  }

  @override
  void initState  () {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "마이 프로필",
                      style:
                      TextStyle(fontFamily: 'GmarketSans', fontSize: 36, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      width: size.width * 0.07,
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   height: 30,
                    //   width: 55,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: PRIMARY_COLOR,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10))),
                    //     child: const Text(
                    //       "친구",
                    //       style: TextStyle(
                    //           fontSize: 12,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   height: 30,
                    //   width: 55,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) => WepetSettingsPage()));
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: PRIMARY_COLOR,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10))),
                    //     child: const Text(
                    //       "설정",
                    //       style: TextStyle(
                    //           fontSize: 12,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: 155,
                  width: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      border: Border.all(color: PRIMARY_COLOR, width: 2)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/profile/people.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 6,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: 80,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                        Transition(
                                            child: ProfileSettingsPage(),
                                            transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    child: const Text(
                                      "프로필 설정",
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('닉네임 :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Center(
                                    child: FutureBuilder<List>(
                                      future: user_info,
                                      builder: (context, snapshot) {
                                        print(snapshot.runtimeType);
                                        if (snapshot.hasData) {
                                          print(snapshot.data); // question
                                          print(snapshot.error); // null
                                          return Text(snapshot.data![0],
                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 13,
                                                  color: Colors.black)
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return CircularProgressIndicator();
                                      },
                                    ),
                                  ),
                                  height: 30,
                                  width: size.width * 0.15,
                                  //color: Colors.grey,
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('이름 :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Center(
                                    child: FutureBuilder<List>(
                                      future: user_info,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data![1],
                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 13,
                                                  color: Colors.black)
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                  height: 30,
                                  width: size.width * 0.15,
                                  //color: Colors.grey,
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('전화번호 :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Center(
                                    child: FutureBuilder(
                                      future: user_info,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data![2],
                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 13,
                                                  color: Colors.black)
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                  height: 30,
                                  width: size.width * 0.28,
                                  //color: Colors.grey,
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('이메일 :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Center(
                                    child: FutureBuilder<List>(
                                      future: user_info,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data![3],

                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 12,
                                                  color: Colors.black)
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                  height: 30,
                                  width: size.width * 0.3,
                                  //color: Colors.grey,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    Container(
                      height: 380,
                      width: 220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          border: Border.all(color: PRIMARY_COLOR, width: 2)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/profile/animal.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 15,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: 70,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        Transition(
                                            child: PetSettingsPage(),
                                            transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    child: const Text(
                                      "펫 설정",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('펫 이름 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![0],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('종 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![1],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('나이 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![2],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('등록번호 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![3],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('성별 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![4],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              const Text('중성화 유무 :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                child: Center(
                                  child: FutureBuilder(
                                    future: pet_info,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data![5],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                color: Colors.black)
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Text('');
                                    },
                                  ),
                                ),
                                height: 30,
                                width: size.width * 0.2,
                                //color: Colors.grey,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.5,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "로그아웃 /",
                                style: TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                " 회원탈퇴",
                                style: TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
