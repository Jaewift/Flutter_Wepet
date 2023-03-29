import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jmsmart_project/modules/chatting_page/chatting_room_room2.dart';
import 'package:jmsmart_project/modules/http_api/chatting_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color/colors.dart';

class ChattingPage extends StatefulWidget {
  @override
  _ChattingPage createState() => _ChattingPage();
}

class _ChattingPage extends State<ChattingPage> {

  final List<ChatRoom> _room = <ChatRoom>[
    ChatRoom(name: "밥", text: '안녕하세요?', time: "1시간전",),
  ];

  Future<List>? chatting_room;

  int _userid = 0;
  int _petid = 0;
  String _usernickname = "";
  String _accesstoken = "";

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userid = (prefs.getInt('userId') ?? 0);
      _usernickname = (prefs.getString('userNickname') ?? "");
      _accesstoken = (prefs.getString('accessToken') ?? "");
      _petid = (prefs.getInt('petId') ?? 0);
    });
    print(_userid);
    print(_petid);
    print(_usernickname);
    print(_accesstoken);
  }

  @override
  void initState  () {
    super.initState();
    _loadUser();
    // chatting_room = chatting_page_get();
    //_room.add(ChatRoom(name: "밥", text: '안녕하세요?', time: "19시간전",),);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "쪽지함",
                        style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "쪽지 보내기",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: false,
                    itemCount: _room.length,
                    itemBuilder: (_, index) => _room[index],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatRoom extends StatelessWidget {
  //final img;
  final String name;
  final String text;
  final String time;
  ChatRoom({required this.text, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChattingRoomPage()));
        },
        // onLongPress: () {
        //   showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         content: Text('채팅룸을 삭제 하겟습니까?'),
        //         actions: [
        //           TextButton(
        //             child: Text("예", style: TextStyle(color: PRIMARY_COLOR,),),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //           TextButton(
        //             child: Text("아니요", style: TextStyle(color: PRIMARY_COLOR,),),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: PRIMARY_COLOR, width: 2)),
          width: 300,
          height: 90,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/images/profile/people.png",
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(300.0),
                  ),
                ),
              ),
              Container(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 30.0),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  time,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}