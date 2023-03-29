import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jmsmart_project/modules/color/colors.dart';
import 'package:jmsmart_project/modules/walking_page/matching_settings.dart';
import 'package:jmsmart_project/modules/walking_page/user_profile.dart';
import 'package:transition/transition.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

const String kakaoMapKey = 'f6d7146290bb37086efa5a0e6d0248de';

class CarePage extends StatefulWidget{
  @override
  _CarePage createState() => _CarePage();
}

class _CarePage extends State<CarePage> {
  String nickname = '';

  List<String> imageList = [
    "assets/images/profile/pet_hospital.png",
    "assets/images/profile/pet_hospital.png",
    "assets/images/profile/pet_hospital.png",
    "assets/images/profile/pet_hospital.png",
    "assets/images/profile/pet_hospital.png"
  ];
  List<String> NicknameList = ["우솔동물병원", "대학동물병원", "행복한동물병원", "메인동물메디컬센터", "골드퍼피동물병원 공릉점"];
  List<String> petnameList = ["서울 노원구 화랑로 349", "서울 성북구 화랑로 299 한일 노벨리아시티 210호", "서울 성북구 돌곶이로 91", "서울 노원구 동일로 1025-1 4층", "서울 노원구 동일로 1014 1층"];

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
                      "펫 케어",
                      style:
                      TextStyle(fontFamily: 'GmarketSans', fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    Text(
                      "병원 추천 리스트",
                      style:
                      TextStyle(fontFamily: 'GmarketSans', fontSize: 24, fontWeight: FontWeight.w700),
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
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: 230,
                  width: 340,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                          color: PRIMARY_COLOR, width: 2
                      )
                  ),
                  child: KakaoMapView(
                      width: 230,
                      height: 340,
                      kakaoMapKey: kakaoMapKey,
                      lat: 37.61967,
                      lng: 127.06078,
                      showMapTypeControl: false,
                      showZoomControl: false,
                      customScript: '''
    var markers = [];

    function addMarker(position, i) {

      var marker = new kakao.maps.Marker({position: position});
    
      marker.setMap(map);

      markers.push(marker);
      
      kakao.maps.event.addListener(markers[i], 'click', (function(i) {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      })(i));
    }

    addMarker(new kakao.maps.LatLng(37.61641490921443, 127.06526369236295), 0);
    addMarker(new kakao.maps.LatLng(37.613717949157866, 127.06076711538016), 1);
    addMarker(new kakao.maps.LatLng(37.61110718993404, 127.05652462525973), 2);
    addMarker(new kakao.maps.LatLng(37.62167156546262, 127.0739314563541), 3);
    addMarker(new kakao.maps.LatLng(37.62055009472463, 127.07494979333293), 4);
    var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
                      markerImageURL:
                      'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                      onTapMarker: (message) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Marker is clicked')));
                      }),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  width: 340,
                  height: size.height * 0.5,
                  child: ListView.builder(
                      itemCount: NicknameList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
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
                                  width: 220,
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
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
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
                                        ],
                                      ),
                                    ],
                                  ),
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

