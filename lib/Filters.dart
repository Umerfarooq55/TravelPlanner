import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onboarding_flow/ui/pages/homepage.dart';
import 'dart:async';
import 'dart:convert';

import 'data.dart';
import 'package:http/http.dart' as http;

class CheckboxWidget extends StatefulWidget {
  @override
  CheckboxWidgetState createState() => new CheckboxWidgetState();
}

class CheckboxWidgetState extends State {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, bool> values = {
    'Apple': false,
    'Banana': false,
    'Cherry': false,
    'Mango': false,
    'Orange': false,
  };

  var tmpArray = [];
  var tmpArray2 = [];
  var counter;
  List<Data> subtopicsList= new List();
  bool firsttime = true;
  bool showtext = true;
  var obj = new Map<dynamic,dynamic>();
  var Mainmap = new Map<dynamic,dynamic>();
  List getCheckboxItems() {
    var tmpArray = [];
    var tmpArray2 = [];

    for (int i = 0; i < subtopicsList.length; i++) {

      subtopicsList[i].contents.forEach((key, value) {

        if (subtopicsList[i].contents[key]['alue']== true) {
          print("Runing " +i.toString());

            tmpArray.add(value['id']);


        }
      });
    }

    print("Actual List" + tmpArray.toString());

    return tmpArray.toSet().toList();;
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
  @override
  void initState() {


  }
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Future<void> _sendAnalyticsEvent(String name) async {

    await analytics.logEvent(
      name: 'Subtopics',
      parameters: <String, dynamic>{
        'subtopic':name,

      },
    );
  }
  Future<void> _sendAnalyticsEventshowcities(String name) async {

    await analytics.logEvent(
      name: 'ShowCities',
      parameters: <String, dynamic>{
        'clickonshoecities':"yes",

      },
    );
  }
  @override
  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.only(top: 60.0),
//          child: ListView.builder(
//            itemCount: vehicles.length,
//            itemBuilder: (context, i) {
//              return new ExpansionTile(
//                title: new Text(
//                  vehicles[i].title,
//                  style: new TextStyle(
//                      shadows: [
//                        Shadow(
//                          blurRadius: 10.0,
//                          color: Colors.grey,
//                          offset: Offset(1.0, 1.0),
//                        ),
//                      ],
//                      fontSize: 22.0,
//                      fontWeight: FontWeight.bold,
//                      fontStyle: FontStyle.normal,
//                      color: Colors.red),
//                ),
//                children: <Widget>[
//                  Column(
//                    children: vehicles[i].contents.keys.map((String key) {
//                      return new CheckboxListTile(
//                        title: new Text(
//                          "$key",
//                          style: TextStyle(
//                            shadows: [
//                              Shadow(
//                                blurRadius: 10.0,
//                                color: Colors.grey,
//                                offset: Offset(4.0, 4.0),
//                              ),
//                            ],
//                          ),
//                        ),
//                        value: vehicles[i].contents[key][0],
//                        activeColor: Colors.pink,
//                        checkColor: Colors.white,
//                        onChanged: (bool value) {
//                          if (MainHeading.length == 6) {
//                            Scaffold.of(context).showSnackBar(new SnackBar(
//                              content: new Text(
//                                  "you reached the max number of filters. remove some filters to add new ones"),
//                            ));
//                          }
//                          setState(() {
//                            vehicles[i].contents[key][0] = value;
//                            if (value) {
//                              MainHeading.add("$key");
//                            } else {
//                              MainHeading.removeAt(i);
//                            }
////                            if(counter==7){
////                              Scaffold.of(context).showSnackBar(new SnackBar(
////                                content: new Text("Limit is full"),
////                              ));
////                            }
//                          });
//                        },
//                      );
//                    }).toList(),
//                  ),
//                ],
//              );
//            },
//          ),
//        ),
//        MainHeadingCards()
//      ],
//    );
    return Stack(
        children: <Widget>[
       showtext?   Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Don't know where to travel? Select below what you'd like to do. Then click 'show cities' and start planning your trip!"
              ,
              textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 18,
                fontWeight:FontWeight.normal
              ),),
          ):Container(),
          SingleChildScrollView(
            child: Column(

        children: <Widget>[
            MainHeadingCards(),
    ProjectTiles()
        ],

            ),
          ),

