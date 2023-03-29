import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class user_chatting_page_api {
  final String nickname;
  //final String img;
  final String content;

  const user_chatting_page_api({required this.nickname, required this.content});

  factory user_chatting_page_api.fromJson(Map<String, dynamic> json) {
    return user_chatting_page_api(
      nickname:  json['nickname'],
      //img: json['img'],
      content: json['content'],
    );
  }
}

class user_chatting_api {

  final String content;
  final String messagetype;

  const user_chatting_api({required this.messagetype, required this.content});

  factory user_chatting_api.fromJson(Map<String, dynamic> json) {
    return user_chatting_api(
      content: json['content'],
      messagetype:  json['messagetype'],
    );
  }
}

Future<user_chatting_page_api> user_profile_get(String id) async {
  final response = await http.get(
    Uri.http('52.79.223.14:8080', '/user/info/$id'),
  );
  if (response.statusCode == 200) {
    print('채팅 페이지 불러오기에 성공햇습니다');
    return user_chatting_page_api.fromJson(jsonDecode(response.body));
  } else {
    print('채팅 페이지 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<user_chatting_api> chatting_get() async {
  final response = await http.get(
    Uri.http('52.79.223.14:8080', '/pet/info'),
  );

  if (response.statusCode == 200) {
    print('채팅 정보 불러오기에 성공햇습니다');
    return user_chatting_api.fromJson(jsonDecode(response.body));
  } else {
    print('채팅 정보 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<user_chatting_api> chatting_post(String content, String messagetype) async {

  final response = await http.post(
    Uri.http('52.79.223.14:8080', '/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'content': content,
      'messagetype': messagetype,
    }),
  );
  if (response.statusCode == 200) {
    print('채팅 정보를 보냈습니다.');
    return user_chatting_api.fromJson(jsonDecode(response.body));
  } else {
    print('채팅 정보를 보내지 못햇습니다.');
    throw Exception('code check error');
  }
}