import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../color/colors.dart';

class UserProfilePage extends StatefulWidget {
  final String data;
  final String img;
  final String nickname;
  final String petname;
  final String petold;
  final int index;
  final String name;
  final String email;
  final String category;
  final String gender;
  final String neu;
  const UserProfilePage({Key? key, required this.data, required this.img, required this.name, required this.petname, required this.petold, required this.index, required this.nickname, required this.email, required this.category, required this.gender, required this.neu}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
    String data2 = widget.data;
    String img = widget.img;
    String nickname = widget.nickname;
    String petname= widget.petname;
    String petold= widget.petold;
    String name = widget.name;
    String email = widget.email;
    String category = widget.category;
    String gender = widget.gender;
    String neu = widget.neu;
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Container(
                height: 570,
                width: 340,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border.all(color: PRIMARY_COLOR, width: 2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Text(
                          "유저 정보 조회",
                          style: TextStyle(
                              fontFamily: 'GmarketSans', fontSize: 26, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: size.width * 0.1,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 75,
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
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/profile/people.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Column(
                          children: [
                            Text(
                              "닉네임: $nickname",
                              style: TextStyle(
                                  fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              "이름: $name",
                              style: TextStyle(
                                  fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              "이메일: $email",
                              style: TextStyle(
                                  fontFamily: 'GmarketSans', fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Center(
                      child: Container(
                        height: 1.0,
                        width: 300.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "$img",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "펫 이름: $petname",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "종: $category",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "나이: $petold",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "성별: $gender",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "중성화 유무: $neu",
                        style: TextStyle(
                            fontFamily: 'GmarketSans', fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
