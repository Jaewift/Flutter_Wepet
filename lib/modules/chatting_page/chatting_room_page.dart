import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

List<ChatMessage> _messages = [
  ChatMessage(
      messageContent: "Is there any thing wrong?", messageType: "sender"),
  ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  ChatMessage(
      messageContent: "Hey Kriss, I am doing fine dude. wbu?",
      messageType: "sender"),
  ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
];

class ChattingRoomPage extends StatefulWidget {
  _ChattingRoomPage createState() => _ChattingRoomPage();
}

class _ChattingRoomPage extends State<ChattingRoomPage>
    with TickerProviderStateMixin {

  final TextEditingController _textController = TextEditingController();

  StompClient? stompClient;

  final socketUrl = 'http://52.79.223.14:8080/wss/chat';

  void onConnect(StompFrame frame) {
    stompClient!.subscribe(
        destination: '/chat/message',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> obj = json.decode(frame.body!);
            ChatMessage message = ChatMessage(
                messageContent: obj['content'], messageType: obj['uuid']);
            setState(() => {_messages.add(message)});
          }
        });
  }

  sendMessage() {
    setState(() {
      stompClient!.send(
          destination: '/chat/message',
          body: json.encode(
              {"content": _textController.value.text, "uuid": "sender"}));
    });
  }

  @override
  void initState() {
    super.initState();
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
      stompClient!.activate();
    }
  }

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('쪽지함'),
        backgroundColor: Colors.green[400],
      ),
      resizeToAvoidBottomInset : false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            // child: Padding(
            //   padding: const EdgeInsets.only(bottom: 50.0),
            //   child: StreamBuilder(
            //     // 채널의 스트림을 stream 항목에 설정. widget을 통해 MyHomePage의 필드에 접근 가능
            //     stream: widget.channel.stream,
            //     // 채널 stream에 변화가 발생하면 빌더 호출
            //     builder: (context, snapshot) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 24.0),
            //         // 수신 데이터가 존재할 경우 해당 데이터를 텍스트로 출력
            //         child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
            //       );
            //     },
            //   ),
            // ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (_messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (_messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          _messages[index].messageContent,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_textController.text.length > 0) {
                        _isComposing = true;
                      }
                      if (_isComposing == true) {
                        setState(() {
                          _isComposing = false;
                        });
                        ChatMessage message = ChatMessage(
                          messageContent: _textController.text,
                          messageType: "sender",
                        );
                        setState(() {
                          _messages.insert(0, message);
                        });
                        _textController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
