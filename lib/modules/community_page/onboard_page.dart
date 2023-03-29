import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:jmsmart_project/modules/community_page/onboard_modify.dart';
import 'package:jmsmart_project/modules/http_api/community_like.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../http_api/community_api.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../color/colors.dart';
import '../http_api/community_api.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class CommentData{
  int? commentId;
  int? userId;
  int? communityId;
  int? likeCount;
  String? comment;
  String? createdAt;

  CommentData(this.commentId, this.userId, this.communityId, this.likeCount, this.comment, this.createdAt);

  factory CommentData.fromJson(dynamic json){
    DateTime createdDate = DateTime.parse(json['createdAt']);
    String createdDateString = DateFormat("yyyy/MM/dd").format(createdDate);
    return CommentData(json['commentId'] as int, json['userId'] as int, json['communityId'] as int, json['likeCount'] as int, json['comment'] as String, createdDateString as String);
  }
  
  @override
  String toString(){
    return '{${this.commentId}, ${this.userId}, ${this.communityId}, ${this.likeCount}, ${this.comment}, ${this.createdAt}}';
  }
}

class Data{
  final int? communityId;
  final int? userId;
  final String? image;
  final String? title;
  final String? content;
  final int? likeCount;
  final String? createdAt;

  Data(this.communityId, this.userId, this.image, this.title, this.content, this.likeCount, this.createdAt);

  factory Data.fromJson(dynamic json) {
    DateTime createdDate = DateTime.parse(json['createdAt']);
    String createdDateString = DateFormat("yyyy/MM/dd").format(createdDate);
    return Data(json['communityId'] as int, json['userId'] as int, json['image'] as String, json['title'] as String,
        json['content'] as String, json['likeCount'] as int, createdDateString as String);
  }

  @override
  String toString() {
    return '{${this.communityId}, ${this.userId}, ${this.image}, ${this.title}, ${this.content}, ${this.likeCount}, ${this.createdAt}}';
  }
}

class onBoardPage extends StatefulWidget {
  final String data;
  const onBoardPage({Key? key, required this.data}) : super(key: key);

  @override
  _onBoardPageState createState() => _onBoardPageState();
}

class _onBoardPageState extends State<onBoardPage> {
  int _userid = 0;
  String _usernickname = "";
  bool _visible = false;
  var _text = "Http Example";
  List<CommentData> _datas = [];
  var _text2 = "Http Example";
  List<Data> _datas2 = [];

  Future<community_writing_api>? writingListInfo;