          Align(
            alignment: Alignment.bottomRight,

            child: Padding(
              padding: const EdgeInsets.only(bottom:25.0,right: 22.0),
              child: Container(

                child: FloatingActionButton.extended(
                  onPressed: () {
                    _sendAnalyticsEventshowcities("");
                    List list = getCheckboxItems();
                    List list2 =  getCheckboxnames();
                    list2.forEach((element) {
                      _sendAnalyticsEvent(element);
                    });
                    if(list.length>0){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              HomePage(list,list2))
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: "please select things to do so we can show you relevant cities.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    // Add your onPressed code here!
                  },
                  label: Text("Show Cities",style: TextStyle(color: Colors.white),),
                  icon: Icon(Icons.navigate_next,color: Colors.white,),
                  backgroundColor: Colors.redAccent,
                ),
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
                          padding: const EdgeInsets.only(left: 20, top: 0.0),
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

  Widget ProjectTiles() {
    List bar;
    return FutureBuilder(
        future: Fetchsubtopics(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Data>> dataList) {
     if(firsttime){
          if(!dataList.hasData)
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
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // new
                        itemCount: subtopicsList.length,
                        itemBuilder: (context, i) {
                          print("ListView" + subtopicsList.length.toString());
//                           bar =    dataList[i]['childs'];
                              return ExpansionTile(

                              title: Text(
                                subtopicsList[i].title,
                                style:TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.red),
                              ),
                              children: <Widget>[

                                       Column(
                                        children: subtopicsList[i].contents.keys
                                            .map((String key) {
                                          return CheckboxListTile(
                                            title: new Text(
                                              "$key",
                                              style: TextStyle(
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 10.0,
                                                    color: Colors.grey,
                                                    offset: Offset(4.0, 4.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            value:subtopicsList[i].contents[key]['alue'],
                                            activeColor: Colors.pink,
                                            checkColor: Colors.white,
                                            onChanged: (bool value) {
//
          if (MainHeading.length == 6) {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(
                                  "you reached the max number of filters. remove some filters to add new ones"),
                            ));
                         }
                                              setState(() {
                                                subtopicsList[i]
                                                    .contents[key]['alue'] =
                                                    value;
                                                firsttime = false;
                                                showtext = false;

//                                                vehicles[i].contents[key][0] =
//                                                    value;
//                                                if (value) {
//                                                  MainHeading.add("$key");
//                                                } else {
//                                                  MainHeading.removeAt(i);
//                                                }
////                            if(counter==7){
//                              Scaffold.of(context).showSnackBar(new SnackBar(
//                                content: new Text("Limit is full"),
//                              ));
//                            }
                                              });
                                            },
                                          );
                                        }).toList(),

                                      )

//                                        print("End "+ subtopicsList.length.toString());
//
//                                  subtopicsList.add(
//
//                                      new Data(listresponse[i]['name'], Mainmap[i])
//                                  );
//                                        return Column(children: surveysList);

                              ],
                            );
                          })

]
                )
              ],
            ),
          );

        });
  }


  Future<List<Data>> Fetchsubtopics() async {
    if(firsttime){
    var obj = new Map<dynamic,dynamic>();
    var Mainmap = new Map<String,dynamic>();
    String url = 'https://gscrape.xeeve.com/api/config?lang=en_US';
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);
      List listresponse =json.decode(response.body)['search']['topics'];
      await listresponse.forEach((element) async {
        var Mainmap = new Map<String,dynamic>();
        await element['childs'].forEach((doc) {
          var obj = new Map<dynamic,dynamic>();

            obj['alue'] = false;
            obj['id'] = doc['id'].toString();
//                                          obj[listresponse[i]['childs']['id']] =false;
            print("TEXT VIEW" + doc.toString());
          Mainmap[doc['name']] = obj;

          print("TEXT VIEW umer" +subtopicsList.length.toString() );
        });
        await subtopicsList.add(
//
            new Data(element['name'], Mainmap)

        );
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
  }else{

    }
    }
}
