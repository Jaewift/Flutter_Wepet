import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommunityLike {
  final int communityLikeId;
  final int userId;
  final int communityId;

  const CommunityLike({required this.communityLikeId, required this.userId, required this.communityId});

  factory CommunityLike.fromJson(Map<String, dynamic> json) {
    return CommunityLike(
      communityLikeId: json['communityLikeId'],
      userId: json['userId'],
      communityId: json['communityId']
    );
  }
}

class CommentLike {
  final int communityLikeId;
  final int userId;
  final int commentId;

  const CommentLike({required this.communityLikeId, required this.userId, required this.commentId});

  factory CommentLike.fromJson(Map<String, dynamic> json) {
    return CommentLike(
        communityLikeId: json['communityLikeId'],
        userId: json['userId'],
        commentId: json['commentId']
    );
  }
}



Future<CommunityLike> updateLike(String communityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('3.38.97.0:3000', '/communityLikes/communities/$communityId/likes'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'communityId': communityId,
    }),
  );

  if (response.statusCode == 200) {
    print('좋아요 수정에 성공햇습니다');
    // then parse the JSON.
    return CommunityLike.fromJson(jsonDecode(response.body));
  } else {
    print('좋아요 수정에 실패햇습니다');
    print(response.statusCode);
    print(response.body);
    throw Exception('Failed to update like.');
  }
}

Future<CommentLike> updatecommentLike(String commendId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString('accessToken') ?? "");
  final response = await http.put(
    Uri.http('3.38.97.0:3000', '/commentLikes/comments/$commendId/likes'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'commendId': commendId,
    }),
  );

  if (response.statusCode == 200) {
    print('좋아요 수정에 성공햇습니다');
    // then parse the JSON.
    return CommentLike.fromJson(jsonDecode(response.body));
  } else {
    print('좋아요 수정에 실패햇습니다');
    print(response.statusCode);
    print(response.body);
    throw Exception('Failed to update like.');
  }
}