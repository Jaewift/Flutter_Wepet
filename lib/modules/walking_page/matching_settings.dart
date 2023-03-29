import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../color/colors.dart';

class MatchingSettingsPage extends StatefulWidget {
  @override
  _MatchingSettingsPageState createState() => _MatchingSettingsPageState();
}

class _MatchingSettingsPageState extends State<MatchingSettingsPage> {
  List<String> Pet_List = ['강아지','고양이'];
  String Pet_species = '강아지';
  var person_man = false;
  var person_woman = false;
  var pet_male = false;
  var pet_female = false;
  var isChecked1 = false;
  var isChecked2 = false;

  int Pet_Gender = 2;
  int Pet_neutered = 2;
  int Gender = 2;

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
                      SizedBox(height: size.height * 0.05),
                      Text(
                        "매칭 조건 설정",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: size.height * 0.06),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(10, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "성별",
                              style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '남자',
                            style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),
                          ),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                              activeColor: PRIMARY_COLOR,
                              checkColor: Colors.white,
                              value: person_man,
                              onChanged: (value) {
                                setState(() {
                                  Gender = 1;
                                  person_man = value!;
                                  if (person_woman == true) {
                                    person_woman = false;
                                  }
                                  if (person_man == false &&
                                      person_woman == false) {
                                    Gender = 2;
                                  }
                                });
                                print(Gender);
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
                              value: person_woman,
                              onChanged: (value) {
                                setState(() {
                                  Gender = 0;
                                  person_woman = value!;
                                  if (person_man == true) {
                                    person_man = false;
                                  }
                                  if (person_man == false &&
                                      person_woman == false) {
                                    Gender = 2;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.016),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(9, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "나이",
                              style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 40,
                            width: 65,
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "     (세)",
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintStyle:
                                TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: PRIMARY_COLOR,
                                      width: 1.2
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: SECOND_COLOR, width: 1.2
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(9, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "거리",
                              style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 40,
                            width: 70,
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "    (km)",
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintStyle:
                                TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: PRIMARY_COLOR,
                                      width: 1.2
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: SECOND_COLOR, width: 1.2
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      Center(
                        child: Container(
                          height: 1.0,
                          width: 380.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Row(
                        children: [
                          Container(
                            width: 65,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "펫 성별",
                              style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '남자',
                            style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),
                          ),
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
                                  print(Pet_Gender);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Container(
                            width: 92,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "중성화 유무",
                              style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '했음',
                            style: TextStyle(fontFamily: 'GmarketSans', fontSize: 12),
                          ),
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
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 30,
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
                            style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              width: size.width * 0.02
                          ),
                          DropdownButton(
                            value: Pet_species,
                            items: Pet_List.map((String item) {
                              return DropdownMenuItem<String>(
                                child: Text('$item', style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),),
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
                      SizedBox(height: size.height * 0.016),
                      Row(
                        children: [
                          Container(
                            width: 92,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: PRIMARY_COLOR, width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "산책 시간대",
                              style: TextStyle(
                                fontFamily: 'GmarketSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            "   :   ",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintStyle:
                                TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: PRIMARY_COLOR,
                                      width: 1.2
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: SECOND_COLOR, width: 1.2
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                          Text(
                            "   ~   ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: TextFormField(
                              style: TextStyle(fontFamily: 'GmarketSans', fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintStyle:
                                TextStyle(fontFamily: 'GmarketSans', fontSize: 14, color: Colors.grey.shade800),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: PRIMARY_COLOR,
                                      width: 1.2
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: SECOND_COLOR, width: 1.2
                                  ),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                          Text(
                            "  (시간)",
                            style: TextStyle(
                                fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
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
                                    "저장",
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
                    ]
                )
            )
        )
    );
  }
}
