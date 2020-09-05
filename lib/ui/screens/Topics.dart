import 'dart:ui';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/ui/pages/CityDetails.dart';
import 'package:onboarding_flow/ui/pages/HomePageWithoutAppBar.dart';
import 'package:onboarding_flow/ui/pages/homepage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:search_widget/search_widget.dart';
import '../../data.dart';

class Topics extends StatefulWidget {
  bool showlogou;
  Topics(bool showlogout){

    this.showlogou=showlogout;
  }

  @override
  TopicsState createState() => new TopicsState();
}

class TopicsState extends State<Topics> {
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
  bool showeinter = true;
  bool showdistance = false;
  bool showcountery = false;
  bool showcity = false;
  bool showcontinet = false;
  List<Widget> header;
  bool searchtrue = false;
  bool distancetrue = false;
  bool subtopicstrue = false;
  bool continenttrue = false;
  bool showworld = true;
  List<Data> subtopicsList = new List();
  bool firsttime = true;
  double _lowerValue = 50;
  List<Widget> countryList = [];
  double _upperValue = 180;
  bool showtext = true;
  var obj = new Map<dynamic, dynamic>();
  var Mainmap = new Map<dynamic, dynamic>();
  var firstColor = Color(0xff141e30),
      secondColor = Color(0xff243b55);
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String CurrentTopic = "assets/topic_one.png";
  String CurrentTitle = "";
  List searchname = [];
  List Con = [];
  var Lang="en";
  List<String> clist = [];
  List<String> Continet = [];
  List<String> interList = [];
  List<String> citylist = [];
  String _selectedItem;
  List<Widget> Pages = [];
  List<Widget> Pages_two = [];
  bool _show = true;
  List<Widget> distanceList = [];
  int counterDisaple = 0;
  var currentIndex = 0;
  bool firsttimeinterest = true;
  bool searchcountryfirst = true;
  bool firsttimecities = true;
  String citysearch = "";
  bool subtopicsfetch =false;
  bool log;

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

