import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/ui/model/city.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:onboarding_flow/ui/model/CityDetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:onboarding_flow/ui/screens/UserLike.dart';
import 'package:onboarding_flow/ui/screens/sign_in_screen.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';
import 'Serpiew.dart';
import 'main.dart';

class DetailPage extends StatefulWidget {
  List<dynamic> list;
  List<dynamic> list2;
  List<dynamic> tempids;
  List<dynamic> tempnames;
  Map<String, dynamic> places;
 bool shoeheart;
  DetailPage(List<dynamic> list, List<dynamic> list2,
      Map<String, dynamic> places, bool str) {
    this.list = list;
    this.list2 = list2;
    this.places = places;
    this.shoeheart=str;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DetailPage> {
  int _selectedIndex = 0;
  final List<City> _allCities = City.allCities();
  Future<CityModel> futureAlbum;
  bool shouldExpand = false;
  String expandText = 'Details';
  final LatLng _center = const LatLng(45.521563, -122.677433);
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  FirebaseAnalytics analytics = FirebaseAnalytics();
  Future<void> _sendAnalyticsEvent(String name) async {

    await analytics.logEvent(
      name: 'CityDetailsPage',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage':"yes",

      },
    );
  }

  @override
  void initState() {
    _sendAnalyticsEvent("");
  }

  @override
  Widget build(BuildContext context) {
    var lat = widget.places['latitude'];
    var long = widget.places['longitude'];
    var longdouble = double.parse(long);
    double latdouble = double.parse(lat);
    String id =widget.places["id"];
    return new Scaffold(

        appBar: new AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: SizedBox(
                width:40,
                height:40,
                child: Image(

                  image:   AssetImage("assets/newicon.png") ,
                ),
              ),
            )

          ],
          title: new Text(
              widget.list2.length > 2 ?
              "Cities for " + "" + widget.list2[0] + ", " + widget.list2[1] +
                  " " + widget.list2[2]
                  : widget.list2.length > 1 ? "Cities for " + "" +
                  widget.list2[0] + ", " + widget.list2[1] :
              "Cities for " + "" + widget.list2[0],
              style: new TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body:SingleChildScrollView(
          child: Container(
            child: Column(
                children: <Widget>[
                  getHomePageBody(context),
                  Padding(
                      padding: const EdgeInsets.only(left:4,right: 4.0),
                      child: new Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.hardEdge,
                          elevation: 20,
                      child: Container(
                        color: Colors.white,
                          height: 300,
                          child: GestureDetector(
                            child: GoogleMap(
                              rotateGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latdouble, longdouble),
                                zoom: 12.0,
                              ),
//
                              onTap: (LatLng pos) {
//                                Navigator.push(
//                                   context,
//                                    MaterialPageRoute(builder: (context) =>
//                                          HomeDetails(pos.latitude,pos.longitude, widget
//                                            .places["info"]
//                                        ['name'].toString()))
//                                );
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                    MaterialPageRoute(builder: (context) =>
                                          HomeDetails(widget.list,widget.list2,widget.places,pos.latitude,pos.longitude, widget
                                            .places["info"]
                                       ['name'].toString()))
                                );
                              },
                            ),
                          )
                      )

                  )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: new Text(widget.list2.length > 2 ?
                      "Near cities for " + "" + widget.list2[0] + ", " + widget.list2[1] +
                          " " + widget.list2[2]
                          : widget.list2.length > 1 ? "Near cities for " + "" +
                          widget.list2[0] + ", " + widget.list2[1] :
                      "Near cities for " + "" + widget.list2[0]
                          ,
                           textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ),
                  getNearPlaces(context,id)

                ]

            ),
          ),
        )
    );
  }

  _toggleShouldExpand() {
    setState(() {
      shouldExpand = !shouldExpand;
      expandText = shouldExpand ? 'Close' : 'Details';
    });
  }
  var firstColor = Color(0xff5b86e5),
      secondColor = Color(0xff36d1dc);
  getHomePageBody(BuildContext context) {
    print("Details umer :" + widget.places.toString());

    var lat = widget.places['latitude'];
    var long = widget.places['longitude'];
    var longdouble = double.parse(long);
    double latdouble = double.parse(lat);
    CityDetail detail;
    detail =
        CityDetail.fromJson(widget.places["details"]);
    String id =widget.places["id"];
    return SingleChildScrollView(
      child: Container(

          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 20,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 220,
                    maxWidth: double.infinity,
                    maxHeight: 220,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),


                    ),
                    child: Hero(
                      tag: detail.image,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: detail.image,
                            placeholder: (context, url) =>
                                Center(
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        child:
                                        CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Container(

                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[

                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:0.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:18.0),
                            child: Center(
                              child: new Text(
                                  widget.places["info"]
                                  ['name'],
                                  style: new TextStyle(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                          ),

                          Center(
                            child: new Text(
                                widget.places["country"]
                                ['name'],
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),


                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                         widget.tempids = widget.list;
                         widget.tempnames = widget.list2;
                        checkcities(widget.places['info']['name']).then((value) =>

                            sendJSONtoFireStore(widget.places,widget.tempids,widget.tempnames, value  )
                        );





                      },
                      child: widget.shoeheart?Align(
                        alignment:Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top:5,left:0.0,right: 5),
                          child: Icon(Icons.favorite,
                            size:50,color: Colors.red,),
                        ),
                      ):Container()
                    ),
                  ],
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: new Text(
                        widget.places["info"]
                        ['name'] + " is a city in " + widget.places["country"]
                        ['name'] + " , with a population of about " +
                            widget.places["info"]
                            ['population'].toString() +
                            " inhabitants.Find below more information about "
                            + widget.places["info"]
                        ['name'].toString() + ".",
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ),
                ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: new Text(
                              "See details for:" ,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        getSERPgetSERPdetails(context, id),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: new Text(
                               "See images for:" ,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        getSERPgetSERP(context, id),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: new Text(
                                "Other things to do in "+ widget.places["info"]
                                ['name'].toString() ,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        getTopics(context,id),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: new Text(
                        "Information about " + widget.places["info"]
                        ['name'] + " (" + widget.places["info"]
                        ['name'] + ")",
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                      detail.shortDes,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 16.0),
                      maxLines: shouldExpand ? null : 1
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: OutlineButton(
                      child: Text(expandText),
                      onPressed: _toggleShouldExpand,
                    ),
                  ),
                ),


//                Center(
//                  child: Padding(
//                      padding: const EdgeInsets.only(right: 0.0),
//                      child:
//
//                  NiceButton(
//                  radius: 10,
//                  padding: const EdgeInsets.all(15),
//                  text: "Show Map",
//                  icon: Icons.map,
//                  gradientColors: [secondColor, firstColor],
//                  onPressed: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) =>
//                            HomeDetails(latdouble, longdouble, widget.places["info"]
//                            ['name'].toString()))
//
//                    );
//                  },
//              )
//
//
//          ),
//                ),
//                                          Padding(
//                                            padding: const EdgeInsets.all(4.0),
//                                            child: Center(
//                                              child: new Text(
//                                                  widget.list2.length>2?
//                                                  "#"+widget.list2[0]+" #"+widget.list2[1]+" #"+widget.list2[2]
//                                                      : widget.list2.length>2?"#"+widget.list2[0]+" #"+widget.list2[1]:
//                                                  "#"+widget.list2[0] ,
//                                                  style: new TextStyle(
//                                                      fontSize: 20.0,
//                                                      fontWeight: FontWeight.bold,
//                                                      color: Colors.black)),
//                                            ),
//                                          ),


//                                      new Text(
//                                          'Population: ${snapshot.data.places[i]["info"]['population']}',
//                                          style: new TextStyle(
//                                              fontSize: 15.0,
//                                              fontWeight: FontWeight.bold)),
          ]),
    ),
    ),
    ],
    )),
    ),
    ),
    );

  }
  sendDatatoFireStore(String country , String city , String image ) async{
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    if(u != null) {
      Firestore.instance
          .collection("USERS")
          .document(u.uid)
          .collection("Favrite")
          .document()
          .setData({
        'country': country,
        "city": city,
        "image": image
      });
    }else{

      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
            "To Save you hae to Login first"),
      ));

    }
  }
  sendJSONtoFireStore(Map<String, dynamic> places, List<dynamic> list1, List<dynamic> list2, String document ) async{
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();


    var FinalList1 = list1.toSet().toList();
    var FinalList2 = list2.toSet().toList();
    print("Curren list ids"+FinalList1.toString());
    print("Curren list names"+FinalList2.toString());
    Map<dynamic , String>   listnames = new Map<dynamic,String>();
    Map<dynamic , String>   listids = new Map<dynamic,String>();
        for(int i=0;i<FinalList1.length;i++){

          listnames[i.toString()]=FinalList2[i].toString();
          listids[i.toString()]=FinalList1[i].toString();
        }
        places['subtopicname']=listnames;
    places['subtopicid']=listids;
    places['city']=places['info']['name'];

    if(u!= null) {
      print("Curren Doc "+document);
      if(document=="noDocument"){
        Firestore.instance
            .collection("USERS")
            .document(u.uid)
            .collection("Favrite")
            .document()
            .setData(
            places
        );
      }else{
        Firestore.instance
            .collection("USERS")
            .document(u.uid)
            .collection("Favrite")
            .document(document)
            .updateData(
            places
        );
      }


      showAlertDialog(context,"Trip saved. Would you like to go to your Saved Trips page?",true);

    }else{

      Fluttertoast.showToast(
          msg: "You must be logged in to save your trip.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Future.delayed(const Duration(milliseconds: 1000), () {

// Here you can write your code
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                WelcomeScreen())
        );
      });



    }
  }
  getSERPgetSERP(BuildContext context,String id) {
      double hieght = widget.list2.length*40.toDouble();
          return Container(
           height: 50,

            child: ListView.builder(
                itemCount: widget.list2.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int i) {

                  return Container(
height: 70,


                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:10,left:12.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        HomeDetailsserp(widget.list,widget.list2,widget.places,0.0, widget.list2[i], widget
                                            .places["info"]
                                        ['name'].toString(),"&tbm=isch"))
                                );
                              },
                              child: Container(

                                child: new Text(
//                                    widget.list2[i]+" near "+widget.places["info"]['name'].toString(),
                                  widget.list2[i],
                                    style: new TextStyle(
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.grey,
                                            offset: Offset(1.0,1.0),
                                          ),
                                        ],
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange)),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                  );
                }),
          );

  }
  getSERPgetSERPdetails(BuildContext context,String id) {
    double hieght = widget.list2.length*40.toDouble();
    return Container(
      height: 50,

      child: ListView.builder(
          itemCount: widget.list2.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int i) {

            return Container(
              height: 70,


              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:10,left:12.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  HomeDetailsserp(widget.list,widget.list2,widget.places,0.0, widget.list2[i], widget
                                      .places["info"]
                                  ['name'].toString(),""))
                          );
                        },
                        child: Container(

                          child: new Text(
//                              widget.list2[i]+" near "+widget.places["info"]['name'].toString(),
                            widget.list2[i],
                              style: new TextStyle(
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.grey,
                                      offset: Offset(1.0,1.0),
                                    ),
                                  ],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ),
                      ),
                    ),
                  ],

                ),
              ),
            );
          }),
    );

  }
  getTopics(BuildContext context,String id) {
    return FutureBuilder(
        future: fetchTopics(id), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(

                child: Container(
                  height: 20,
                    width: 20,
                    child: CircularProgressIndicator()),
              ),
            );
          final List topics =snapshot.data['result']['topics'] ;
          print("Topics: "+topics.length.toString());
          return Container(
            height: 70,

            child: ListView.builder(
                itemCount: topics.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int i) {

                  return Container(
height: 40,
                    width: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:12.0),
                            child: Container(
                              width: 150,
                              child: Center(
                                child: new Text(
                                   topics[i]["name"].toString(),

                                    style: new TextStyle(
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.grey,
                                            offset: Offset(1.0,1.0),
                                          ),
                                        ],
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                  );
                }),
          );
        });
  }
  getNearPlaces(BuildContext context,String id) {
    return FutureBuilder(
        future: fecthnearplaces(id), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          List Near = snapshot.data['result']['near'];
          print("Near "+Near.length.toString());
          return Container(
            height: 150,
            child: ListView.builder(
                itemCount: Near.length,
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  CityDetail detail;
                  detail =
                      CityDetail.fromJson(Near[i]["details"]);
                  return Wrap(
                    children: <Widget>[

                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  DetailPage(
                                      widget.list, widget.list2,   Near[i],
                                      true))

                          );
                        },
                        child: Container(

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 20,
                                child: Stack(

                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 120,
                                              minHeight: 120,
                                              maxWidth: 120,
                                              maxHeight: 120,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft: Radius.circular(8.0),


                                              ),
                                              child: Hero(
                                                tag: detail.image,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: detail.image,
                                                      placeholder: (context, url) => Center(
                                                          child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              child:
                                                              CircularProgressIndicator())),
                                                      errorWidget: (context, url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(left:12.0),
                                          child: Container(
                                            child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                       Near[i]["info"]
                                                        ['name'],
                                                        style: new TextStyle(
                                                            fontSize: 23.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.red)),
                                                  ),
                                                  Center(
                                                    child: new Text(
                                                        Near[i]["country"]
                                                        ['name'],
                                                        style: new TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight: FontWeight.normal,
                                                            color: Colors.grey)),
                                                  ),



//                                          Padding(
//                                            padding: const EdgeInsets.all(4.0),
//                                            child: Center(
//                                              child: new Text(
//                                                  widget.list2.length>2?
//                                                  "#"+widget.list2[0]+" #"+widget.list2[1]+" #"+widget.list2[2]
//                                                      : widget.list2.length>2?"#"+widget.list2[0]+" #"+widget.list2[1]:
//                                                  "#"+widget.list2[0] ,
//                                                  style: new TextStyle(
//                                                      fontSize: 20.0,
//                                                      fontWeight: FontWeight.bold,
//                                                      color: Colors.black)),
//                                            ),
//                                          ),


//                                      new Text(
//                                          'Population: ${snapshot.data.places[i]["info"]['population']}',
//                                          style: new TextStyle(
//                                              fontSize: 15.0,
//                                              fontWeight: FontWeight.bold)),
                                                ]),
                                          ),
                                        ),

                                      ],
                                    ),

                                    Align(
                                      alignment:Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:35,left:345.0),
                                        child: Icon(Icons.navigate_next,
                                          size:50,color: Colors.grey,),
                                      ),
                                    ),

                                  ],

                                )),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          );
        });
  }
  Future<CityModel> fetchAlbum() async {
    var str = "";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }
    String url =
        'http://gscrape.xeeve.com/api/searchgroup?' + str + 'lang=en_US';
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);

      return CityModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to load album " + url);
      throw Exception('Failed to load album');
    }
  }
  Future<Map<String, dynamic>> fetchTopics(String id) async {
    var str = "";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }
    String url =
        'http://gscrape.xeeve.com/api/searchnear?id='+id+'&lang=en_US';
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);

      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to load album " + url);
      throw Exception('Failed to load album');
    }
  }

  _showSnackBar(BuildContext context, City item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name} is a city in ${item.country}"),
      backgroundColor: Colors.amber,
    );
    Scaffold.of(context).showSnackBar(objSnackbar);
  }
  Future<Map<String, dynamic>> fecthnearplaces(String id) async {
    var str = "";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }

    String url =
        'http://gscrape.xeeve.com/api/searchnear?id='+id+ "&"+str + 'lang=en_US';
    print("URL NearCities "+url);
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);

      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to load album " + url);
      throw Exception('Failed to load album');
    }
  }
  showAlertDialog(BuildContext context,String msg,bool citipage) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes",style: TextStyle(
        color: Colors.blue
      ),),
      onPressed:  () {


        if(citipage){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  UserLike())
          );
        }else{

        }
      },
    );
    Widget continueButton = FlatButton(
      child: Text("No",style: TextStyle(
          color: Colors.red
      ),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Traval Planner"),
      content: Text(msg),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<String> checkcities(String cityname) async {
    print("documentsResult " + "get");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    print("documentsResult " + uid);
    print("documentsResult " + cityname);
    final QuerySnapshot result = await Firestore.instance
        .collection('USERS')
    .document(uid)
    .collection("Favrite")
        .where('city', isEqualTo: cityname)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
//    print("documentsResult" + documents[0].documentID);
    if(documents.length>0) {
      print("documentsResult" + documents[0].documentID);

      documents[0]['subtopicname'].toString();
    Map<dynamic, dynamic> mapnames =
    documents[0]['subtopicname'];
    Map<dynamic, dynamic> mapids =
    documents[0]['subtopicid'];
    print("Subtopic 2" + mapnames.toString());
    mapnames.forEach((key, value) {

    widget.tempnames.add(value);
    print("Temp1 "+value );
    });

    mapids.forEach((key, value) {
    widget.tempids.add(value);
    print("Temp2 "+value );
    });
      return documents[0].documentID;

    }return
      "noDocument";
  }
}
