import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:jmsmart_project/modules/community_page/writing_alba_page.dart';
import 'package:jmsmart_project/modules/http_api/login_api.dart';
import 'package:jmsmart_project/modules/http_api/user_api.dart';
import 'package:jmsmart_project/modules/login_page/login_platform.dart';
import 'package:jmsmart_project/modules/login_page/pet_signup.dart';
import 'package:jmsmart_project/modules/login_page/signup_page.dart';
import 'package:jmsmart_project/modules/http_api/login_api.dart';
import 'package:jmsmart_project/modules/profile_page/profile_page.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../color/colors.dart';
import 'nav_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  int _userid = 0;
  String _usernickname = "";
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('localhost:3000', '/auth/kakao');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signOutKakao() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  void signOutGoogle() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AuthController authController = AuthController();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo/wepetmain.png",
                    width: size.height * 0.38,
                    height: size.height * 0.38,
                    // logo & 25% 크기
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "아이디(이메일)를 입력해주세요",
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                          fontFamily: 'GmarketSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: PRIMARY_COLOR, width: 1.5),
                      ),
                      fillColor: INPUT_BG_COLOR,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                    // 1% 여분
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 14),
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "비밀번호를 입력해주세요",
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                          fontFamily: 'GmarketSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: PRIMARY_COLOR, width: 1.5),
                      ),
                      fillColor: INPUT_BG_COLOR,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                    // 1% 여분
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignupPage();
                          }));
                        },
                        child: Text(
                          "  아이디 찾기 /",
                          style: TextStyle(
                            fontFamily: 'GmarketSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignupPage();
                          }));
                        },
                        child: Text(
                          " 비밀번호 찾기",
                          style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                    // 2% 여분
                  ),
                  Container(
                    height: 60,
                    width: 300,
                    child: TextButton(
                      onPressed: () async {
                        Future<bool> istrue = login_post(
                            emailController.text, passwordController.text);
                        bool isstrue = await istrue ;
                        if (isstrue == true) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (context) => PetSignupPage()));
                        }
                        else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('아이디나 비밀번호가 틀립니다.'),
                                actions: [
                                  TextButton(
                                    child: Text("네", style: TextStyle(
                                      color: PRIMARY_COLOR,),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });}
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ))),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  maxWidth: double.infinity, minHeight: 100),
                              child: Text(
                                "로그인",
                                style: TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.0,
                            width: 80.0,
                            color: Colors.black,
                          ),
                          Container(
                            child: Text(
                              "    SNS 간편 로그인    ",
                              style: TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 80.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                        // 3% 여분
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: size.width * 0.01,
                            // 3% 여분
                          ),
                          Container(
                            height: size.height * 0.08,
                            width: 80,
                              child: _loginPlatform != LoginPlatform.none
                                  ? _logoutGoogleButton()
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _loginGoogleButton(
                                    'logo_google',
                                    signInWithGoogle,
                                  )
                                ],
                              )
                          ),
                          Container(
                            height: size.height * 0.08,
                            width: 80,
                            child: _loginPlatform != LoginPlatform.none
                                ? _logoutKakaoButton()
                                :(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _loginKakaoButton(
                                    'logo_kakao',
                                    signInWithKakao,
                                  )
                                ],
                              )
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                            // 3% 여분
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
                // 3% 여분
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "혹시 위펫이 처음이시라면, ",
                      style: TextStyle(
                          fontFamily: 'GmarketSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignupPage();
                        }));
                      },
                      child: Text(
                        "회원가입",
                        style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: PRIMARY_COLOR),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginKakaoButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/social/$path.png'),
        width: 50,
        height: 50,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _loginGoogleButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/social/$path.png'),
        width: 50,
        height: 50,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutKakaoButton() {
    return ElevatedButton(
      onPressed: signOutKakao,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }

  Widget _logoutGoogleButton() {
    return ElevatedButton(
      onPressed: signOutGoogle,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}