  List GetCheckItems() {
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
  Future<bool> _NaigateBack(){
    FirebaseAuth.instance.currentUser().then((value) {
      if(value != null){

      }else{

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                WelcomeScreen())
        );
      }
    });




  }

  List getCheckednames() {
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

  Widget PageBUtton(int index, String name, String icon) {
    bool selected = false;
    var firstColor = Color(0xff5b86e5),
        secondColor = Color(0xff36d1dc);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          print("index " + index.toString());
          setState(() {
            if (index == 0) {
              currentIndex = 0;
              showeinter = true;
              showdistance = false;
              showcountery = false;
              showcity = false;
              showcontinet=false;
            }
            if (index == 1) {
              currentIndex = 3;
              showeinter = false;
              showdistance = false;
              showcountery = true;
              showcity = false;
              showworld = true;
              showcontinet=false;
            }
            if (index == 2) {
              currentIndex = 2;
              showeinter = false;
              showdistance = true;
              showcountery = false;
              showcity = false;
              showworld = true;
              showcontinet=false;
            }
            if (index == 3) {
              currentIndex = 1;
              showeinter = false;
              showdistance = false;
              showcountery = false;
              showcity = true;
              showworld = true;
              showcontinet=false;
            }
            if (index == 4) {
              currentIndex = 4;
              showeinter = false;
              showdistance = false;
              showcountery = false;
              showcity = false;
              showworld = true;
              showcontinet=true;
            }
            print("index 5 " + index.toString());
            print("index 5 " + currentIndex.toString());
            if (currentIndex == index) {
              selected = true;
            } else {
              selected = false;
            }
            print("index " + index.toString());
            print("Selected " + selected.toString());
            print("showeinter " + showeinter.toString());
            print("showdistance " + showdistance.toString());
            print("showcountery " + showcountery.toString());
            print("showcity " + showcity.toString());
            print("showworld " + showworld.toString());
          });
        },
        child: Container(
          height: 80,
          width: 80,
          child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              child: Column(
                children: <Widget>[
                  Center(
                    child: new IconButton(
                      icon: new Image.asset(icon),
                      tooltip: 'Closes application',
                    ),
                  ),
                  Center(child: Text(name))
                ],
              )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Pages.length >= 0 ? Pages.clear() : null;
    Pages.add(PageBUtton(0, "Interests", 'assets/search-interests.png'));
    Pages.add(PageBUtton(4, "Continent", 'assets/search-con.png'));
    Pages.add(PageBUtton(3, "Country", 'assets/search-nation.png'));
//    Pages.add(PageBUtton(2, "Distance", 'assets/search-distance.png'));
//    Pages.add(PageBUtton(1, "City", 'assets/search-city.png'));
    Pages_two.length >= 0 ? Pages_two.clear() : null;
//    Pages.add(PageBUtton(0, "Interests", 'assets/search-interests.png'));
//    Pages.add(PageBUtton(4, "Continent", 'assets/search-con.png'));
//    Pages.add(PageBUtton(3, "Country", 'assets/search-nation.png'));
    Pages_two.add(PageBUtton(2, "Distance", 'assets/search-distance.png'));
    Pages_two.add(PageBUtton(1, "City", 'assets/search-city.png'));
    header = [];
    List listids = getCheckboxItems();
    List listnames = getCheckboxnames();
    print("Pages Lenthgh" + Pages.length.toString());
    print("Pages Lenthgh two" + Pages_two.length.toString());
    header = getselectedheader();
    if (header.length < 1) {
      subtopicstrue = false;
    }
    print("ShowInter " + showeinter.toString());
    return WillPopScope(
      onWillPop: _NaigateBack,
      child: SingleChildScrollView(
          child:  Wrap(
              children: <Widget>[
                Container(
                  color: Color(0xfffffff),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Topics(),

                      Padding(
                        padding: const EdgeInsets.only(left:24,top:18.0),
                        child: Wrap(

                          spacing: 35,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: Pages),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:95,top:18.0),
                        child: Wrap(

                            spacing: 20,
                          alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: Pages_two),
                      ),
                      showeinter ?  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FutureBuilder(
                                    future: searchinterest(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.amber,
                                          ),
                                        ),
                                      );


                                      return SearchWidget<String>(
                                        dataList: interList.getRange(0, 111).toSet().toList(),
                                        hideSearchBoxWhenItemSelected: false,
                                        listContainerHeight: MediaQuery
                                            .of(context)
                                            .size
                                            .height / 4,
                                        queryBuilder: (query, list) {
                                          return list
                                              .where((item) =>
                                              item
                                                  .toLowerCase()
                                                  .startsWith(query.toLowerCase()))
                                              .toList();
                                        },
                                        popupListItemBuilder: (item) {
                                          String result;
                                          if(item.contains("?")){
                                            result = item.substring(0, item.indexOf('?'));
                                          }else{
                                            result=item;
                                          }

                                          return PopupListItemWidget(result);
                                        },
                                        selectedItemBuilder: (selectedItem,
                                            deleteSelectedItem) {
//                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
                                        },
                                        // widget customization
                                        noItemsFoundWidget: NoItemsFound(),
                                        textFieldBuilder: (controller, focusNode) {
                                          return MyTextField(controller, focusNode,
                                              "Type a interest...");
                                        },
                                        onItemSelected: (item) {


                                          var index = item.substring(item.length - 1,item.length);
                                          int indexint=int.parse(index);
                                          print("index final "+indexint.toString());

                                          Fluttertoast.showToast(
                                              msg: "Destinations Updated",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          _sendanalyticsSubtopics(item);
                                          setState(() {
                                            print("indexint"+ indexint.toString());
                                            showSubtopics=false;

                                            if(indexint==0){
                                              CurrentTitle = "Culture";
                                              CurrentTopic = "assets/topic_one.png";
                                            }
                                            if(indexint==1){
                                              CurrentTitle = "Fun / kids";
                                              CurrentTopic = "assets/topic_two.png";
                                            }
                                            if(indexint==2){
                                              CurrentTitle = "Nature";
                                              CurrentTopic = "assets/topic_three.png";
                                            }
                                            if(indexint==3){
                                              CurrentTitle = "Nightlife";
                                              CurrentTopic = "assets/topic_four.png";
                                            }
                                            if(indexint==4){
                                              CurrentTitle = "Sport";
                                              CurrentTopic = "assets/topic_fie.png";
                                            }
                                            if(indexint==5){
                                              CurrentTitle = "Wellness";
                                              CurrentTopic = "assets/topic_six.png";
                                            }
                                            if (getselectedheader().length >6) {
                                              Scaffold.of(context).showSnackBar(new SnackBar(
                                                content: new Text(
                                                    "you reached the max number of filters. remove some filters to add new ones"),
                                              ));
                                            }else {
                                              firsttime = true;
                                              Future.delayed(const Duration(milliseconds: 2000), () {
                                                String result;
                                                if(item.contains("?")) {
                                                  result    = item.substring(
                                                      0, item.indexOf('?'));
                                                }else{
                                                  result=item;
                                                }
                                                setState(() {
                                                  subtopicstrue = true;

                                                  subtopicsList[indexint].contents[result]['alue'] =
                                                  true;
                                                });
                                              });
                                            }


                                          });
                                          _sendanalyticsSubtopics(item);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Wrap(
                            children: <Widget>[
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: distanceList),
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: countryList)
                            ],
                          ),

                        ],
                      ):
//                    Padding(
//                      padding: const EdgeInsets.only(top:18.0),
//                      child: Text("Select Topic from above first",
//                        style: TextStyle(
//                            fontSize: 15, fontWeight: FontWeight.bold)),
//                    )
                          Container(),
//                      header.length>0?   Padding(
//                        padding: const EdgeInsets.only(
//                            left: 34, right: 10, top: 8.0),
//                        child: Text(
//                          "YOUR INTERESTS::".toUpperCase(),
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                              fontSize: 15, fontWeight: FontWeight.bold),
//                        ),
//                      ):Container(),
                      showeinter ?      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: header):Container(),
                      showworld ? WorlSearch() : Container()
                    ],
                  ),
                ),
                HomePageWithoutAppbar(
                    listids,
                    listnames,
                    searchname,
                    Con,
                    searchtrue,
                    distancetrue,
                    subtopicstrue,
                    continenttrue,
                    _lowerValue,
                widget.showlogou),
              ],
            )



      ),
    );
  }

  @override
  void initState() {


    var arr = ['it','es','fr','de','zh','it','ru','ja','en'];
    print( "TimeZone " +ui.window.locale.languageCode);
    if(arr.contains(ui.window.locale.languageCode)){
      Lang = ui.window.locale.languageCode;
    }else{
      Lang = "en";
    }

    Fetchsubtopics().then((value) {

    }

    );
  }

  Column Topics() {
    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              showSubtopics ? UnSelect() : Select(),
                            ],
                          ),
