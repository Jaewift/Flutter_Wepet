import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/walking_page/matching_settings.dart';
import 'package:jmsmart_project/modules/walking_page/user_profile.dart';
import 'package:transition/transition.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = 'f6d7146290bb37086efa5a0e6d0248de';

class WalkingPage extends StatefulWidget{
  @override
  _WalkingPage createState() => _WalkingPage();
}

class _WalkingPage extends State<WalkingPage> {
  String nickname = '';

  List<String> imageList = [
    "assets/images/profile/animal2.png",
    "assets/images/profile/animal.png",
    "assets/images/profile/animal3.png",
  ];
  List<String> NicknameList = ["밥", "버즈", "나미"];
  //List<String> oldList = ["20세", "21세", "24세"];
  List<String> addressList = ["노원", "노원", "노원"];
  List<String> petnameList = ["토리", "누룽이", "쿠키"];
  List<String> petoldList = ["3세", "2세", "6세"];
  List<String> useridList = ["5", "6", "7"];
  List<String> nameList = ["홍길동", "김민준", "이서준"];
  List<String> emailList = ["test12@naver.com", "test34@naver.com", "test56@naver.com"];
  List<String> categoryList = ["강아지", "강아지", "강아지"];
  List<String> genderList = ["남", "여", "남"];
  List<String> neuList = ["했음", "안했음", "했음"];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "산책 파트너 매칭",
                      style:
                      TextStyle(fontFamily: 'GmarketSans', fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   height: 30,
                    //   width: 75,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: PRIMARY_COLOR,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10))),
                    //     child: const Text(
                    //       "산책 관리",
                    //       style: TextStyle(
                    //           fontFamily: 'GmarketSans',
                    //           fontSize: 10,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: size.width * 0.005,
                    // ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            Transition(
                                child: MatchingSettingsPage(),
                                transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "매칭 설정",
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
                  height: size.height * 0.03,
                ),
                Container(
                  height: 250,
                  width: 340,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                          color: PRIMARY_COLOR, width: 2
                      )
                  ),
                  child: KakaoMapView(
                      width: 250,
                      height: 340,
                      kakaoMapKey: kakaoMapKey,
                      lat: 37.61991,
                      lng: 127.05973,
                      showMapTypeControl: false,
                      showZoomControl: false,
                      customScript: '''
    var markers = [];

    function addMarker(position, i) {
    var markerImages = ['data:image/jpeg;base64,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', 'http://image.dongascience.com/Photo/2022/06/6982fdc1054c503af88bdefeeb7c8fa8.jpg', 'https://img1.daumcdn.net/thumb/R1280x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/32E9/image/BA2Qyx3O2oTyEOsXe2ZtE8cRqGk.JPG'];
      var markerImage = new kakao.maps.MarkerImage(
    markerImages[i],
    new kakao.maps.Size(25, 25), new kakao.maps.Point(13, 34));

      var marker = new kakao.maps.Marker({position: position});
    
      marker.setMap(map);
      
      marker.setImage(markerImage);

      markers.push(marker);
      
      kakao.maps.event.addListener(markers[i], 'click', (function(i) {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      })(i));
    }

    addMarker(new kakao.maps.LatLng(37.62000, 127.05877), 0);
    addMarker(new kakao.maps.LatLng(37.61967, 127.06078), 1);
    addMarker(new kakao.maps.LatLng(37.61958, 127.06004), 2);
              ''',
                      markerImageURL:
                      'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                      onTapMarker: (message) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Marker is clicked')));
                      }),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  width: 340,
                  height: size.height,
                  child: ListView.builder(
                      itemCount: NicknameList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfilePage(data: useridList[index],
                                      img: imageList[index],
                                      nickname: NicknameList[index],
                                      petname: petnameList[index],
                                      petold: petoldList[index],
                                      name: nameList[index],
                                      email: emailList[index],
                                      category: categoryList[index],
                                      gender: genderList[index],
                                      neu: neuList[index],
                                      index: index,
                                    )
                                )
                            );
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('쪽지 보내기', style: TextStyle(fontFamily: 'GmarketSans',),),
                                  content: Text(
                                      '쪽지를 보낼까요?',
                                      style: TextStyle(fontFamily: 'GmarketSans',)
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        '취소',
                                        style: TextStyle(
                                            fontFamily: 'GmarketSans',
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      },
                                    ),
                                    TextButton(
                                        child: Text(
                                          '보내기',
                                          style: TextStyle(
                                              fontFamily: 'GmarketSans',
                                              color: Colors.black),
                                        ),
                                        onPressed: () {
                                          //댓글 삭제 delete
                                        }
                                    ),
                                  ],
                                )
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: PRIMARY_COLOR, width: 1.5
                                )
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          child: Image.asset(
                                            imageList[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            NicknameList[index],
                                            style: TextStyle(
                                                fontFamily: 'GmarketSans',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              petnameList[index],
                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 10,
                                                  color: Colors.black)
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(
                                              petoldList[index],
                                              style: TextStyle(
                                                  fontFamily: 'GmarketSans',
                                                  fontSize: 10,
                                                  color: Colors.black)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.35,
                                ),
                                Text(addressList[index],
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        fontSize: 10,
                                        color: Colors.black)
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

