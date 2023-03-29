import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:jmsmart_project/modules/community_page/alba_onboard.dart';
import 'package:jmsmart_project/modules/community_page/writing_alba_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../color/colors.dart';

class Data {
  final int? recruitId;
  final int? userId;
  final String? title;
  final String? content;
  final String? createdAt;

  Data(this.recruitId, this.userId, this.title, this.content, this.createdAt);

  factory Data.fromJson(dynamic json) {
    DateTime createdDate = DateTime.parse(json['createdAt']);
    String createdDateString = DateFormat("yyyy/MM/dd").format(createdDate);
    return Data(json['recruitId'] as int, json['userId'] as int, json['title'] as String,
        json['content'] as String, createdDateString as String);
  }

  @override
  String toString() {
    return '{${this.recruitId}, ${this.userId}, ${this.title}, ${this.content}, ${this.createdAt}}';
  }
}

class PleaseAlbaPage extends StatefulWidget {
  @override
  _PleaseAlbaPageState createState() => _PleaseAlbaPageState();
}

class _PleaseAlbaPageState extends State<PleaseAlbaPage> {
  int _userid = 0;
  String _usernickname = "";

  var _text = "Http Example";
  List<Data> _datas = [];

  void _fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('accessToken') ?? "");
    final response = await http.get(
      Uri.http('3.38.97.0:3000', '/recruits'),
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
    _loadUser();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.1),
                      Row(
                        children: [
                          Text(
                            "알바해주개",
                            style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: size.width * 0.06,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: PRIMARY_COLOR,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text(
                                "뒤로가기",
                                style: TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 65,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WritingAlbaPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: PRIMARY_COLOR,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text(
                                "글 작성",
                                style: TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _fetchPosts();
                            this._datas = [...this._datas];
                          });
                        },
                        child: Container(
                          width: 380,
                          height: size.height,
                          child: ListView.builder(
                              itemCount: this._datas.length,
                              itemBuilder: (context, index) {
                                final data = this._datas[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AlbaOnboardPage(data: data.recruitId.toString())
                                        )
                                    );
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (ctx) => AlertDialog(
                                    //     title: Text('삭제' ,style: TextStyle(
                                    //         fontFamily: 'GmarketSans')),
                                    //     content: Text(
                                    //       '게시글을 삭제할까요?', style: TextStyle(
                                    //         fontFamily: 'GmarketSans')
                                    //     ),
                                    //     actions: <Widget>[
                                    //       TextButton(
                                    //         child: Text(
                                    //           '취소',
                                    //           style: TextStyle(
                                    //               fontFamily: 'GmarketSans', color: Colors.black),
                                    //         ),
                                    //         onPressed: () {
                                    //           Navigator.of(ctx).pop(false);
                                    //         },
                                    //       ),
                                    //       TextButton(
                                    //           child: Text(
                                    //             '확인',
                                    //             style: TextStyle(
                                    //                 fontFamily: 'GmarketSans', color: Colors.black),
                                    //           ),
                                    //           onPressed: () {
                                    //           }
                                    //       ),
                                    //     ],
                                    //   ),
                                    // );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                            color: PRIMARY_COLOR, width: 1.5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        SizedBox(
                                          width: size.width * 0.03,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            SizedBox(
                                              width: 230,
                                              height: 20,
                                              child: Text(
                                                data.title.toString(),
                                                style: TextStyle(
                                                    fontFamily: 'GmarketSans',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              height: 20,
                                              child: Text(
                                                data.createdAt.toString(),
                                                style: TextStyle(
                                                    fontFamily: 'GmarketSans',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    ]
                )
            )
        )
    );
  }
}
