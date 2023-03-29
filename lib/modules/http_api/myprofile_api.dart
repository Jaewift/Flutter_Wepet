import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class user_profile_api {
  final String? nickname;
  final String? name;
  final String? phoneNumber;
  final String? email;

  user_profile_api(this.nickname, this.name,
      this.phoneNumber, this.email);

  factory user_profile_api.fromJson(dynamic json) {
    return user_profile_api(
      json['nickname'] as String,
      json['name'] as String,
      json['phoneNumber'] as String,
      json["email"] as String,
    );
  }

  @override
  String toString() {
    return '{${this.nickname}, ${this.name}, ${this.phoneNumber}, ${this.email}}';
  }
}

class pet_api {
  final String userId;
  final String name;
  final String category;
  final String age;
  final String registercode;
  final String gender;
  final String neutralization;

  const pet_api({ required this.userId, required this.category, required this.name, required this.age,
    required this.registercode, required this.neutralization, required this.gender,});

  factory pet_api.fromJson(Map<String, dynamic> json) {
    return pet_api(
      userId: json['userId'],
      name: json['name'],
      category: json['category'],
      age: json['age'],
      registercode: json['registercode'],
      neutralization: json['neutralization'],
      gender: json['gender'],
    );
  }
}

Future<List> user_profile_get() async {
  await Future.delayed(Duration(seconds: 2));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");

  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/users/myprofile'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  List<String> _datas = [];
  var _text = utf8.decode(response.bodyBytes);
  print(jsonDecode(_text)['data']);
  var dataObjsJson = jsonDecode(_text)['data'];
  _datas.add(dataObjsJson['nickname']);
  _datas.add(dataObjsJson['name']);
  _datas.add(dataObjsJson['phoneNumber']);
  _datas.add(dataObjsJson['email']);

  if (response.statusCode == 200) {
    print('유저 정보 불러오기에 성공햇습니다');
    return _datas;
  } else {
    print('유저 정보 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<List> pet_profile_get(int petid) async {
  await Future.delayed(Duration(seconds: 2));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  print(petid);

  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/pets/$petid'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  List<String> _datas = [];
  var _text = utf8.decode(response.bodyBytes);
  var dataObjsJson = jsonDecode(_text)['data'];
  print(dataObjsJson.runtimeType);
  _datas.add(dataObjsJson['name']);
  _datas.add(dataObjsJson['category']);
  _datas.add(dataObjsJson['age']);
  _datas.add(dataObjsJson['registercode']);
  _datas.add(dataObjsJson['gender']);
  _datas.add(dataObjsJson['neutralization']);

  if (response.statusCode == 200) {
    print('펫정보 불러오기에 성공햇습니다');
    print(jsonDecode(response.body));
    return _datas;
  } else {
    print('펫정보 불러오기에 실패햇습니다');
    print(response.statusCode);
    throw Exception('comment fail');
  }
}

Future<user_profile_api> user_profile_put(String nickname, String password, String phoneNumber) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");

  final response = await http.put(
    Uri.http('3.38.97.0:3000', ''),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'nickname': nickname,
      'password': password,
      'phoneNumber': phoneNumber
    }),
  );

  if (response.statusCode == 200) {
    print('유저 프로필 변경에 성공햇습니다');
    return user_profile_api.fromJson(jsonDecode(response.body));
  } else {
    print('유저 프로필 변경에 실패햇습니다');
    print(response.statusCode);
    throw Exception('comment fail');
  }
}

Future<pet_api> pet_api_put(int userId, String name,
    String category, int age, int registercode , String gender, String neutralization) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");

  final response = await http.put(
    Uri.http('3.38.97.0:3000', ''),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'userId' : userId,
      'name': name,
      'category': category,
      'age': age,
      'registercode': registercode,
      'gender': gender,
      'neutralization': neutralization,
    }),
  );

  if (response.statusCode == 200) {
    print('펫정보 변경에 성공햇습니다');
    return pet_api.fromJson(jsonDecode(response.body));
  } else {
    print('펫정보 변경에 실패햇습니다');
    print(response.statusCode);
    throw Exception('comment fail');
  }
}