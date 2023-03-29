// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthController {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   Future loginUser() async {
//     const _url = '3.38.97.0:3000/users/login';
//
//     var response = await http.post(Uri.parse(_url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//       "email": emailController.text,
//       "password": passwordController.text
//     }));
//
//     if(response.statusCode == 201) {
//       var loginArr = json.decode(response.body);
//       print('로그인에 성공햇습니다');
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final _userid = loginArr['userId'];
//       final _usernickname = loginArr['nickname'];
//       prefs.setInt('userId', _userid);
//       prefs.setString('userNickname', _usernickname);
//       print(loginArr['userId']);
//       print(loginArr['nickname']);
//       print(loginArr['accesstoken']);
//       print(loginArr['refreshtoken']);
//     } else {
//       print(response.statusCode);
//       print("Login Error");
//     }
//   }
// }