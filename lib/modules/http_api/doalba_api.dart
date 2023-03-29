import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class doalba_writing_api {
  final int applyId;
  final int userId;
  final String nickname;
  final String title;
  final String content;
  final String createdAt;

  const doalba_writing_api({required this.applyId, required this.userId, required this.nickname,
    required this.title, required this.content, required this.createdAt});

  factory doalba_writing_api.fromJson(Map<String, dynamic> json) {
    return doalba_writing_api(
        applyId: json['applyId'],
        userId: json['userId'],
        nickname: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: json['createdAt']
    );
  }
}

class doalba_comment_api {
  final int applycommentId;
  final int userId;
  final int applyId;
  final String comment;
  final String createdAt;

  const doalba_comment_api({required this.applycommentId, required this.userId, required this.applyId,
    required this.comment, required this.createdAt});

  factory doalba_comment_api.fromJson(Map<String, dynamic> json) {
    return doalba_comment_api(
        applycommentId: json['applycommentId'],
        userId: json['userId'],
        applyId: json['applyId'],
        comment: json['comment'],
        createdAt: json['createdAt']
    );
  }
}

Future<doalba_comment_api> doalba_comment_post(String comment, String applyId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/applycomments/$applyId'),
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
    return doalba_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 작성에 실패햇습니다');
    print(response.statusCode);
    print(response.body);
    throw Exception('comment fail');
  }
}

Future<doalba_comment_api> doalba_comment_delete(String applycommentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
      Uri.http('3.38.97.0:3000', '/applycomments/$applycommentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );

  if (response.statusCode == 200) {
    print('댓글 삭제에 성공햇습니다');
    return doalba_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 삭제에 실패햇습니다');
    throw Exception('Failed to delete comment.');
  }
}

Future<doalba_writing_api> doalba_writing_post(String title, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/applies'),
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
    return doalba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    print(response.body);
    print('알바글 작성에 실패햇습니다');
    throw Exception('alba fail');
  }
}

Future<doalba_writing_api> doalba_writing_get(int applyId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/applies/$applyId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('알바게시글 불러오기에 성공햇습니다');
    print(json.decode(response.body));
    return doalba_writing_api.fromJson(json.decode(response.body));
  } else {
    print('알바게시글 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<doalba_writing_api> doalba_writing_put(int applyId, String title, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('3.38.97.0:3000', '/applies/$applyId'),
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
    return doalba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 수정에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<doalba_writing_api> doalba_writing_delete(String applyId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
      Uri.http('3.38.97.0:3000', '/applies/$applyId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );

  if (response.statusCode == 200) {
    print('게시글 삭제에 성공햇습니다');
    return doalba_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 삭제에 실패햇습니다');
    throw Exception('Failed to delete writing.');
  }
}