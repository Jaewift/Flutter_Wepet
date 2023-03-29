import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/http_api/pet_api.dart';
import 'package:jmsmart_project/modules/login_page/pet_signup.dart';
import 'package:jmsmart_project/modules/http_api/user_api.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPage createState() => _ProfileSettingsPage();
}

class _ProfileSettingsPage extends State<ProfileSettingsPage> {
  XFile? _pickedFile;

  List<dynamic> personinfo = [];
  int uservalidate = 1;
  final _NickNameController = TextEditingController();
  final _NameController = TextEditingController();
  final _IDController = TextEditingController();
  final _PWController = TextEditingController();
  final _CodeController = TextEditingController();
  final _AddressController = TextEditingController();
  final _PhoneController1 = TextEditingController();
  final _PhoneController2 = TextEditingController();
  final _BirthdayController = TextEditingController();
  final _NickNameValidate = TextEditingController();
  final _NameValidate = TextEditingController();
  final _IDValidate = TextEditingController();
  final _CodeValidate = TextEditingController();
  final _PWValidate = TextEditingController();
  final _AddressValidate = TextEditingController();
  final _Phone1Validate = TextEditingController();
  final _Phone2Validate = TextEditingController();
  final _BirthdayValidate = TextEditingController();

  // List<dynamic> petinfolist = [];
  int nicknamevalidate = 1;
  int namevalidate = 1;
  int idvalidate = 1;
  int codevalidate = 1;
  int pwvalidate = 1;
  int addressvalidate = 1;
  int phone1validate = 1;
  int phone2validate = 1;
  int birthdayvalidate = 1;

