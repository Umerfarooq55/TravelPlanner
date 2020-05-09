import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/ui/pages/HomePageWithoutAppBar.dart';
import 'package:onboarding_flow/ui/pages/homepage.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:search_widget/search_widget.dart';

import '../../data.dart';

class Topics extends StatefulWidget {
  @override
  TopicsState createState() => new TopicsState();
}

class TopicsState extends State {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, bool> values = {
    'Apple': false,
    'Banana': false,
    'Cherry': false,
    'Mango': false,
    'Orange': false,
  };
  List list = [142, 150];
  List list2 = ["umer", "umer"];
  var tmpArray = [];
  var tmpArray2 = [];
  var showSubtopics = false;
  var counter;
  bool showworld = false;
  List<Data> subtopicsList = new List();
  bool firsttime = true;
  double _lowerValue = 50;
  double _upperValue = 180;
  bool showtext = true;
  var obj = new Map<dynamic, dynamic>();
  var Mainmap = new Map<dynamic, dynamic>();
  var firstColor = Color(0xff141e30), secondColor = Color(0xff243b55);
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String CurrentTopic="assets/topic_one.png";

  List getCheckboxItems() {
    var tmpArray = [];
    var tmpArray2 = [];

    for (int i = 0; i < subtopicsList.length; i++) {
      subtopicsList[i].contents.forEach((key, value) {
        if (subtopicsList[i].contents[key]['alue'] == true) {
          print("Runing " + i.toString());

          tmpArray.add(value['id']);
        }
      });
    }

    print("Actual List" + tmpArray.toString());

    return tmpArray.toSet().toList();
    ;
  }

  List getCheckboxnames() {
    var tmpArray = [];
    var tmpArray2 = [];

    for (int i = 0; i < subtopicsList.length; i++) {
      subtopicsList[i].contents.forEach((key, value) {
        if (subtopicsList[i].contents[key]['alue'] == true) {
          tmpArray2.add(key);
        }
      });
    }

    print("Actual List 2" + tmpArray2.toString());
    return tmpArray2.toSet().toList();
  }