//
                        ],
                      );
  }

  Padding WorlSearch() {
    print("WorlSearch showeinter " + showeinter.toString());
    print("WorlSearch showdistance " + showdistance.toString());
    print("WorlSearch showcountery " + showcountery.toString());
    print("WorlSearch showcity " + showcity.toString());
    print(" WorlSearch showworld " + showworld.toString());
    print(" WorlSearch showcontinet " + showcontinet.toString());

    Continet.add("Africa");
    Continet.add("Asia");
    Continet.add("Antarctica");
    Continet.add("Europe");
    Continet.add("North america");
    Continet.add("Oceania");
    Continet.add("South America");

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
//            Search By Country
          showcity ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    FutureBuilder(
                      future: searchcountry(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.amber,
                            ),
                          ),
                        );
                        return SearchWidget<String>(
                          dataList: citylist.toSet().toList(),
                          hideSearchBoxWhenItemSelected: false,
                          listContainerHeight: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          queryBuilder: (query, list) {
                            return list
                                .where((item) =>
                                item
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()))
                                .toList();
                          },
                          popupListItemBuilder: (item) {
                            return PopupListItemWidget(item);
                          },
                          selectedItemBuilder: (selectedItem,
                              deleteSelectedItem) {
//                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
                          },
                          // widget customization
                          noItemsFoundWidget: NoItemsFound(),
                          textFieldBuilder: (controller, focusNode) {
                            return MyTextField(
                                controller, focusNode, "Type a country...");
                          },
                          onItemSelected: (item) {
                            setState(() {
                              if (searchname.length >= 6) {
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text(
                                      "you reached the max number of filters. remove some filters to add new ones"),
                                ));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Destinations Updated",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                _sendAnalyticsFilter();
                                print("Umer selected");



                                setState(() {
_selectedItem=item;
                                  searchtrue = true;
                                  showtext = false;
                                  searchname.add(
                                      _selectedItem);
                                  countryList.add(selectedtopic(
                                      countryList.length, _selectedItem));

                                });

                              }
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Wrap(
                children: <Widget>[
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: distanceList),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: countryList)
                ],
              ),
              header.length > 0 ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 10, top: 18.0),
                    child: Text(
                      "YOUR INTERESTS:".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: header),
                ],
              ) : Container()
            ],
          ) : Container(),
          showcountery ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    FutureBuilder(
                      future: Fetchcities(),
                      builder: (context, snapshot) {
                        print("Size : " + citysearch.length.toString());
                        return SearchWidget<String>(
                          dataList: clist.toSet().toList(),
                          hideSearchBoxWhenItemSelected: false,
                          listContainerHeight: citysearch.length > 2
                              ? MediaQuery
                              .of(context)
                              .size
                              .height / 4
                              : 0,
                          queryBuilder: (query, list) {
                            return list
                                .where((item) =>
                                item
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()))
                                .toList();
                          },
                          popupListItemBuilder: (item) {
                            return PopupListItemWidget(item);
                          },
                          selectedItemBuilder: (selectedItem,
                              deleteSelectedItem) {
//                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
                          },
                          // widget customization
                          noItemsFoundWidget: Center(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Click on search to show results"),
                       new Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.black,
                        ),

                                  ],),
                              ),
                          ),