  @override
  void dispose() {
    _NickNameController.dispose();
    _NameController.dispose();
    _IDController.dispose();
    _PWController.dispose();
    _CodeController.dispose();
    _AddressController.dispose();
    _PhoneController1.dispose();
    _PhoneController2.dispose();
    _BirthdayController.dispose();
    _NickNameValidate.dispose();
    _NameValidate.dispose();
    _IDValidate.dispose();
    _PWValidate.dispose();
    _CodeValidate.dispose();
    _AddressValidate.dispose();
    _Phone1Validate.dispose();
    _Phone2Validate.dispose();
    _BirthdayValidate.dispose();
    super.dispose();
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
                child: const Text(
                  '사진찍기',
                  style: TextStyle(
                      fontFamily: 'GmarketSans',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
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
                child: const Text(
                  '라이브러리에서 불러오기',
                  style: TextStyle(
                      fontFamily: 'GmarketSans',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
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
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: size.height * 0.06),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "프로필 변경",
                        style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 32,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  SizedBox(width: size.width * 0.08),
                  Column(
                    children: [
                      if (_pickedFile == null)
                        Container(
                          constraints: BoxConstraints(
                            minHeight: _imageSize,
                            minWidth: _imageSize,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showBottomSheet();
                            },
                            child: Center(
                              child: Icon(
                                Icons.account_circle,
                                color: PRIMARY_COLOR,
                                size: _imageSize,
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
                              shape: BoxShape.circle,
                              border:
                              Border.all(width: 2, color: PRIMARY_COLOR),
                              image: DecorationImage(
                                  image: FileImage(File(_pickedFile!.path)),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 220,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      controller: _NickNameController,
                      inputFormatters: [LengthLimitingTextInputFormatter(8)],
                      decoration: InputDecoration(
                        hintText: "닉네임을 입력해주세요(2~8자)",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        hintStyle: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 14,
                            height: 0.5,
                            color: Colors.grey.shade800),
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
                          if (_NickNameController.text.isEmpty) {
                            nicknamevalidate = 1;
                            _NickNameValidate.text = '      닉네임을 입력해주세요';
                          } else if (_NickNameController.text.length <= 1) {
                            nicknamevalidate = 2;
                            _NickNameValidate.text = '      2개이상 입력';
                          } else {
                            _NickNameValidate.text = '';
                            nicknamevalidate = 0;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        nickname_reduplication_post(_NickNameController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "중복 확인",
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
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 15,
                    child: TextField(
                      controller: _CodeValidate,
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
                ],
              ),
              SizedBox(height: size.height * 0.005),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      controller: _PWController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9|a-z|A-Z|@|!|#|$|%|^|&|*|(|)]')),
                        LengthLimitingTextInputFormatter(12)
                      ],
                      decoration: InputDecoration(
                        hintText: "비밀번호를 입력해주세요(8~12자리)",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        hintStyle: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 14,
                            color: Colors.grey.shade800),
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
                          if (_PWController.text.isEmpty) {
                            pwvalidate = 1;
                            _PWValidate.text = '      비밀번호를 입력해주세요';
                          } else if (_PWController.text.length <= 7) {
                            pwvalidate = 2;
                            _PWValidate.text = '      8개이상 입력';
                          } else {
                            _PWValidate.text = '';
                            pwvalidate = 0;
                          }
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _PWValidate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: size.height * 0.005),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ]')),
                      ],
                      controller: _AddressController,
                      decoration: InputDecoration(
                        hintText: "거주하는 동네를 입력해주세요(Ex.홍대, 잠실)",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        hintStyle: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 14,
                            color: Colors.grey.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: PRIMARY_COLOR, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: SECOND_COLOR, width: 1.2),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (_AddressController.text.isEmpty) {
                            addressvalidate = 1;
                            _AddressValidate.text = '      거주하고 있는 동네를 입력해주세요';
                          } else {
                            _AddressValidate.text = '';
                            addressvalidate = 0;
                          }
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _AddressValidate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "  전화번호를 입력해주세요",
                    style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: size.height * 0.001),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                        width: 55,
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'GmarketSans', fontSize: 14),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "010",
                            contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade800),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 1.2),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      Text(
                        "   -   ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 30,
                        width: 60,
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'GmarketSans', fontSize: 14),
                          controller: _PhoneController1,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          decoration: InputDecoration(
                            hintText: "",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade800),
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
                              if (_PhoneController1.text.isEmpty) {
                                phone1validate = 1;
                                _Phone1Validate.text = '      전화번호를 입력해주세요';
                              } else if (_PhoneController1.text.length <= 3) {
                                phone1validate = 2;
                                _Phone1Validate.text = '      4개이상 입력';
                              } else {
                                _Phone1Validate.text = '';
                                phone1validate = 0;
                              }
                            });
                          },
                        ),
                      ),
                      Text(
                        "   -   ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 30,
                        width: 60,
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'GmarketSans', fontSize: 14),
                          controller: _PhoneController2,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          decoration: InputDecoration(
                            hintText: "",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade800),
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
                              if (_PhoneController2.text.isEmpty) {
                                phone2validate = 1;
                                _Phone1Validate.text = '      전화번호를 입력해주세요';
                              } else if (_PhoneController2.text.length <= 3) {
                                phone2validate = 2;
                                _Phone1Validate.text = '      4개이상 입력';
                              } else {
                                _Phone1Validate.text = '';
                                phone2validate = 0;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: size.width * 0.18),
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _Phone1Validate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.005),
                  SizedBox(
                    height: 40,
                    width: 280,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      controller: _BirthdayController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9|-]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      decoration: InputDecoration(
                        hintText: "생년월일을 입력해주세요(0000-00-00)",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        hintStyle: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 14,
                            color: Colors.grey.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: PRIMARY_COLOR, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: SECOND_COLOR, width: 1.2),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (_BirthdayController.text.isEmpty) {
                            birthdayvalidate = 1;
                            _BirthdayValidate.text = '      생년월일를 입력해주세요';
                          } else if (_BirthdayController.text.length <= 7) {
                            birthdayvalidate = 2;
                            _BirthdayValidate.text = '      8자리로 입력해주세요';
                          } else {
                            _BirthdayValidate.text = '';
                            birthdayvalidate = 0;
                          }
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: TextField(
                          controller: _BirthdayValidate,
                          enabled: false,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Center(
                    child: Container(
                      height: 60,
                      width: 260,
                      child: TextButton(
                        onPressed: () {
                          personinfo.clear();
                          personinfo.add(_NickNameController.text);
                          //personinfo.add(_NameController.text);
                          personinfo.add(_PWController.text);
                          //personinfo.add(_AddressController.text);
                          personinfo.add(_PhoneController1.text);
                          personinfo.add(_PhoneController2.text);
                          // if (birthdayvalidate == 0) {
                          //   personinfo.add(_BirthdayController.text);
                          // }
                          setState(()  {
                            // print(petinfolist);
                            print(personinfo);
                            // uservalidate = nicknamevalidate + namevalidate + idvalidate + codevalidate +
                            //     pwvalidate + addressvalidate + phone1validate + phone2validate + birthdayvalidate;
                            uservalidate = nicknamevalidate +
                                pwvalidate +
                                phone1validate +
                                phone2validate;
                            // birthdayvalidate;
                            if (uservalidate == 0) {
                              // 포스트
                              // user_signup_post(personinfo[0], personinfo[1], personinfo[2], personinfo[3],
                              //     personinfo[4], personinfo[5] + personinfo[6], personinfo[7], personinfo[8]);
                              //user_signup_post(personinfo[2], personinfo[0], personinfo[1], '010' + '-' + (personinfo[4].toString()) + '-' + (personinfo[5].toString()));
                              print(personinfo);
                              // await pet_signup_post(petinfolist[0], petinfolist[1], petinfolist[2], petinfolist[3], petinfolist[4], petinfolist[5]);
                              //Navigator.pop(context);
                            } else {
                              print(uservalidate);
                            }
                          });
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                maxWidth: double.infinity, minHeight: 100),
                            child: Text(
                              "프로필 변경하기",
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
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "돌아가기",
                        style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
