import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/community_page/doalba_page.dart';
import 'package:jmsmart_project/modules/community_page/alba_page.dart';
import 'package:jmsmart_project/modules/community_page/writing_page.dart';
import 'package:jmsmart_project/modules/community_page/onboard_page.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:jmsmart_project/modules/login_page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition/transition.dart';
import '../http_api/community_api.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Data{
  final int? communityId;
  final int? userId;
  final String? title;
  final String? content;
  final int? likeCount;
  final String? createdAt;

  Data(this.communityId, this.userId, this.title, this.content, this.likeCount, this.createdAt);

  factory Data.fromJson(dynamic json) {
    DateTime createdDate = DateTime.parse(json['createdAt']);
    String createdDateString = DateFormat("yyyy/MM/dd").format(createdDate);
    return Data(json['communityId'] as int, json['userId'] as int, json['title'] as String,
        json['content'] as String, json['likeCount'] as int, createdDateString as String);
  }

  @override
  String toString() {
    return '{${this.communityId}, ${this.userId}, ${this.title}, ${this.content}, ${this.likeCount}, ${this.createdAt}}';
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPage createState() => _CommunityPage();
}

class _CommunityPage extends State<CommunityPage> {
  int _userid = 0;
  String _usernickname = "";
  var _text = "Http Example";
  List<Data> _datas = [];

  void _fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('accessToken') ?? "");
    final response = await http.get(
      Uri.http('3.38.97.0:3000', '/communities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var _text = utf8.decode(response.bodyBytes);
    print(_text);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Data> parsedResponse =
      dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();
    setState(() {
      _datas.clear();
      _datas.addAll(parsedResponse);
    });
    print(parsedResponse);
    print(_datas);
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
    _fetchPosts();
    _loadUser();
  }

  // List<String> imageList = [
  //   "assets/images/profile/animal2.png",
  //   "assets/images/profile/animal.png",
  //   "assets/images/profile/animal3.png",
  // ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 140,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        Transition(
                                            child: PleaseAlbaPage(),
                                            transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity,
                                          minHeight: 100),
                                      child: Text(
                                        "알바해주개",
                                        style: TextStyle(
                                            fontFamily: 'GmarketSans',
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          width: 140,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: SECOND_COLOR,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        Transition(
                                            child: DoAlbaPage(),
                                            transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity,
                                          minHeight: 100),
                                      child: Text(
                                        "알바할개요",
                                        style: TextStyle(
                                            fontFamily: 'GmarketSans',
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "자유게시판",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: size.width * 0.15,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WritingPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "게시글 작성",
                            style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _fetchPosts();
                        this._datas = [...this._datas];
                      });
                    },
                    child: Container(
                      width: 380,
                      height: size.height * 0.68,
                      child: ListView.builder(
                        reverse: false,
                          // itemCount: imageList.length,
                          itemCount: this._datas.length,
                          itemBuilder: (context, index) {
                            final data = this._datas[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => onBoardPage(data: data.communityId.toString())
                                    )
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: PRIMARY_COLOR, width: 1.5
                                  )
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 50,
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
                                                'assets/images/profile/animal3.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.title.toString(),
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: Text(data.content.toString(),
                                                style: TextStyle(
                                                    fontFamily: 'GmarketSans',
                                                    fontSize: 11,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.03,
                                    ),
                                    Text(data.createdAt.toString(),
                                        style: TextStyle(
                                            fontFamily: 'GmarketSans', fontSize: 10, color: Colors.black))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ))),
    );
  }
}
