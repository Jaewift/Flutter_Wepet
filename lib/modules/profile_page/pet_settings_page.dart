import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../color/colors.dart';

class PetSettingsPage extends StatefulWidget {
  @override
  _PetSettingsPageState createState() => _PetSettingsPageState();
}

class _PetSettingsPageState extends State<PetSettingsPage>{
  XFile? _pickedFile;

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
  int petgendervalidate = 1;
  int neuteredvalidate = 1;
  int petvalidate = 9;
  final _PetNameValidate = TextEditingController();
  final _PetBirthValidate = TextEditingController();
  final _PetNumberValidate = TextEditingController();
  final _PetNameController = TextEditingController();
  final _PetBirthdayController = TextEditingController();
  final _PetNumberController = TextEditingController();

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
  Widget build(BuildContext context){
    final _imageSize = MediaQuery.of(context).size.width / 3.5;
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
                  height: size.height * 0.07
              ),
              Text(
                "펫 정보 수정",
                style: TextStyle(fontFamily: 'GmarketSans', fontSize: 32, fontWeight: FontWeight.w700),
              ),
              Column(
                children: [
                  const SizedBox(height: 20,),
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
                    width: 35,
                    height: 35,
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
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
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
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
                  height: size.height * 0.02
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 220,
                    height: 40,
                    child: TextFormField(
                      style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      controller: _PetBirthdayController,
                      decoration: InputDecoration(
                        hintText: "생년월일을 입력해주세요(8자리)",
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
                            _PetBirthValidate.text = '      생년월일을 입력해주세요';
                          }
                          else if(_PetBirthdayController.text.length <= 7 ){
                            petbirthvalidate = 2;
                            _PetBirthValidate.text = '      8자리가 아닙니다';
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
                ],
              ),
              SizedBox(
                  height: size.height * 0.005
              ),
              SizedBox(
                height: 40,
                width: 240,
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
                    width: 50,
                    height: 35,
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 1.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("성별", style: TextStyle( fontFamily: 'GmarketSans', fontSize: 14,),),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text('남자', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),),
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
                  Text('여자', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),),
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
                    width: 90,
                    height: 35,
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 1.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("중성화 유무", style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14,),),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text('했음', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),),
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
                  Text('하지 않음', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),),
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
                  height: size.height * 0.04
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 55,
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )
                          )
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  petvalidate = petnamevalidate + petbirthvalidate + petnumbervalidate;
                                });
                                petinfo.add(_PetNameController.text);
                                petinfo.add(Pet_species);
                                petinfo.add(_PetBirthdayController.text);
                                petinfo.add(_PetNumberController.text);
                                if(Pet_Gender == 1) {
                                  petinfo.add(1);
                                }
                                else{
                                  petinfo.add(0);
                                }
                                if(Pet_neutered == 1) {
                                  petinfo.add(1);
                                }
                                else{
                                  petinfo.add(0);
                                }
                                if(petvalidate == 0  && petgendervalidate !=2 && neuteredvalidate !=2) {
                                  Navigator.pop(context, petinfo);
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
                  Container(
                    width: 120,
                    height: 55,
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )
                          )
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: SECOND_COLOR,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(maxWidth: double.infinity,minHeight: 100),
                                child: Text("취소",style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}