  int getHeading(String getkey) {
    var tmpArray2 = 0;
    for (int i = 0; i < subtopicsList.length; i++) {
      subtopicsList[i].contents.forEach((key, value) {
        if (subtopicsList[i].contents[key] == getkey) {
          return i;
        }
      });
    }

    print("Actual List 2" + tmpArray2.toString());
    return tmpArray2;
  }

Future<void> _sendAnalyticsEvent(String name) async {
  await analytics.logEvent(
    name: 'Subtopics',
    parameters: <String, dynamic>{
      'subtopic': name,
    },
  );
}

Future<void> _sendAnalyticsEventshowcities(String name) async {
  await analytics.logEvent(
    name: 'ShowCities',
    parameters: <String, dynamic>{
      'clickonshoecities': "yes",
    },
  );
}
  @override
  Widget build(BuildContext context) {
//
    return SingleChildScrollView(
      child: Wrap(
        children: <Widget>[
          Container(
            color: Color(0xffEEEEEE),
            child: Stack(
              children: <Widget>[
                showtext
                    ? Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: AssetImage("assets/headericon.png"),
                                width: 50,
                                height: 50,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 8.0),
                            child: Text(
                              "Discover the perfect destinations according to your interests!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    : Container(),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 34, right: 10, top: 118.0),
                      child: Text(
                        "Interessi:".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 20,
                            child: Container(
                              height: 35,
                              width: 110,
                              decoration: new BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              child: Center(
                                child: Text(
                                  "Tutto",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image(
                              image: AssetImage("assets/plus.png"),
                              width: 30,
                              height: 30,
                            )),
                      ],
                    ),
//
                    showSubtopics?UnSelect():    Select(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Center(
                        child: NiceButton(
                          elevation: 10,
                          radius: 20,
                          padding: const EdgeInsets.all(15),
                          text: showworld ? "Off World ?" : "Show World ? ",
                          gradientColors: [secondColor, firstColor],
                          onPressed: () {
                            setState(() {
                              if (showworld) {
                                showworld = false;
                              } else {
                                showworld = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    showworld ? WorlSearch() : Container()
                  ],
                ),

//
              ],
            ),
          ),
          HomePageWithoutAppbar(list, list2),
        ],
      ),
    );
  }

  Padding WorlSearch() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HomePage(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 5, top: 0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 20,
                  child: Container(
                    height: 35,
                    width: 160,
                    decoration: new BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: Center(
                      child: Text(
                        "Place with distance?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 50, right: 50),
              alignment: Alignment.centerLeft,
              child: FlutterSlider(
                values: [30, 60],
                rangeSlider: true,
                max: 100,
                min: 0,
                visibleTouchArea: false,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBarHeight: 14,
                  activeTrackBarHeight: 10,
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                    border: Border.all(width: 3, color: Colors.blue),
                  ),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blue.withOpacity(0.5)),
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValue = lowerValue;
                  _upperValue = upperValue;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget UnSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 10),
          child: GestureDetector(
            onTap: (){
              setState(() {
                showSubtopics=false;

              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(CurrentTopic),
                width: 89,
                height: 90,
              ),
            ),
          ),
        ),
    Container(
      height: 250,
      child:Subtopics()
    ),
        Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showSubtopics=true;
                         CurrentTopic =  "assets/topic_one.png";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_one.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showSubtopics=true;
                            CurrentTopic =  "assets/topic_two.png";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_two.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showSubtopics=true;

                                CurrentTopic =  "assets/topic_three.png";

                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_three.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showSubtopics=true;
                            CurrentTopic =  "assets/topic_four.png";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_four.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 26, top: 10),
                      child: GestureDetector(
                        onTap: (){
                        setState(() {
                          showSubtopics=true;
                          CurrentTopic =  "assets/topic_fie.png";
                        });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_fie.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 26, top: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showSubtopics=true;
                            CurrentTopic =  "assets/topic_six.png";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/topic_six.png"),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Select() {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                      CurrentTopic = "assets/topic_one.png";
                      });

                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_one.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                        CurrentTopic = "assets/topic_two.png";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_two.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                        CurrentTopic = "assets/topic_three.png";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_three.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                        CurrentTopic = "assets/topic_four.png";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_four.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                        CurrentTopic = "assets/topic_fie.png";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 20,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_fie.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        showSubtopics=true;
                        CurrentTopic = "assets/topic_six.png";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/topic_six.png"),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List MainHeading = [];

  Widget MainHeadingCards() {
    MainHeading = getCheckboxnames();

    return Container(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: MainHeading.length,
          itemBuilder: (BuildContext context, int i) => GestureDetector(
            onTap: () {
//
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                    side: BorderSide(color: Colors.red, width: 1)),
                elevation: 5,
                child: Container(
                  width: 200,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Center(
                            child: Text(
                              MainHeading[i],
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
//                                        new IconButton(
//                                            icon: new Icon(Icons.close
//                                            ,color: Colors.white,),
//                                            onPressed: () {
//
//var currentPos = getHeading(MainHeading[i]);
//                                              setState(() {
//                                                subtopicsList[currentPos]
//                                                    .contents[ MainHeading[i]]['alue'] =
//                                                    false;
//
//                                              });
//
//
//                                            }
//                                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

//  Widget ProjectTiles() {
//    List bar;
//    return FutureBuilder(
//        future: Fetchsubtopics(),
//        builder: (BuildContext context, AsyncSnapshot<List<Data>> dataList) {
//          if (firsttime) {
//            if (!dataList.hasData)
//              return Padding(
//                padding: const EdgeInsets.only(top: 28.0),
//                child: Center(
//                  child: CircularProgressIndicator(
//                    backgroundColor: Colors.amber,
//                  ),
//                ),
//              );
//          }
//          return SingleChildScrollView(
//            physics: ScrollPhysics(),
//            child: Wrap(children: <Widget>[
//              ListView.builder(
//                  shrinkWrap: true,
//                  physics:  NeverScrollableScrollPhysics(), // new
//                  itemCount: subtopicsList.length,
//                  itemBuilder: (context, i) {
//                    var counter=0;
//                    print("ListView" + subtopicsList.length.toString());
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: subtopicsList[i]
//                              .contents
//                              .keys
//                              .map((String key) {
//                            return CheckboxListTile(
//                              title: new Text(
//                                "$key",
//                                style: TextStyle(
//                                  shadows: [
//                                    Shadow(
//                                      blurRadius: 110,
//                                      color: Colors.grey,
//                                      offset: Offset(4.0, 4.0),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                              value: subtopicsList[i].contents[key]['alue'],
//                              activeColor: Colors.pink,
//                              checkColor: Colors.white,
//                              onChanged: (bool value) {
////
//                                if (MainHeading.length == 6) {
//                                  Scaffold.of(context)
//                                      .showSnackBar(new SnackBar(
//                                    content: new Text(
//                                        "you reached the max number of filters. remove some filters to add new ones"),
//                                  ));
//                                }
//                                setState(() {
//                                  subtopicsList[i].contents[key]['alue'] =
//                                      value;
//                                  firsttime = false;
//                                  showtext = false;
//                                });
//                              },
//                            );
//                          }).toList(),
//                       );
//
//                  })
//            ]),
//          );
//        });
//  }


}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LeaderBoard> list = <LeaderBoard>[
    LeaderBoard("Italy", 54),
    LeaderBoard("Spain", 22.5),
    LeaderBoard("London", 24.7),
    LeaderBoard("Sweden", 22.1),
  ];

  LeaderBoard _selectedItem;

  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          SearchWidget<LeaderBoard>(
            dataList: list,
            hideSearchBoxWhenItemSelected: false,
            listContainerHeight: MediaQuery.of(context).size.height / 4,
            queryBuilder: (query, list) {
              return list
                  .where((item) =>
                      item.username.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (item) {
              return PopupListItemWidget(item);
            },
            selectedItemBuilder: (selectedItem, deleteSelectedItem) {
//                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
            },
            // widget customization
            noItemsFoundWidget: NoItemsFound(),
            textFieldBuilder: (controller, focusNode) {
              return MyTextField(controller, focusNode);
            },
            onItemSelected: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),
        ],
      ),
    );
  }
}

class LeaderBoard {
  LeaderBoard(this.username, this.score);

  final String username;
  final double score;
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final LeaderBoard selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.username,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final LeaderBoard item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.username,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
class Subtopics extends StatefulWidget {
  @override
  _SubtopicsState createState() => _SubtopicsState();
}

class _SubtopicsState extends State<Subtopics> {
  bool firsttime = true;
  List<Data> subtopicsList = new List();

  Widget ProjectTiles() {
    List bar;
    return FutureBuilder(
        future: Fetchsubtopics(),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> dataList) {
          if (firsttime) {
            if (!dataList.hasData)
              return Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                ),
              );
          }
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left:18.0,right: 18.0),
              child: Wrap(children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics:  NeverScrollableScrollPhysics(), // new
                    itemCount: subtopicsList.length,
                    itemBuilder: (context, i) {
                      var counter=0;
                      print("ListView" + subtopicsList.length.toString());
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subtopicsList[i]
                            .contents
                            .keys
                            .map((String key) {
                          return CheckboxListTile(
                            title: new Text(
                              "$key",
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                    blurRadius: 110,
                                    color: Colors.grey,
                                    offset: Offset(4.0, 4.0),
                                  ),
                                ],
                              ),
                            ),
                            value: subtopicsList[i].contents[key]['alue'],
                            activeColor: Colors.pink,
                            checkColor: Colors.white,
                            onChanged: (bool value) {
//
//                            if (MainHeading.length == 6) {
//                              Scaffold.of(context)
//                                  .showSnackBar(new SnackBar(
//                                content: new Text(
//                                    "you reached the max number of filters. remove some filters to add new ones"),
//                              ));
//                            }
                              setState(() {
                                subtopicsList[i].contents[key]['alue'] =
                                    value;
                                firsttime = false;
//                              showtext = false;
                              });
                            },
                          );
                        }).toList(),
                      );

                    })
              ]),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return ProjectTiles();
  }
  Future<List<Data>> Fetchsubtopics() async {
    if (firsttime) {
      var obj = new Map<dynamic, dynamic>();
      var Mainmap = new Map<String, dynamic>();
      String url = 'https://gscrape.xeeve.com/api/config?lang=en_US';
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
      final response = await http.get(url);
      print("URL : " + url);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print("Response : " + response.body);
        List listresponse = json.decode(response.body)['search']['topics'];
        await listresponse.forEach((element) async {
          var Mainmap = new Map<String, dynamic>();
          await element['childs'].forEach((doc) {
            var obj = new Map<dynamic, dynamic>();

            obj['alue'] = false;
            obj['id'] = doc['id'].toString();
//                                          obj[listresponse[i]['childs']['id']] =false;
            print("TEXT VIEW" + doc.toString());
            Mainmap[doc['name']] = obj;

            print("TEXT VIEW umer" + subtopicsList.length.toString());
          });
          await subtopicsList.add(
//
              new Data(element['name'], Mainmap));
        });
        print("Mainmap " + Mainmap.length.toString());

        return subtopicsList;
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print("Failed to load album " + url);
        throw Exception('Failed to load album');
      }
    } else {}
  }
}