//                          noItemsFoundWidget: SizedBox(
//                            height: 20,
//                              width: 20,
//                              child: CircularProgressIndicator(
// backgroundColor: Colors.amber,
//                              )),
                          textFieldBuilder: (controller, focusNode) {
                            controller.addListener(() {
                              if (controller.text.length > 2) {
                                setState(() {
                                  firsttimecities = true;
                                  citysearch = controller.text;
                                  print("controller " + controller.text);
                                  return MyTextField(
                                      controller, focusNode, "Type a city and click on search...");
                                });
                              } else {
                                setState(() {
                                  citysearch = "a";
                                  return MyTextField(
                                      controller, focusNode, "Type a city  click on search...");
                                });
                              }
                            });
                            return MyTextField(
                                controller, focusNode, "Type a city and click on search...");
                          },
                          onItemSelected: (item) {
                            String result = item.substring(0, item.indexOf(','));
                           List l1=[];
                           List l2=[];
                            Map<String, dynamic> places;
                            Fetchcitiesdetail(result.replaceAll(" ", "%20")).then((value) {
                              print("Sorry no result "+ value.toString());
                                for(int i =0;i<value.length;i++){

                                  if(value[i]['info']['name']==result){
                                    places=value[i];
                                  }
                                }
                             if(places!=null) {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) =>
                                       DetailPage(l1, l2,
                                           places, true,widget.showlogou))

                               );
                             }else{
                               print("Sorry");
                               Fluttertoast.showToast(
                                   msg: "Sorry city is not exist!",
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.BOTTOM,
                                   timeInSecForIosWeb: 1,
                                   backgroundColor: Colors.green,
                                   textColor: Colors.white,
                                   fontSize: 16.0
                               );
                             }
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Wrap(
                children: <Widget>[
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: distanceList),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: countryList)
                ],
              ),
              header.length > 0 ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 34, right: 10, top: 18.0),
                    child: Text(
                      "YOUR INTERESTS:".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: header),
                ],
              ) : Container(),
            ],
          ) : Container(),
          showcontinet ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    SearchWidget<String>(
                      dataList: Continet.toSet().toList(),
                      hideSearchBoxWhenItemSelected: false,
                         listContainerHeight: MediaQuery
        .of(context)
        .size
        .height / 4,
                      queryBuilder: (query, list) {
                        return list
                            .where((item) =>
                            item
                                .toLowerCase()
                                .startsWith(query.toLowerCase()))
                            .toList();
                      },
                      popupListItemBuilder: (item) {
                        return PopupListItemWidget(item);
                      },
                      selectedItemBuilder: (selectedItem,
                          deleteSelectedItem) {
//                  return SelectedItemWidget(selectedItem, deleteSelectedItem);
                      },
                      // widget customization
                      noItemsFoundWidget: Center(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Click on search to show results"),
                              new Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.black,
                              ),

                            ],),
                        ),
                      ),
