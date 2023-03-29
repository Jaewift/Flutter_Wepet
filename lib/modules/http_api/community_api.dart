import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class community_writing_api {
  final int? communityId;
  final int? userId;
  final String? nickname;
  final String? title;
  final String? content;
  final int? likeCount;
  final String? createdAt;

  const community_writing_api({required this.communityId, required this.userId, required this.nickname,
    required this.title, required this.content, required this.likeCount, required this.createdAt});

  factory community_writing_api.fromJson(Map<String, dynamic> json) {
    return community_writing_api(
      communityId: json['communityId'],
      userId: json['userId'],
      nickname: json['nickname'],
      title: json['title'],
      content: json['content'],
        likeCount: json['likeCount'],
      createdAt: json['createdAt']
    );
  }
}

class community_comment_api {
  final int commentId;
  final int userId;
  final String nickname;
  final int communityId;
  final String usernickname;
  final String comment;
  final String createdAt;

  const community_comment_api({required this.commentId, required this.userId, required this.nickname, required this.communityId,
    required this.usernickname, required this.comment, required this.createdAt});

  factory community_comment_api.fromJson(Map<String, dynamic> json) {
    return community_comment_api(
        commentId: json['commentId'],
        userId: json['userId'],
        nickname: json['nickname'],
        communityId: json['communityId'],
        usernickname: json['usernickname'],
        comment: json['comment'],
        createdAt: json['createdAt']
    );
  }
}

Future<community_comment_api> community_comment_put(int commentId, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('52.79.223.14:8080', '/comments/$commentId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'content':content,
    }),
  );

  if (response.statusCode == 200) {
    print('댓글 수정에 성공햇습니다');
    print(content);
    return community_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 수정에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<community_comment_api> community_comment_post(String comment, String communityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/comments/$communityId'),
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
    return community_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 작성에 실패햇습니다');
    print(response.statusCode);
    print(response.body);
    throw Exception('comment fail');
  }
}

Future<community_comment_api> community_comment_get(int communityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/comments/$communityId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('댓글 불러오기에 성공햇습니다');
    print(json.decode(response.body));
    return community_comment_api.fromJson(json.decode(response.body));
  } else {
    print('댓글 불러오기에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future<community_comment_api> community_comment_delete(String commentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
    Uri.http('3.38.97.0:3000', '/comments/$commentId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    }
  );

  if (response.statusCode == 200) {
    print('댓글 삭제에 성공햇습니다');
    return community_comment_api.fromJson(jsonDecode(response.body));
  } else {
    print('댓글 삭제에 실패햇습니다');
    throw Exception('Failed to delete comment.');
  }
}

Future<community_writing_api> community_writing_put(int communityId, String title, String content) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('3.38.97.0:3000', '/communities/$communityId'),
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
    return community_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 수정에 실패햇습니다');
    throw Exception('comment fail');
  }
}

Future <community_writing_api> community_writing_post(String title, String content, String image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.post(
    Uri.http('3.38.97.0:3000', '/communities'),
    headers: <String, String>{
      'Content-type': 'multipart/form-data',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'content': content,
      'image': image
    }),
  );

  if (response.statusCode == 201) {
    print('게시글 작성에 성공햇습니다');
    print(title);
    print(content);
    return community_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    print(response.body);
    print('게시글 작성에 실패햇습니다');
    throw Exception('writing fail');
  }
}


Future<community_writing_api> community_writing_wholeget() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/communities'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('게시글 불러오기에 성공햇습니다');
    print(json.decode(response.body));
    
    return community_writing_api.fromJson(json.decode(response.body));
  } else {
    print('게시글 불러오기에 실패햇습니다');
    throw Exception('writing fail');
  }
}

Future<community_writing_api> community_writing_get(int communityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.get(
    Uri.http('3.38.97.0:3000', '/communities/$communityId'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('게시글 불러오기에 성공햇습니다');
    print(json.decode(response.body));
    return community_writing_api.fromJson(json.decode(response.body));
  } else {
    print('게시글 불러오기에 실패햇습니다');
    throw Exception('writing fail');
  }
}

Future<community_writing_api> community_writing_delete(String communityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.delete(
      Uri.http('3.38.97.0:3000', '/communities/$communityId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
  );

  if (response.statusCode == 200) {
    print('게시글 삭제에 성공햇습니다');
    return community_writing_api.fromJson(jsonDecode(response.body));
  } else {
    print('게시글 삭제에 실패햇습니다');
    throw Exception('Failed to delete writing.');
  }
}

