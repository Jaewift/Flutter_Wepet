class User{
  int communityId;
  int userId;
  String title;
  String content;
  int likeCount;
  String createdAt;

  User(
    this.communityId,
    this.userId,
    this.title,
    this.content,
    this.likeCount,
    this.createdAt
  );

  User.fromJson(Map json)
      : communityId = json['communityId'],
        userId = json['userId'],
        title = json['title'],
        content = json['content'],
        likeCount = json['likeCount'],
        createdAt = json['createdAt'];

  Map toJson() {
    return {'communityId': communityId, 'userId': userId, 'title': title, 'content': content, 'likeCount': likeCount, 'createdAt': createdAt};
  }
}