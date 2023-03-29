import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/community_page/community_page.dart';
import 'package:jmsmart_project/modules/http_api/image_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../http_api/community_api.dart';

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  XFile? _pickedFile;
  File? file;

  int _userid = 0;
  String _usernickname = "";

  List<dynamic> writinginfo = [];
  final maxLines = 10;
  int writingvalidate = 1;

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
    final _imageSize = MediaQuery.of(context).size.width / 4;
    Size size = MediaQuery.of(context).size;

    _getCameraImage() async {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          file = File(_pickedFile!.path);
        });
      } else {
        if (kDebugMode) {
          print('이미지 선택안함');
        }
      }
    }

    _getPhotoLibraryImage() async {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
        });
      } else {
        if (kDebugMode) {
          print('이미지 선택안함');
        }
      }
    }

    _showBottomSheet() {
      return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _getCameraImage(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('사진찍기', style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => _getPhotoLibraryImage(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('라이브러리에서 불러오기', style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: size.height * 0.07
                      ),
                      Text(
                        "게시글 작성",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                          height: size.height * 0.03
                      ),
                      Text(
                        "   제목",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                          height: size.height * 0.01
                      ),
                      TextFormField(
                        controller: _TitleController,
                        style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        decoration: InputDecoration(
                          hintText: "제목을 입력해주세요(2~20자)",
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
                      SizedBox(
                          height: size.height * 0.01
                      ),
                      Text(
                        "   내용",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                          height: size.height * 0.01
                      ),
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
                      SizedBox(
                          height: size.height * 0.012
                      ),
                      Row(
                        children: [
                          Text(
                            "   첨부파일",
                            style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: size.height * 0.01
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * 0.03
                          ),
                          if (_pickedFile == null)
                            Container(
                              width: 100,
                              height: 100,
                              constraints: BoxConstraints(
                                minHeight: _imageSize,
                                minWidth: _imageSize,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet();
                                },
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/profile/animal3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: Container(
                                width: _imageSize,
                                height: _imageSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      width: 2, color: PRIMARY_COLOR),
                                  image: DecorationImage(
                                      image: FileImage(
                                          File(_pickedFile!.path)),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                          height: size.height * 0.05
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 180,
                            height: 60,
                            child: TextButton(
                              onPressed: () {
                                DateTime dt = DateTime.now();
                                writinginfo.clear();
                                writinginfo.add(_TitleController.text);
                                writinginfo.add(_ContentController.text);
                                // File file = File(_pickedFile!.path);
                                // print(file);
                                _asyncFileUpload(String title, String content, File image) async{
                                  //create multipart request for POST or PATCH method
                                  File file = File(_pickedFile!.path);
                                  var request = http.MultipartRequest("POST", Uri.parse("3.38.97.0:3000/communities"));
                                  //add text fields
                                  request.fields["text_field"] = title;
                                  request.fields["text_field"] = content;
                                  //create multipart using filepath, string or bytes
                                  var image = await http.MultipartFile.fromPath("file_field", file.path);
                                  print(image);
                                  //add multipart to request
                                  request.files.add(image);
                                  var response = await request.send().then((response) {
                                    if(response.statusCode == 200) print("성공");
                                    else print("실패");
                                  });

                                  //Get the response from the server
                                  var responseData = await response.stream.toBytes();
                                  var responseString = String.fromCharCodes(responseData);
                                  print(responseString);
                                }
                                // String contents = await file.readAsString();
                                // print(contents);
                                // writinginfo.add(contents);
                                // writinginfo.add('${dt.year}/${dt.month}/${dt.day}');
                                setState(() {
                                  // uservalidate = nicknamevalidate + namevalidate + idvalidate + codevalidate +
                                  //     pwvalidate + addressvalidate + phone1validate + phone2validate + birthdayvalidate;
                                  writingvalidate = titlevalidate + contentvalidate;
                                  if (writingvalidate == 0) {
                                    // _asyncFileUpload(_TitleController.text, _ContentController.text, file!);
                                    // print(contents);
                                    // 포스트
                                    // user_signup_post(personinfo[0], personinfo[1], personinfo[2], personinfo[3],
                                    //     personinfo[4], personinfo[5] + personinfo[6], personinfo[7], personinfo[8]);
                                    community_writing_post(writinginfo[0], writinginfo[1], 'KakaoTalk_Photo_2023-02-27-20-21-01.jpeg');
                                    //pet_signup_post(petinfolist[0], petinfolist[1], petinfolist[2], petinfolist[3], petinfolist[4], petinfolist[5]);
                                    Navigator.pop(context);
                                  } else {
                                    print(writingvalidate);
                                  }
                                });
                                print(writinginfo);
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
                            width: size.width * 0.025,
                          ),
                          Container(
                            width: 110,
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
                    ]
                )
            )
        )
    );
  }
}
