import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_api {
  final String id;
  final String password;

  const login_api({required this.id, required this.password});

  factory login_api.fromJson(Map<String, dynamic> json) {
    return login_api(
      id: json['id'],
      password: json['password']
    );
  }
}

class user_api {
  final String nickname;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const user_api({required this.nickname, required this.name,
    required this.email, required this.password,
    required this.phoneNumber});

  factory user_api.fromJson(Map<String, dynamic> json) {
    return user_api(
      nickname:  json['nickname'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

Future<bool> login_post(String id, String password) async {
  final storage = FlutterSecureStorage();

  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': id,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    print('로그인에 성공햇습니다');
    // var loginArr = json.decode(response.body);
    // String token = loginArr["accessToken"]; // response의 token키에 담긴 값을 token 변수에 담아서
    // Map<String, dynamic> payload = Jwt.parseJwt(token); // 토큰 내부의 값을 Map 구조에 담는다
    // var loginID = payload['userId'];
    // var val = loginArr('$token', '$loginID');
    // await storage.write( key: 'login', value: val );
    var loginArr = await json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _userid = loginArr['userId'];
    final _usernickname = loginArr['nickname'];
    final _accesstoken = loginArr['accessToken'];
    prefs.setInt('userId', _userid);
    prefs.setString('userNickname', _usernickname);
    prefs.setString('accessToken', _accesstoken);
    print(_userid);
    print(_usernickname);
    print(_accesstoken);
    return true;
  } else {
    print('로그인에 실패햇습니다');
    throw Exception('login fail');
  }
}

// Future<login_api> getAlbum() async {
//   final response = await http.get(
//     Uri.parse('aws_uri'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     return login_api.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to cr.');
//   }
// }

Future<user_api> user_signup_post(String email, String nickname,
    String name, String password,
    String phoneNumber) async {
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nickname': nickname,
      'name': name,
      'email': email,
      'password': password,
      //'address': address,
      'phoneNumber': phoneNumber
    }),
  );
  if (response.statusCode == 201) {
    print('회원가입에 성공햇습니다');
    return user_api.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    print(response.body);
    print('회원가입에 실패햇습니다');
    throw Exception('user signup fail');
  }
}

Future<user_api> nickname_reduplication_post(String nickname) async {
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nickname': nickname,
    }),
  );
  if (response.statusCode == 200) {
    print('닉네임이 중복이 아닙니다');
    return user_api.fromJson(jsonDecode(response.body));
  } else {
    print('닉네임이 중복입니다.');
    throw Exception('nickname reduplication error');
  }
}

Future<user_api> id_reduplication_post(String email) async {
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
    }),
  );
  if (response.statusCode == 200) {
    print('이메일이 중복이 아닙니다');
    return user_api.fromJson(jsonDecode(response.body));
  } else {
    print('이메일이 중복입니다.');
    throw Exception('email reduplication error');
  }
}

Future<user_api> authentication_code_post(String email) async {
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/emailcheck'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
    }),
  );
  if (response.statusCode == 200) {
    print('인증코드를 보냇습니다.');
    return user_api.fromJson(jsonDecode(response.body));
  } else {
    print('인증코드를 보내지 못햇습니다');
    throw Exception('code post error');
  }
}

Future<bool> authentication_code_check_post(String email, int certificationNum) async {

  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/users/emailcheck/auth'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'certificationNum': certificationNum,
    }),
  );
  if (response.statusCode == 200) {
    print('인증코드를 일치합니다.');
    return true;
  } else {
    print(response.statusCode);
    print(response.body);
    print('인증코드를 일치 하지 않습니다.');
    return false;
    throw Exception('code check error');
  }
}