//                          noItemsFoundWidget: SizedBox(
//                            height: 20,
//                              width: 20,
//                              child: CircularProgressIndicator(
// backgroundColor: Colors.amber,
//                              )),
                      textFieldBuilder: (controller, focusNode) {

                        return MyTextField(
                            controller, focusNode, "Select continent");
                      },
                      onItemSelected: (item) {
                        setState(() {
                          if (searchname.length >= 6) {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(
                                  "you reached the max number of filters. remove some filters to add new ones"),
                            ));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Destinations Updated",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            _sendAnalyticsFilter();
                            print("Umer selected");
                            if(item=="Africa"){
                              _selectedItem="AF";
                            }
                            if(item=="Asia"){
                              _selectedItem="AS";
                            }
                            if(item=="Antarctica"){
                              _selectedItem="AN";
                            }
                            if(item=="Europe"){
                              _selectedItem="EU";
                            }
                            if(item=="North america"){
                              _selectedItem="NA";
                            }
                            if(item=="Oceania"){
                              _selectedItem="OC";
                            }
                            if(item=="South America"){
                              _selectedItem="SA";
                            }
                            setState(() {

                              continenttrue = true;
                              showtext = false;
                              Con.add(
                                  _selectedItem);
                              countryList.add(selectedtopic(
                                  countryList.length, item));

                            });

                          }
                        });
                      },
                    )
                  ],
                ),
              ),
              Wrap(
                children: <Widget>[
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: distanceList),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: countryList)
                ],
              ),
              header.length > 0 ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 34, right: 10, top: 18.0),
                    child: Text(
                      "YOUR INTERESTS:".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: header),
                ],
              ) : Container(),
            ],
          ) : Container(),
          showdistance ? Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(child: Text(
                      "0 Km                                            800 Km",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 50, right: 50),
                    alignment: Alignment.centerLeft,
                    child: FlutterSlider(
                      values: [0],
                      max: 800,
                      min: 0,
                      rtl: false,
                      visibleTouchArea: false,
                      onDragging: (handlerIndex, lowerValue, upperValue) async {
                        if (await Permission.location.isGranted) {
                          _lowerValue = lowerValue;
                          _upperValue = upperValue;
                          print("Distance lower" + _lowerValue.toString());
                          print("Distance Higher" + _upperValue.toString());
                          distanceList.clear();
                          distanceList.add(selectedTopicsForHeader(
                              false, 1, _lowerValue.toString() + " Km"));
//                  Fluttertoast.showToast(
//                      msg: "Destinations Updated",
//                      toastLength: Toast.LENGTH_SHORT,
//                      gravity: ToastGravity.BOTTOM,
//                      timeInSecForIosWeb: 1,
//                      backgroundColor: Colors.green,
//                      textColor: Colors.white,
//                      fontSize: 16.0
//                  );
                          _sendAnalyticsDistance();
                          setState(() {
                            showtext = false;
                            distancetrue = true;
                          });
                        } else {
                          if (distanceList.length > 0) {
                            distanceList.clear();
                          }
                          bool isAndroid = Theme
                              .of(context)
                              .platform == TargetPlatform.android;
                          if (counterDisaple == 2) {
                            if (isAndroid) {
                              final AndroidIntent intent = AndroidIntent(
                                action: 'action_application_details_settings',
                                data: 'package:trip.travelplanner.vacationholiday', // replace com.example.app with your applicationId
                              );
                              await intent.launch();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("OK", style: (TextStyle(
                                                color: Colors.blue
                                            )),),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Map<Permission,
                                                  PermissionStatus> statuses = await [
                                                Permission.location,
                                              ].request();
                                            },
                                          )
                                        ],
                                        title: Text("Need Permission"),
                                        content: Text(
                                            "Travel planner needs to Know your location in order to show you near cities. Do you want to give permission?"),
                                      ));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK", style: (TextStyle(
                                              color: Colors.blue
                                          )),),
                                          onPressed: () async {
                                            counterDisaple++;
                                            Navigator.pop(context);
                                            Map<Permission,
                                                PermissionStatus> statuses = await [
                                              Permission.location,
                                            ].request();
                                          },
                                        )
                                      ],
                                      title: Text("Need Permission"),
                                      content: Text(
                                          "Travel planner needs to Know your location in order to show you near cities. Do you want to give permission?"),
                                    ));
                          }
                        }
