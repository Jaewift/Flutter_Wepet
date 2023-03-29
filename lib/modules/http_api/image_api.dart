import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class image_api {
  final String file;

  const image_api({required this.file});

  factory image_api.fromJson(Map<String, dynamic> json) {
    return image_api(
        file: json['file']
    );
  }
}

Future<image_api> image_post(String file) async {
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/communities'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'file': file
    }),
  );
  if (response.statusCode == 201) {
    print('회원가입에 성공햇습니다');
    return image_api.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    print(response.body);
    print('회원가입에 실패햇습니다');
    throw Exception('user signup fail');
  }
}