  void _fetchPosts2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('accessToken') ?? "");
    final response = await http.get(
      Uri.http('3.38.97.0:3000', '/communities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var _text2 = utf8.decode(response.bodyBytes);
    print(_text2);
    var dataObjsJson = jsonDecode(_text2)['data'] as List;
    final List<Data> parsedResponse2 =
    dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();
    setState(() {
      _datas2.clear();
      _datas2.addAll(parsedResponse2);
    });
    print(parsedResponse2);
    print(_datas2);
  }

  void _fetchPosts(String communityId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('accessToken') ?? "");
    final response = await http.get(
      Uri.http('3.38.97.0:3000', '/comments/$communityId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var _text = utf8.decode(response.bodyBytes);
    print(_text);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<CommentData> parsedResponse = dataObjsJson.map((dataJson)=>CommentData.fromJson(dataJson)).toList();

    setState(() {
      _datas.clear();
      _datas.addAll(parsedResponse);
    });
    print(parsedResponse);
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userid = (prefs.getInt('userId') ?? 0);
      _usernickname = (prefs.getString('userNickname') ?? "");
    });
    print(_userid);
    print(_usernickname);
  }

  @override
  void initState() {
    super.initState();
    String data2 = widget.data;
    // writingListInfo = community_writing_get(1);
    _fetchPosts(data2);
    _fetchPosts2();
    // _loadUser();
    // DateTime createdDate = DateTime.now();
    // String createdDateString = DateFormat("yyyy/MM/dd").format(createdDate);
    // print(createdDateString);
    // myFocusNode = FocusNode();
  }

  bool isTextFieldEnabled = true;
  bool _sendvisible = false;
  // late FocusNode myFocusNode;

  List<dynamic> commentinfo = [];
  int commentvalidate = 1;

  final _CommentController = TextEditingController();
  final _CommentValidate = TextEditingController();

  @override
  void dispose() {
    _CommentController.dispose();
    _CommentValidate.dispose();
    // myFocusNode.dispose();
    super.dispose();
  }

  Color _iconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _fetchPosts2();
                });
              },
              child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.06),
                        Row(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        "assets/images/profile/people.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "닉네임",
                                  style: TextStyle(
                                      fontFamily: 'GmarketSans', fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: size.height * 0.005),
                                Text(
                                  "등록일",
                                  style: TextStyle(
                                      fontFamily: 'GmarketSans', fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              child: Visibility(
                                visible: true,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => onBoardModifyPage(data: '2')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  child: const Text(
                                    "게시물 수정",
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        fontSize: 9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              child: Visibility(
                                visible: true,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String data2 = widget.data;
                                    var data3 = int.parse(data2);
                                    community_writing_delete(_datas2[data3 - 1].communityId.toString());
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  child: const Text(
                                    "게시물 삭제",
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        fontSize: 9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          width: 500,
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: ListView.builder(
                              // itemCount: imageList.length,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                String data2 = widget.data;
                                var data3 = int.parse(data2);
                                final data = this._datas2[data3 - 2];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => onBoardPage(data: data.communityId.toString())
                                    //     )
                                    // );
                                  },
                                      child: Text(data.title.toString(),
                                          style: TextStyle(
                                                fontFamily: 'GmarketSans', fontSize: 20, color: Colors.black))
                                );
                              }),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          width: 375,
                          height: 280,
                          padding: EdgeInsets.fromLTRB(10, 4, 8, 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: PRIMARY_COLOR, width: 1.2
                              )
                          ),
                          child: ListView.builder(
                            // itemCount: imageList.length,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                String data2 = widget.data;
                                var data3 = int.parse(data2);
                                final data = this._datas2[data3 - 2];
                                return GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => onBoardPage(data: data.communityId.toString())
                                      //     )
                                      // );
                                    },
                                  child: Image.network(data.image.toString()),
                                );
                              }),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 270,
                              height: 60,
                              padding: EdgeInsets.fromLTRB(10, 16, 10, 5),
                              child: ListView.builder(
                                // itemCount: imageList.length,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    String data2 = widget.data;
                                    var data3 = int.parse(data2);
                                    final data = this._datas2[data3 - 2];
                                    return GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => onBoardPage(data: data.communityId.toString())
                                          //     )
                                          // );
                                        },
                                        child: Text(data.content.toString(),
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans', fontSize: 14, color: Colors.black))
                                    );
                                  }),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 85,
                              child: Visibility(
                                visible: true,
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(writingListInfo);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  child: const Text(
                                    "뒤로 가기",
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite,
                                  size: 18, color: _iconColor),
                              onPressed: () async {
                                String data2 = widget.data;
                                setState(() {
                                  updateLike(data2);
                                  if (_iconColor == Colors.black) {
                                    _iconColor = Colors.red;
                                  } else {
                                    _iconColor = Colors.black;
                                  }
                                  _fetchPosts2();
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final _userid = 1;
                                prefs.setInt('userId', _userid);
                              },
                            ),
                            Column(
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Container(
                                    width: 100,
                                    height: 30,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                                    child: ListView.builder(
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          String data2 = widget.data;
                                          var data3 = int.parse(data2);
                                          final data = this._datas2[data3 - 2];
                                          return GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => onBoardPage(data: data.communityId.toString())
                                                //     )
                                                // );
                                              },
                                              child: Text(
                                                  "좋아요 " +
                                                      data.likeCount.toString() +
                                                      "개",
                                                  style: TextStyle(
                                                      fontFamily: 'GmarketSans',
                                                      fontSize: 16,
                                                      color: Colors.black)));
                                        })),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 260,
                              height: 40,
                              child: TextFormField(
                                controller: _CommentController,
                                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "댓글을 입력해 주세요(2~20자)",
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,color: Colors.grey.shade800),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: SECOND_COLOR, width: 1.5),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (_CommentController.text.isEmpty) {
                                      commentvalidate = 1;
                                      _CommentValidate.text = '      댓글을 입력해 주세요';
                                    } else if (_CommentController.text.length <= 1) {
                                      commentvalidate = 2;
                                      _CommentValidate.text = '      2개이상 입력';
                                    } else {
                                      _CommentValidate.text = '';
                                      commentvalidate = 0;
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: 60,
                              child: IconButton(
                                onPressed: () {
                                  DateTime dt = DateTime.now();
                                  commentinfo.clear();
                                  commentinfo.add(_CommentController.text);
                                  // commentinfo.add('${dt.year}/${dt.month}/${dt.day}');
                                  setState(() {
                                    if (commentvalidate == 0) {
                                      String data2 = widget.data;
                                      // 포스트
                                      // user_signup_post(personinfo[0], personinfo[1], personinfo[2], personinfo[3],
                                      //     personinfo[4], personinfo[5] + personinfo[6], personinfo[7], personinfo[8]);
                                      community_comment_post(commentinfo[0], data2);
                                      //pet_signup_post(petinfolist[0], petinfolist[1], petinfolist[2], petinfolist[3], petinfolist[4], petinfolist[5]);
                                      //Navigator.pop(context);
                                      _CommentController.text = "";
                                    } else {
                                      print(commentvalidate);
                                    }
                                  });
                                  print(commentinfo);
                                },
                                icon: Icon(Icons.send),
                                color: Colors.black,
                                iconSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 200,
                          height: 20,
                          child: TextField(
                            controller: _CommentValidate,
                            enabled: false,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 6, color: Colors.red),
                            ),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              String data2 = widget.data;
                              _fetchPosts(data2);
                              this._datas = [...this._datas];
                            });
                          },
                          child: Container(
                            width: 380,
                            height: size.height * 0.5,
                            child: ListView.builder(
                                itemCount: this._datas.length,
                                itemBuilder: (context, index) {
                                  final data = this._datas[index];
                                  return GestureDetector(
                                    child: SizedBox(
                                      height: size.height * 0.095,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: PRIMARY_COLOR, width: 1.5
                                            )
                                        ),
                                        elevation: 3,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              height: 60,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.02,
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                      child: Image.asset(
                                                        "assets/images/profile/animal.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: size.height * 0.003,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data.comment.toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'GmarketSans',
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.03,
                                                      ),
                                                      Text(data.createdAt.toString(),
                                                          style: TextStyle(
                                                              fontFamily: 'GmarketSans',
                                                              fontSize: 10,
                                                              color: Colors.black)),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: size.width,
                                                      height: 35,
                                                      child: TextFormField(
                                                        readOnly: isTextFieldEnabled,
                                                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                                        style: TextStyle(fontFamily: 'GmarketSans', fontSize: 10, color: Colors.black),
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            focusColor: Colors.transparent,
                                                            hintText: data.comment.toString(),
                                                            hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 10, color: Colors.black)
                                                        ),
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 27,
                                                  width: 27,
                                                  child: Visibility(
                                                    visible: true,
                                                    child: IconButton(
                                                      icon: Icon(Icons.edit),
                                                      color: Colors.black,  // 아이콘 색상
                                                      iconSize: 14.0, // 기본값 24.0
                                                      onPressed: () {
                                                        setState(() {
                                                          isTextFieldEnabled = false;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 27,
                                                  width: 27,
                                                  child: Visibility(
                                                    visible: true,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      color: Colors.black,  // 아이콘 색상
                                                      iconSize: 14, // 기본값 24.0
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title: Text('삭제', style: TextStyle(fontFamily: 'GmarketSans',),),
                                                            content: Text(
                                                                '댓글을 삭제할까요?', style: TextStyle(fontFamily: 'GmarketSans',)
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                  '취소',
                                                                  style: TextStyle(
                                                                      fontFamily: 'GmarketSans', color: Colors.black),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(ctx).pop(false);
                                                                },
                                                              ),
                                                              TextButton(
                                                                  child: Text(
                                                                    '확인',
                                                                    style: TextStyle(
                                                                        fontFamily: 'GmarketSans', color: Colors.black),
                                                                  ),
                                                                  onPressed: () {
                                                                    community_comment_delete(data.commentId.toString());
                                                                  }
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: IconButton(
                                                icon: Icon(Icons.favorite,
                                                    size: 16, color: Colors.black),
                                                onPressed: () {
                                                  updatecommentLike(data.commentId.toString());
                                                  setState(() {
                                                    // if (likeList[index] == Colors.black) {
                                                    //   likeList[index] = Colors.red;
                                                    // } else {
                                                    //   likeList[index] = Colors.red;
                                                    // }
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        SizedBox(height: size.height * 0.05),
                      ])),
            )));
  }
}
//
//   Widget buildColumn(snapshot) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         body: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Container(
//                 padding: EdgeInsets.only(left: 20, right: 20),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(height: size.height * 0.05),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 70,
//                             height: 60,
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: size.width * 0.02,
//                                 ),
//                                 SizedBox(
//                                   width: 50,
//                                   height: 50,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(25),
//                                     child: Image.asset(
//                                       "assets/images/profile/people.png",
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   "닉네임",
//                                   style: TextStyle(
//                                       fontFamily: 'GmarketSans', fontSize: 12, fontWeight: FontWeight.w700),
//                                 ),
//                                 SizedBox(height: size.height * 0.005),
//                                 Text(
//                                   "등록일",
//                                   style: TextStyle(
//                                       fontFamily: 'GmarketSans', fontSize: 12, fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           SizedBox(
//                             width: size.width * 0.18,
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             height: 30,
//                             width: 85,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => onBoardModifyPage()));
//                               },
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: PRIMARY_COLOR,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10))),
//                               child: const Text(
//                                 "게시물 수정",
//                                 style: TextStyle(
//                                     fontFamily: 'GmarketSans',
//                                     fontSize: 10,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width * 0.02,
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             height: 30,
//                             width: 85,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: PRIMARY_COLOR,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10))),
//                               child: const Text(
//                                 "게시물 삭제",
//                                 style: TextStyle(
//                                     fontFamily: 'GmarketSans',
//                                     fontSize: 10,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: size.height * 0.02),
//                       Container(
//                         width: 500,
//                         height: 40,
//                         padding: EdgeInsets.fromLTRB(10, 6, 8, 4),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: PRIMARY_COLOR, width: 1.5
//                           )
//                         ),
//                         child: Text(
//                           snapshot.data!.title.toString(),
//                           style: TextStyle(
//                               fontFamily: 'GmarketSans', fontSize: 20, fontWeight: FontWeight.w700),
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.01),
//                       Container(
//                           width: 500,
//                           padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: PRIMARY_COLOR, width: 1.5
//                               )
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Flexible(
//                                   child: RichText(
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 10,
//                                 strutStyle: StrutStyle(fontSize: 14.0),
//                                 text: TextSpan(
//                                     text:
//                                         snapshot.data!.content.toString(),
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         height: 1.4,
//                                         fontSize: 14.0,
//                                       fontFamily: 'GmarketSans', )),
//                               )),
//                             ],
//                           )
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.thumb_up_sharp, size: 18, color: _iconColor),
//                             onPressed: () {
//                               setState(() {
//                                 if(_iconColor == Colors.black) {
//                                   _iconColor = PRIMARY_COLOR;
//                                 } else {
//                                   _iconColor = Colors.black;
//                                 }
//                               });
//                             },
//                           ),
//                           Text(
//                             "1",
//                             style: TextStyle(
//                                 fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 1.0,
//                         width: 500.0,
//                         color: Colors.black,
//                       ),
//                       SizedBox(height: size.height * 0.02),
//                       Container(
//                         width: 380,
//                         height: size.height * 0.5,
//                         child: ListView.builder(
//                             itemCount: NicknameList.length,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 child: SizedBox(
//                                   height: size.height * 0.1,
//                                   child: Card(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide(
//                                             color: PRIMARY_COLOR, width: 1.5
//                                         )
//                                     ),
//                                     elevation: 3,
//                                     child: Row(
//                                       children: [
//                                         SizedBox(
//                                           width: 60,
//                                           height: 60,
//                                           child: Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: size.width * 0.02,
//                                               ),
//                                               SizedBox(
//                                                 width: 40,
//                                                 height: 40,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                   BorderRadius.circular(20),
//                                                   child: Image.asset(
//                                                     imageList[index],
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 180,
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               SizedBox(
//                                                 height: size.height * 0.008,
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     NicknameList[index],
//                                                     style: TextStyle(
//                                                         fontFamily: 'GmarketSans',
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black),
//                                                   ),
//                                                   SizedBox(
//                                                     width: size.width * 0.03,
//                                                   ),
//                                                   Text(dateList[index],
//                                                       style: TextStyle(
//                                                           fontFamily: 'GmarketSans',
//                                                           fontSize: 10,
//                                                           color: Colors.black))
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 width: size.width * 0.6,
//                                                 height: 40,
//                                                     child: TextFormField(
//                                                       readOnly: isTextFieldEnabled,
//                                                       maxLines: 2,
//                                                       style: TextStyle(fontFamily: 'GmarketSans', fontSize: 10, color: Colors.black),
//                                                       decoration: InputDecoration(
//                                                         border: InputBorder.none,
//                                                         focusColor: Colors.transparent,
//                                                         hintText: titleList[index],
//                                                         hintStyle: TextStyle(fontSize: 10, color: Colors.black)
//                                                       ),
//                                                     )
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(width: size.width * 0.03),
//                                         IconButton(
//                                           icon: Icon(Icons.edit),
//                                           color: Colors.black,  // 아이콘 색상
//                                           iconSize: 15.0, // 기본값 24.0
//                                           onPressed: () {
//                                             setState(() {
//                                               isTextFieldEnabled = false;
//                                             });
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.close),
//                                           color: Colors.black,  // 아이콘 색상
//                                           iconSize: 15.0, // 기본값 24.0
//                                           onPressed: () {
//                                             showDialog(
//                                               context: context,
//                                               builder: (ctx) => AlertDialog(
//                                                 title: Text('삭제', style: TextStyle(fontFamily: 'GmarketSans',)),
//                                                 content: Text(
//                                                   '댓글을 삭제할까요?',
//                                                     style: TextStyle(fontFamily: 'GmarketSans',)
//                                                 ),
//                                                 actions: <Widget>[
//                                                   TextButton(
//                                                     child: Text(
//                                                       '취소',
//                                                       style: TextStyle(
//                                                           fontFamily: 'GmarketSans',
//                                                           color: Colors.black),
//                                                     ),
//                                                     onPressed: () {
//                                                       Navigator.of(ctx).pop(false);
//                                                     },
//                                                   ),
//                                                   TextButton(
//                                                     child: Text(
//                                                       '확인',
//                                                       style: TextStyle(
//                                                           fontFamily: 'GmarketSans',
//                                                           color: Colors.black),
//                                                     ),
//                                                     onPressed: () {
//                                                       //댓글 삭제 delete
//                                                     }
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),
//                       SizedBox(height: size.height * 0.03),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 280,
//                             child: TextFormField(
//                               controller: _CommentController,
//                               inputFormatters: [LengthLimitingTextInputFormatter(30)],
//                               style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
//                               decoration: InputDecoration(
//                                 hintText: "댓글을 입력해 주세요(2~30자)",
//                                 contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                                 hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,color: Colors.grey.shade800),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.2),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(color: SECOND_COLOR, width: 1.2),
//                                 ),
//                                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (_CommentController.text.isEmpty) {
//                                     commentvalidate = 1;
//                                     _CommentValidate.text = '      댓글을 입력해 주세요';
//                                   } else if (_CommentController.text.length <= 1) {
//                                     commentvalidate = 2;
//                                     _CommentValidate.text = '      2개이상 입력';
//                                   } else {
//                                     _CommentValidate.text = '';
//                                     commentvalidate = 0;
//                                   }
//                                 });
//                               },
//                             ),
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             height: 45,
//                             width: 60,
//                             child: IconButton(
//                               onPressed: () {
//                                 DateTime dt = DateTime.now();
//                                 commentinfo.clear();
//                                 commentinfo.add(_CommentController.text);
//                                 // commentinfo.add('${dt.year}/${dt.month}/${dt.day}');
//                                 setState(() {
//                                   if (commentvalidate == 0) {
//                                     // 포스트
//                                     // user_signup_post(personinfo[0], personinfo[1], personinfo[2], personinfo[3],
//                                     //     personinfo[4], personinfo[5] + personinfo[6], personinfo[7], personinfo[8]);
//                                     community_comment_post(commentinfo[0]);
//                                     //pet_signup_post(petinfolist[0], petinfolist[1], petinfolist[2], petinfolist[3], petinfolist[4], petinfolist[5]);
//                                     //Navigator.pop(context);
//                                   } else {
//                                     print(commentvalidate);
//                                   }
//                                 });
//                                 print(commentinfo);
//                               },
//                               icon: Icon(Icons.send),
//                               color: Colors.black,
//                               iconSize: 20.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 200,
//                         height: 20,
//                         child: TextField(
//                           controller: _CommentValidate,
//                           enabled: false,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.red,
//                           ),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintStyle: TextStyle(fontSize: 6, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.05),
//                     ]))));
//   }
// }
