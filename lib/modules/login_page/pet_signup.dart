import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jmsmart_project/modules/http_api/pet_api.dart';
import 'package:jmsmart_project/modules/login_page/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color/colors.dart';

class PetSignupPage extends StatefulWidget {
  @override
  _PetSignupPageState createState() => _PetSignupPageState();
}

class _PetSignupPageState extends State<PetSignupPage> {
  XFile? _pickedFile;

  int _userid = 0;
  String _usernickname = "";
  String _accesstoken = "";

  List<String> Pet_List = ['강아지','고양이'];
  List<dynamic> petinfo = [];
  String Pet_species = '강아지';
  var pet_male = false;
  var pet_female = false;
  var isChecked1 = false;
  var isChecked2 = false;
  int Pet_Gender = 2;
  int Pet_neutered = 2;
  int petnamevalidate = 1;
  int petbirthvalidate = 1;
  int petnumbervalidate = 1;
  int petvalidate = 10;
  final _PetNameValidate = TextEditingController();
  final _PetBirthValidate = TextEditingController();
  final _PetNumberValidate = TextEditingController();
  final _PetNameController = TextEditingController();
  final _PetBirthdayController = TextEditingController();
  final _PetNumberController = TextEditingController();

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userid = (prefs.getInt('userId') ?? 0);
      _usernickname = (prefs.getString('userNickname') ?? "");
      _accesstoken = (prefs.getString('accessToken') ?? "");
    });
    print(_userid);
    print(_usernickname);
    print(_accesstoken);
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _PetNameValidate.dispose();
    _PetBirthValidate.dispose();
    _PetNumberValidate.dispose();
    _PetNameController.dispose();
    _PetBirthdayController.dispose();
    _PetNumberController.dispose();
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
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 40,right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: size.height * 0.06
              ),
              Text(
                "펫 정보 입력",
                style: TextStyle(fontFamily: 'GmarketSans', fontSize: 32, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                  height: size.height * 0.02
              ),
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
                          border: Border.all(
                              width: 2, color: PRIMARY_COLOR),
                          image: DecorationImage(
                              image: FileImage(File(_pickedFile!.path)),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                  height: size.height * 0.03
              ),
              SizedBox(
                height: 40,
                width: 200,
                child: TextFormField(
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                  controller: _PetNameController,
                  decoration: InputDecoration(
                    hintText: "펫의 이름을 입력해주세요",
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: SECOND_COLOR, width: 1.2),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if(_PetNameController.text.isEmpty){
                        petnamevalidate = 1;
                        _PetNameValidate.text = '      이름을 입력해주세요';
                      }
                      else {
                        _PetNameValidate.text = '';
                        petnamevalidate = 0;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 15,
                child: TextField(
                  controller: _PetNameValidate,
                  enabled: false,
                  style: TextStyle(fontSize: 10, color: Colors.red, ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 6,color: Colors.red),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 35,
                    width: 30,
                    padding: const EdgeInsets.fromLTRB(7, 8, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: PRIMARY_COLOR, width: 1.2),
                    ),
                    child: Text(
                      "종",
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,),
                    ),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      width: size.width * 0.02
                  ),
                  DropdownButton(
                    value: Pet_species,
                    items: Pet_List.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text('$item', style: TextStyle(fontFamily: 'GmarketSans',),),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        Pet_species = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                  height: size.height * 0.015
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 180,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      maxLength: 8,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: _PetBirthdayController,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "나이를 입력해주세요 (세)",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,color: Colors.grey.shade800),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: SECOND_COLOR, width: 1.2),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if(_PetBirthdayController.text.isEmpty){
                            petbirthvalidate = 1;
                            _PetBirthValidate.text = '      나이를 입력해주세요';
                          }
                          else if(_PetBirthdayController.text.length > 2 ){
                            petbirthvalidate = 2;
                            _PetBirthValidate.text = '      유효한 숫자가 아닙니다';
                          }
                          else {
                            _PetBirthValidate.text = '';
                            petbirthvalidate = 0;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                      width: size.width * 0.03
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.5,
                    height: 15,
                    child: TextField(
                      controller: _PetBirthValidate,
                      enabled: false,
                      style: TextStyle(fontSize: 10, color: Colors.red, ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 6,color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: size.width * 0.015
                  ),
                ],
              ),
              SizedBox(
                  height: size.height * 0.005
              ),
              SizedBox(
                height: 40,
                width: 250,
                child: TextFormField(
                  style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: _PetNumberController,
                  decoration: InputDecoration(
                    hintText: "반려견의 등록번호를 입력해주세요",
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    hintStyle: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: PRIMARY_COLOR, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: SECOND_COLOR, width: 1.2),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if(_PetNumberController.text.isEmpty){
                        petnumbervalidate = 1;
                        _PetNumberValidate.text = '      등록번호를 입력해주세요';
                      }
                      else {
                        _PetNumberValidate.text = '';
                        petnumbervalidate = 0;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
                child: TextField(
                  controller: _PetNumberValidate,
                  enabled: false,
                  style: TextStyle(fontSize: 10, color: Colors.red,),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 6,color: Colors.red),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 35,
                    width: 55,
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 1.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("성별", style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,),),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text('남자', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12)),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                      activeColor: PRIMARY_COLOR,
                      checkColor: Colors.white,
                      value: pet_male,
                      onChanged: (value) {
                        setState(() {
                          Pet_Gender = 1;
                          pet_male = value!;
                          if(pet_female == true){
                            pet_female = false;
                          }
                          if(pet_male == false && pet_female == false){
                            Pet_Gender = 2;
                          }
                          print(Pet_Gender);
                        });
                      },
                    ),
                  ),
                  Text('여자', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12)),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                      activeColor: PRIMARY_COLOR,
                      checkColor: Colors.white,
                      value: pet_female,
                      onChanged: (value) {
                        setState(() {
                          pet_female = value!;
                          Pet_Gender = 0;
                          if(pet_male == true){
                            pet_male = false;
                          }
                          if(pet_male == false && pet_female == false){
                            Pet_Gender = 2;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 35,
                    width: 95,
                    padding: EdgeInsets.fromLTRB(12, 7, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 1.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("중성화 유무", style: TextStyle(fontFamily: 'GmarketSans', fontSize: 13,),),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text('했음', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12)),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                      activeColor: PRIMARY_COLOR,
                      checkColor: Colors.white,
                      value: isChecked1,
                      onChanged: (value) {
                        setState(() {
                          isChecked1 = value!;
                          Pet_neutered = 1;
                          if( isChecked2 == true){
                            isChecked2 = false;
                          }
                          if(isChecked1 == false && isChecked2 == false) {
                            Pet_neutered = 2;
                          }
                        });
                      },
                    ),
                  ),
                  Text('하지 않음', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12)),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                      activeColor: PRIMARY_COLOR,
                      checkColor: Colors.white,
                      value: isChecked2,
                      onChanged: (value) {
                        setState(() {
                          isChecked2 = value!;
                          Pet_neutered = 0;
                          if( isChecked1 == true){
                            isChecked1 = false;
                          }
                          if(isChecked1 == false && isChecked2 == false) {
                            Pet_neutered = 2;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: size.height * 0.03
              ),
              Center(
                child: Container(
                  height: 60,
                  width: 280,
                  child: TextButton(
                    onPressed: (){},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )
                        )
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              petinfo.clear();
                              setState(() {
                                petvalidate = petnamevalidate + petbirthvalidate + petnumbervalidate;
                              });
                              petinfo.add(_PetNameController.text);
                              petinfo.add(Pet_species);
                              petinfo.add(_PetBirthdayController.text);
                              petinfo.add(_PetNumberController.text);
                              if(Pet_Gender == 1) {
                                petinfo.add("남자");
                              }
                              else{
                                petinfo.add("여자");
                              }
                              if(Pet_neutered == 1) {
                                petinfo.add("했음");
                              }
                              else{
                                petinfo.add("하지 않음");
                              }
                              print(petvalidate);
                              if(petvalidate == 0  && Pet_Gender !=2 && Pet_neutered !=2) {
                                // Navigator.pop(context, petinfo);
                                print(petinfo);
                                pet_signup_post(_userid, petinfo[0], petinfo[1], petinfo[2], petinfo[3], petinfo[4], petinfo[5]);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => NavBar()));
                              }
                              else{
                                print(petvalidate);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(maxWidth: double.infinity,minHeight: 100),
                              child: Text("저장",style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: size.height * 0.02
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NavBar()));
                      },
                      child: Text(
                        "펫 정보 나중에 입력하기",
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
              SizedBox(
                  height: size.height * 0.02
              ),
            ],
          ),
        ),
      ),
    );
  }
}