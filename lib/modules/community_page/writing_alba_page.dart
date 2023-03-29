import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color/colors.dart';
import '../http_api/alba_api.dart';

class WritingAlbaPage extends StatefulWidget {
  @override
  _WritingAlbaPageState createState() => _WritingAlbaPageState();
}

class _WritingAlbaPageState extends State<WritingAlbaPage> {
  int _userid = 0;
  String _usernickname = "";

  List<dynamic> writingalbainfo = [];
  final maxLines = 10;
  int writingalbavalidate = 1;

  final _TitleController = TextEditingController();
  final _ContentController = TextEditingController();
  final _TitleValidate = TextEditingController();
  final _ContentValidate = TextEditingController();

  int titlevalidate = 1;
  int contentvalidate = 1;

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
  void dispose() {
    _TitleController.dispose();
    _ContentController.dispose();
    _TitleValidate.dispose();
    _ContentValidate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.08),
                      Text(
                        "알바해주개 글 작성",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Text(
                        "   제목",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: _TitleController,
                        style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        decoration: InputDecoration(
                          hintText: "제목을 입력해주세요(2~20자)",
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          hintStyle: TextStyle(
                              fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: PRIMARY_COLOR, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: SECOND_COLOR, width: 1.2),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (_TitleController.text.isEmpty) {
                              titlevalidate = 1;
                              _TitleValidate.text = '      제목을 입력해 주세요';
                            } else if (_TitleController.text.length <= 1) {
                              titlevalidate = 2;
                              _TitleValidate.text = '      2개이상 입력';
                            } else {
                              _TitleValidate.text = '';
                              titlevalidate = 0;
                            }
                          });
                        },
                      ),
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _TitleValidate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                      Text(
                        "   내용",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: size.height * 0.01),
                      SizedBox(
                        height: maxLines * 30,
                        child: TextFormField(
                          controller: _ContentController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: maxLines * 3,
                          style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "내용을 입력해주세요(최대 200자, 산책 날짜/시간/장소, 펫에 대한 주의사항 포함)",
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            hintStyle: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: PRIMARY_COLOR, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: SECOND_COLOR, width: 1.2),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (_ContentController.text.isEmpty) {
                                contentvalidate = 1;
                                _ContentValidate.text = '      내용을 입력해주세요';
                              } else {
                                _ContentValidate.text = '';
                                contentvalidate = 0;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _ContentValidate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                      Text(
                        "*주의사항: 내용에 산책 날짜/시간/장소, 펫에 대한 주의사항을 포함하지 않아 생기는 불이익은 책임지지 않습니다.",
                        style:
                            TextStyle(fontFamily: 'GmarketSans', fontSize: 12),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 160,
                            height: 60,
                            child: TextButton(
                              onPressed: () {
                                DateTime dt = DateTime.now();
                                print(_usernickname);
                                writingalbainfo.clear();
                                writingalbainfo.add(_TitleController.text);
                                writingalbainfo.add(_ContentController.text);
                                // writinginfo.add('${dt.year}/${dt.month}/${dt.day}');
                                setState(() {
                                  // uservalidate = nicknamevalidate + namevalidate + idvalidate + codevalidate +
                                  //     pwvalidate + addressvalidate + phone1validate + phone2validate + birthdayvalidate;
                                  writingalbavalidate = titlevalidate + contentvalidate;
                                  if (writingalbavalidate == 0) {
                                    // 포스트
                                    // user_signup_post(personinfo[0], personinfo[1], personinfo[2], personinfo[3],
                                    //     personinfo[4], personinfo[5] + personinfo[6], personinfo[7], personinfo[8]);
                                    alba_writing_post(writingalbainfo[0], writingalbainfo[1]);
                                    //pet_signup_post(petinfolist[0], petinfolist[1], petinfolist[2], petinfolist[3], petinfolist[4], petinfolist[5]);
                                    Navigator.pop(context);
                                  } else {
                                    print(writingalbavalidate);
                                  }
                                });
                                print(writingalbainfo);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ))),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                      maxWidth: double.infinity,
                                      minHeight: 100),
                                  child: Text(
                                    "알바해주개",
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Container(
                            width: 100,
                            height: 60,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                            maxWidth: double.infinity,
                                            minHeight: 100),
                                        child: Text(
                                          "취소",
                                          style: TextStyle(
                                              fontFamily: 'GmarketSans',
                                              fontSize: 16,
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
                    ]))));
  }
}