//                    showDialog(
//                        context: context,
//                        builder: (context) => AlertDialog(
//                          actions: <Widget>[
//                        FlatButton(
//                        child: Text("OK",style: (TextStyle(
//                          color: Colors.blue
//                        )),),
//                      onPressed: () async {
//                        Navigator.pop(context);
//                        Map<Permission, PermissionStatus> statuses = await [
//                    Permission.location,
//                  ].request();
//                      },
//                    )
//                          ],
//                          title: Text("Need Permission"),
//                          content: Text("Travel planner needs to Know your location in order to show you near cities. Do you want to give permission?"),
//                        ));
//                  }
                      },
                    ),
                  ),
                  Wrap(

                    children: <Widget>[
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: distanceList),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: countryList)
                    ],
                  ),
                  header.length > 0 ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 34, right: 10, top: 18.0),
                        child: Text(
                          "YOUR INTERESTS:".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: header),
                    ],
                  ) : Container(),
                ],
              )
            ],
          ) : Container(),
        ],
      ),
    );
  }

  Future<void> _sendanalyticsSubtopics(String name) async {
    await analytics.logEvent(
      name: 'home_topic_$name',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }
  Future<List<dynamic>> Fetchcitiesdetail(String value) async {

    var obj = new Map<dynamic, dynamic>();
    var Mainmap = new Map<String, dynamic>();
    String url = "http://gscrape.xeeve.com/api/searchcity?lang="+Lang+"&input=" +
        value;
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("citiesname Response : " + response.body);
    List listresponse = json.decode(response.body)['result']['cities'];
    if (clist.length > 0) {
      clist.clear();
    }
    await listresponse.forEach((element) async {
      var Mainmap = new Map<String, dynamic>();
      clist.add(element['info']['name']);
      print("citiesname " + element['info']['name']);
    });
    print("cities " + clist.length.toString());
    firsttimecities = false;
    return listresponse;
    return json.decode(response.body);

  }
  Future<void> _sendAnalyticsDistance() async {
    await analytics.logEvent(
      name: 'home_distancefilter',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Future<void> _sendAnalyticsFilter() async {
    await analytics.logEvent(
      name: 'home_countryfilter',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Widget CheckBoxList() {
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
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Wrap(children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // new
                    itemCount: subtopicsList.length,
                    itemBuilder: (context, i) {
                      var counter = 0;
                      print("ListView" + subtopicsList[i].title);
                      print("CurrentTitle" + CurrentTitle);
                      List words = [];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subtopicsList[i].title == CurrentTitle
                            ? subtopicsList[i].contents.keys.map((String key) {
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
          if (getselectedheader().length >6) {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(
                                  "you reached the max number of filters. remove some filters to add new ones"),
                            ));
                        }else{
            Fluttertoast.showToast(
                msg: "Destinations Updated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
            _sendanalyticsSubtopics(key);
            setState(() {
              subtopicstrue = true;
              showSubtopics=false;
              showtext = false;
              subtopicsList[i].contents[key]['alue'] =
                  value;
              firsttime = false;
//                              showtext = false;
            });
            _sendanalyticsSubtopics(key);
          }

                            },
                          );
                        }).toList()
                            : words
                            .map<Widget>(
                                (word) => Container(child: Text(word)))
                            .toList(),
                      );
                    })
              ]),
            ),
          );
        });
  }

  Future<List<Data>> searchinterest() async {
    if (firsttimeinterest) {
      String url = 'https://gscrape.xeeve.com/api/config?lang='+Lang;
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
      final response = await http.get(url);
      print("URL : " + url);
      if (response.statusCode == 200) {
        print("Response : umer" + response.body);
        List listresponse = json.decode(response.body)['search']['topics'];
        var counter=-1;

        if(interList.length>0){
          interList.clear();
        }
        print("Interlist size real "+interList.length.toString());
        await listresponse.forEach((element) async {
           counter++;
          await element['childs'].forEach((doc) {
            var obj = new Map<dynamic, dynamic>();
            obj['alue'] = false;
            obj['id'] = doc['id'].toString();
//                                          obj[listresponse[i]['childs']['id']] =false;
            print("TEXT VIEW" + doc.toString());
            interList.add(doc['name']+"?"+counter.toString());
            print("InterList " + doc['name'].toString());
          });
        });
        firsttimeinterest = false;
        return subtopicsList;
      } else {
        print("Failed to load album " + url);
        throw Exception('Failed to load album');
      }
    } else {
      return subtopicsList;
    }
  }

  Future<List<Data>> Fetchsubtopics() async {
    if (firsttime) {
      var obj = new Map<dynamic, dynamic>();
      var Mainmap = new Map<String, dynamic>();
      String url = 'https://gscrape.xeeve.com/api/config?lang='+Lang;
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
            interList.add(doc['name']);
            print("InterList " + doc['name'].toString());
            Mainmap[doc['name']] = obj;
            print("TEXT VIEW umer" + subtopicsList.length.toString());
          });
          await subtopicsList.add(
              new Data(element['name'], Mainmap));
        });
        List conteryresponse = json.decode(response.body)['geo']['countries'];
        await conteryresponse.forEach((element) async {
          citylist.add(element['name']);
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
    } else {
      return subtopicsList;
    }
  }

  Future<List<Data>> Fetchcities() async {
    if (firsttimecities) {
      var obj = new Map<dynamic, dynamic>();
      var Mainmap = new Map<String, dynamic>();
      String url = "http://gscrape.xeeve.com/api/searchcity?lang="+Lang+"&input=" +
      citysearch;
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
      final response = await http.get(url);
      print("URL : " + url);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("citiesname Response : " + response.body);
      if (clist.length > 0) {
        clist.clear();
      }
      List listresponse = json.decode(response.body)['result']['cities'];

      await listresponse.forEach((element) async {
        var Mainmap = new Map<String, dynamic>();
        print("Country umer"+ element['country']['name'].toString());
        if(element["levels"]!=null) {
          clist.add(element['info']['name'].toString() + ", " +
              element['levels']['2']['name'].toString() + ", " +
              element['country']['name'].toString());
        }else{
          clist.add(element['info']['name'].toString() + ", " +
              element['country']['name'].toString());
        }



      });
      print("city h"+clist[0]);
      firsttimecities = false;
      return subtopicsList;
      return json.decode(response.body);
    } else {
      return subtopicsList;
    }
  }

  Future<List<Data>> searchcountry() async {
    if (searchcountryfirst) {
      String url = 'https://gscrape.xeeve.com/api/config?lang='+Lang;
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
      final response = await http.get(url);
      print("URL : " + url);
      if (response.statusCode == 200) {
        List listresponse = json.decode(response.body)['search']['topics'];
        await listresponse.forEach((element) async {
          var Mainmap = new Map<String, dynamic>();
          await element['childs'].forEach((doc) {
            var obj = new Map<dynamic, dynamic>();
            obj['alue'] = false;
            obj['id'] = doc['id'].toString();
//                                          obj[listresponse[i]['childs']['id']] =false;
          });
          List conteryresponse = json.decode(response.body)['geo']['countries'];
          await conteryresponse.forEach((element) async {
            citylist.add(element['name']);
          });
          print("citylist " + citylist.length.toString());
          searchcountryfirst = false;





        });
        subtopicsfetch=true;
        return subtopicsList;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print("Failed to load album " + url);
        throw Exception('Failed to load album');
      }
    } else {
      return subtopicsList;
    }
  }

  Widget UnSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showSubtopics = false;
