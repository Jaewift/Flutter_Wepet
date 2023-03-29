import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';

import '../http_api/community_api.dart';

class DoAlbaModifyPage extends StatefulWidget {
  @override
  _DoAlbaModifyPageState createState() => _DoAlbaModifyPageState();
}

class _DoAlbaModifyPageState extends State<DoAlbaModifyPage> {

  int _userid = 0;
  String _usernickname = "";

  final maxLines = 10;
  int writingvalidate = 1;

  final _TitleController = TextEditingController();
  final _ContentController = TextEditingController();
  final _TitleValidate = TextEditingController();
  final _ContentValidate = TextEditingController();

  int titlevalidate = 1;
  int contentvalidate = 1;

  @override
  void dispose() {
    _TitleController.dispose();
    _ContentController.dispose();
    _TitleValidate.dispose();
    _ContentValidate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.07),
                Text(
                  "알바게시글 수정",
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 36, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "   제목",
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: size.height * 0.01),
                TextFormField(
                  controller: _TitleController,
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    hintText: "제목을 입력해주세요(2~20자)",
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
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
                SizedBox(height: size.height * 0.01),
                Text(
                  "   내용",
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: size.height * 0.01),
                SizedBox(
                  height: maxLines * 20,
                  child: TextFormField(
                    controller: _ContentController,
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: maxLines * 2,
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "내용을 입력해주세요(최대 200자)",
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      hintStyle:
                      TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
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
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 180,
                      height: 60,
                      child: TextButton(
                        onPressed: () {

                        },
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                maxWidth: double.infinity, minHeight: 100),
                            child: Text(
                              "글 작성하기",
                              style: TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontSize: 14,
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
                      width: 120,
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                      maxWidth: double.infinity, minHeight: 100),
                                  child: Text(
                                    "취소",
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
              ],
            ),
          ),
        ));
  }
}
