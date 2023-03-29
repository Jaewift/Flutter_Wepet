import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class alba_writing_api {
  final int recruitId;
  final int userId;
  final String nickname;
  final String title;
  final String content;
  final String createdAt;

  const alba_writing_api({required this.recruitId, required this.userId, required this.nickname,
    required this.title, required this.content, required this.createdAt});

  factory alba_writing_api.fromJson(Map<String, dynamic> json) {
    return alba_writing_api(
        recruitId: json['recruitId'],
      userId: json['userId'],
      nickname: json['nickname'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt']
    );
  }
}

class alba_comment_api {
  final int RecruitCommentId;
  final int userId;
  final int recruitId;
  final String comment;
  final String createdAt;

  const alba_comment_api({required this.RecruitCommentId, required this.userId, required this.recruitId,
    required this.comment, required this.createdAt});

  factory alba_comment_api.fromJson(Map<String, dynamic> json) {
    return alba_comment_api(
        RecruitCommentId: json['RecruitCommentId'],
        userId: json['userId'],
        recruitId: json['recruitId'],
        comment: json['comment'],
        createdAt: json['createdAt']
    );
  }
}

Future<alba_comment_api> alba_comment_post(String comment, String recruitId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/recruitcomments/$recruitId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'comment': comment,
    }),
  );

  if (response.statusCode == 201) {
    print('댓글 작성에 성공햇습니다');
    print(comment);
    return alba_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 작성에 실패햇습니다');
    print(response.statusCode);
    print(response.body);
    throw Exception('comment fail');
  }
}

Future<alba_comment_api> alba_comment_delete(String recruitcommentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
      Uri.http('3.38.97.0:3000', '/recruitcomments/$recruitcommentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );

  if (response.statusCode == 200) {
    print('댓글 삭제에 성공햇습니다');
    return alba_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 삭제에 실패햇습니다');
    throw Exception('Failed to delete comment.');
  }
}

Future<alba_writing_api> alba_writing_post(String title, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/recruits'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'content': content,
    }),
  );

  if (response.statusCode == 200) {
    print('알바글 작성에 성공햇습니다');
    print(content);
    return alba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    print(response.body);
    print('알바글 작성에 실패햇습니다');
    throw Exception('alba fail');
  }
}

Future<alba_writing_api> alba_writing_get(String recruitId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/recruits/$recruitId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('알바게시글 불러오기에 성공햇습니다');
    print(json.decode(response.body));
    return alba_writing_api.fromJson(json.decode(response.body));
  } else {
    print('알바게시글 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<alba_writing_api> alba_writing_put(int recruitId, String title, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('3.38.97.0:3000', '/recruits/$recruitId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'content': content
    }),
  );

  if (response.statusCode == 200) {
    print('게시글 수정에 성공햇습니다');
    print(content);
    return alba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 수정에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<alba_writing_api> alba_writing_delete(String recruitId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
      Uri.http('3.38.97.0:3000', '/recruits/$recruitId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );

  if (response.statusCode == 200) {
    print('게시글 삭제에 성공햇습니다');
    return alba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 삭제에 실패햇습니다');
    throw Exception('Failed to delete writing.');
  }
}