//                header.add(Padding(
//                    padding: const EdgeInsets.all(12.0),
//                    child: Image(
//                      image: AssetImage("assets/plus.png"),
//                      width: 30,
//                      height: 30,
//                    )));
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
            IconButton(
              onPressed: () {
                setState(() {
                  showSubtopics = false;
//                header.add(Padding(
//                    padding: const EdgeInsets.all(12.0),
//                    child: Image(
//                      image: AssetImage("assets/plus.png"),
//                      width: 30,
//                      height: 30,
//                    )));
                });
              },
              icon: new Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        ),
        Container(height: 250, child: CheckBoxList()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_one.png";
                            CurrentTitle = "Culture";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_two.png";
                            CurrentTitle = "Fun / kids";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_three.png";
                            CurrentTitle = "Nature";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_four.png";
                            CurrentTitle = "Nightlife";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_fie.png";
                            CurrentTitle = "Sport";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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
                        onTap: () {
                          setState(() {
                            showSubtopics = false;
                            CurrentTopic = "assets/topic_six.png";
                            CurrentTitle = "Wellness";
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1,
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

  Widget selectedTopicsForHeader(bool showicon, int i, String name) {
    return Padding(
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
          width: name.length <= 6 ? 100 : name.length <= 9 ? 120 : 190,
          decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  showicon ? IconButton(
                      icon: new Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          subtopicsList[i].contents[name]['alue'] = false;
                        });
                      }) : IconButton(
                      icon: new Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        print("DistanceListClear");
                        setState(() {
                          distancetrue = false;
                          distanceList.clear();
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_one.png";
                        CurrentTitle = "Culture";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 1,
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_two.png";
                        CurrentTitle = "Fun / kids";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 1,
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_three.png";
                        CurrentTitle = "Nature";
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 1,
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_four.png";
                        CurrentTitle = "Nightlife";
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_fie.png";
                        CurrentTitle = "Sport";
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
                    onTap: () {
                      setState(() {
                        showSubtopics = true;
                        CurrentTopic = "assets/topic_six.png";
                        CurrentTitle = "Wellness";
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

  Widget selectedtopic(i, String name) {
    return Padding(
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
          width: name.length <= 6 ? 90 : name.length <= 9 ? 130 : 160,
          decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  IconButton(
                      icon: new Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (countryList.length <= 1) {
                            countryList.clear();
                            searchname.clear();
                            Con.clear();
                            searchtrue = false;
                          } else {
                            countryList.removeAt(i);
                            searchname.removeAt(i);
                            Con.clear();
                          }
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getselectedheader() {
    var tmpArray = [];
    List<Widget> header2 = [];
    for (int i = 0; i < subtopicsList.length; i++) {
      subtopicsList[i].contents.forEach((key, value) {
        if (subtopicsList[i].contents[key]['alue'] == true) {
          header2.add(selectedTopicsForHeader(true, i, key));
        }
      });
    }
    return header2;
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
    const MyTextField(this.controller, this.focusNode, this.text);

    final TextEditingController controller;
    final FocusNode focusNode;
    final String text;

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x4437474F),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme
                  .of(context)
                  .primaryColor),
            ),
            suffixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: text,
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
  final String item;
  @override
  Widget build(BuildContext context) {
  return Container(
  padding: const EdgeInsets.all(12),
  child: Text(
  item,
  style: const TextStyle(fontSize: 16),
  ),
  );
  }
  }

