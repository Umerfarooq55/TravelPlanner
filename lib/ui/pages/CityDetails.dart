import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/main.dart';
import 'package:onboarding_flow/ui/model/city.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:onboarding_flow/ui/model/CityDetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:onboarding_flow/ui/pages/Flights.dart';
import 'package:onboarding_flow/ui/pages/playstore.dart';
import 'package:onboarding_flow/ui/screens/Feedback.dart';
import 'package:onboarding_flow/ui/screens/NewHome.dart';
import 'package:onboarding_flow/ui/screens/UserLike.dart';
import 'package:onboarding_flow/ui/screens/sign_in_screen.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';
import 'MainTwo.dart';
import 'Serpiew.dart';
import 'Viater.dart';
import 'main.dart';
import 'dart:ui' as ui;

class DetailPage extends StatefulWidget {
  List<dynamic> list;
  List<dynamic> list2;
  List<dynamic> tempids;
  List<dynamic> tempnames;

  Map<String, dynamic> places;
  bool shoeheart;
  bool showlogout;

  DetailPage(List<dynamic> list, List<dynamic> list2,
      Map<String, dynamic> places, bool str, bool showlogout) {
    this.list = list;
    this.list2 = list2;
    this.places = places;
    this.shoeheart = str;
    this.showlogout=showlogout;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DetailPage> {
  int _selectedIndex = 0;
  final List<City> _allCities = City.allCities();
  Future<CityModel> futureAlbum;
  bool shouldExpand = false;
  String expandText = 'Read More';
  final LatLng _center = const LatLng(45.521563, -122.677433);
  GoogleMapController mapController;
  var Lang ="en";
  bool information = true;
  bool thingstodo = false;
  bool flightScreen = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  FirebaseAnalytics analytics = FirebaseAnalytics();

  Future<void> _sendAnalyticsEvent(String name) async {
    await analytics.logEvent(
      name: 'home_city',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Future<void> city_near() async {
    await analytics.logEvent(
      name: 'city_near',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Future<void> city_description() async {
    await analytics.logEvent(
      name: 'city_description',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Future<void> city_bookmarked() async {}

  Future<void> city_serp_details() async {
    await analytics.logEvent(
      name: 'city_bookmarked',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
  }

  Future<void> city_bookmark_rome(String name) async {
    await analytics.logEvent(
      name: 'city_bookmark_$name',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
    );
    await analytics.logEvent(
      name: 'city_bookmarked',
      parameters: <String, dynamic>{
        'UserinCityDetailsPage': "yes",
      },
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
    _sendAnalyticsEvent("");
  }

  @override
  Widget build(BuildContext context) {
    var lat = widget.places['latitude'];
    var long = widget.places['longitude'];
    var longdouble = double.parse(long);
    double latdouble = double.parse(lat);
    String id = widget.places["id"];

    print("umer lat "+ lat.toString());
    print("umer long "+ long);
//    List imagesList= widget.places['images'];
    return new Scaffold(
        appBar: new AppBar(

          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image(
                  image: AssetImage("assets/newicon.png"),
                ),
              ),
            )
          ],
          title: new Text(
              widget.list2.isNotEmpty
                  ? widget.list2.length > 2
                      ? "Cities for " +
                          "" +
                          widget.list2[0] +
                          ", " +
                          widget.list2[1] +
                          " " +
                          widget.list2[2]
                      : widget.list2.length > 1
                          ? "Cities for " +
                              "" +
                              widget.list2[0] +
                              ", " +
                              widget.list2[1]
                          : "Cities for " + "" + widget.list2[0]
                  : "City Details",
              style: new TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              getHomePageBody(context),
              thingstodo ? getViaterPlaces(context, id) : Container(),
              information
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 300,
                          width: 500,
                          //child: GestureDetector(
                          child: GoogleMap(
                            rotateGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            compassEnabled: true,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            buildingsEnabled: true,
                            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                              new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                            ].toSet(),
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(latdouble, longdouble),
                              zoom: 12.0,
                            ),
                          ),
                          //)
                        ),

                        /* Old map - drag to move and pinch to zoom not works
                        Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4.0),
                            child: new Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide( color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                semanticContainer: true,
                                clipBehavior: Clip.hardEdge,
                                elevation: 20,
                                child: SizedBox(
                                    height: 300,
                                    width: 500,
                                    //child: GestureDetector(
                                      child: GoogleMap(
                                        rotateGesturesEnabled: true,
                                        zoomGesturesEnabled: true,
                                        compassEnabled: true,
                                        mapToolbarEnabled: true,
                                        myLocationButtonEnabled: true,
                                        scrollGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(latdouble, longdouble),
                                          zoom: 12.0,
                                        ),
//
                                        onTap: (LatLng pos) {
                                        /*Navigator.push(
                                         context,
                                          MaterialPageRoute(builder: (context) => HomeDetails(pos.latitude,pos.longitude, widget.places["info"]['name'].toString()))
                                        );*/
                                        //Navigator.pop(context);
                                          /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              HomeDetails(
                                                widget.showlogout,
                                                widget.list,
                                                widget.list2,
                                                widget.places,
                                                pos.latitude,
                                                pos.longitude,
                                                widget.places["info"]['name'].toString()
                                              )
                                          )
                                        );*/
                                        },
                                      ),
                                    //)
                                ))),
                        */

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: new Text(
                                widget.list2.isNotEmpty
                                    ? widget.list2.length > 2
                                        ? "Near cities for " +
                                            "" +
                                            widget.list2[0] +
                                            ", " +
                                            widget.list2[1] +
                                            " " +
                                            widget.list2[2]
                                        : widget.list2.length > 1
                                            ? "Near cities for " +
                                                "" +
                                                widget.list2[0] +
                                                ", " +
                                                widget.list2[1]
                                            : "Near cities for " +
                                                "" +
                                                widget.list2[0]
                                    : "",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        getNearPlaces(context, id)
                      ],
                    )
                  : Container(),
              flightScreen ? Flights(id,lat.toString(),long.toString()) : Container(),
            ]),
          ),
        ));
  }

  _toggleShouldExpand() {
    shouldExpand ? city_description() : null;
    setState(() {
      shouldExpand = !shouldExpand;
      expandText = shouldExpand ? 'Close' : 'Read More';
    });
  }

  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

  getHomePageBody(BuildContext context) {
    print("Details umer :" + widget.places.toString());

    var lat = widget.places['latitude'];
    var long = widget.places['longitude'];
    var longdouble = double.parse(long);
    double latdouble = double.parse(lat);
    CityDetail detail;
    detail = CityDetail.fromJson(widget.places["details"]);
    String id = widget.places["id"];
//    List<dynamic> imagesList= widget.places['images'][0];
//    print("imagesList "+imagesList.length.toString())  ;
    int Imagescounter = 0;
    List<dynamic> imagesList = widget.places['images'];
    print("imagesList Lenght" + imagesList.length.toString());
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Container(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Center(
                                      child: new Text(
                                          widget.places["info"]['name'],
                                          style: new TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    ),
                                  ),
                                  Center(
                                    child: new Text(
                                        widget.places["country"]['name'],
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 400,
                                  minHeight: 400,
                                  maxWidth: 400,
                                  maxHeight: 400,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                  child: imagesList.length > 0
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: imagesList.length,
                                          itemBuilder: (context, i) {
                                            return Stack(
                                              children: <Widget>[
                                                SizedBox(


                                                  child: Image.network(
                                                     imagesList[i]['url'],
                                                      width: 480,
height: 400,
                                                      fit:BoxFit.fill
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    child: Wrap(
                                                        children: Lines(
                                                            imagesList.length,
                                                            i)),
                                                    width: 250,
                                                  ),
                                                  heightFactor: 1.5,
                                                  widthFactor: 1.8,
                                                )
                                              ],
                                            );
                                          },
                                        )
                                      : SizedBox(
                                          height: 400,
                                          child: Hero(
                                            tag: detail.image,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.contain,
                                                  imageUrl: detail.image,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              child:
                                                                  CircularProgressIndicator())),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 5.0, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    widget.tempids = widget.list;
                                    widget.tempnames = widget.list2;
                                    checkcities(widget.places['info']['name'])
                                        .then((value) => sendJSONtoFireStore(
                                            widget.places,
                                            widget.tempids,
                                            widget.tempnames,
                                            value));
                                  },
                                  child: widget.shoeheart
                                      ? Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Icon(
                                            Icons.favorite,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                        )
                                      : Container()),
                GestureDetector(
                  onTap: () {
                   dialog();
                  },
                  child:
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Icon(
                                  Icons.share,
                                  size: 50,
                                  color: Colors.black38,
                                ),
                              )
                )
                            ],
                          ),
                        ),
                        Container(child: Header()),
                        information
                            ? Information(context, id, detail)
                            : Container()
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column Information(BuildContext context, String id, CityDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: new Text(
              widget.places["info"]['name'] +
                  " is a city in " +
                  widget.places["country"]['name'] +
                  " , with a population of about " +
                  widget.places["info"]['population'].toString() +
                  " inhabitants.Find below more information about " +
                  widget.places["info"]['name'].toString() +
                  ".",
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new Text(
              "Information about " +
                  widget.places["info"]['name'] +
                  " (" +
                  widget.places["info"]['name'] +
                  ")",
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(detail.shortDes,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
              maxLines: shouldExpand ? null : 1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
          child: OutlineButton(
            child: Text(expandText),
            onPressed: _toggleShouldExpand,
          ),
        ),
        widget.list2.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text("See details for:",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              )
            : Container(),
        widget.list2.isNotEmpty
            ? getSERPgetSERPdetails(context, id)
            : Container(),
        widget.list2.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text("See images for:",
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              )
            : Container(),
        widget.list2.isNotEmpty ? getSERPgetSERP(context, id) : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new Text(
              "Other things to do in " +
                  widget.places["info"]['name'].toString(),
              style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        getTopics(context, id),
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0,
              right: 30.0,
              top: 14.0,
              bottom: 18.0
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                information = false;
                thingstodo = true;
                flightScreen = false;
              });
            },
            child: viaterflightbutton(context, id),
          ),
        )
      ],
    );
  }

  Container Header() {
    return Container(
      width: 360,
      height: 60,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 20,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      information = true;
                      thingstodo = false;
                      flightScreen = false;
                    });
                  },
                  child: new Text("Information ".toUpperCase(),
                      style: new TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: information ? Colors.blue : Colors.grey))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    information = false;
                    thingstodo = true;
                    flightScreen = false;
                  });
                },
                child: new Text("Things to do".toUpperCase(),
                    style: new TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: thingstodo ? Colors.blue : Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
//                    dialog();
                    setState(() {
                      information = false;
                      thingstodo = false;
                      flightScreen = true;
                    });
                  },
                  child: new Text("Flights".toUpperCase(),
                      style: new TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color:
                          flightScreen ? Colors.blue : Colors.grey))),
            ),
          ],
        )
      ),
    );

  }

  List<Widget> Lines(int total, int pos) {
    List<Widget> list = [];
    for (int i = 0; i < total; i++) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 5,
          height: 5,
          color: i == pos ? Colors.black : Colors.amber,
        ),
      ));
    }
    return list;
  }

  sendDatatoFireStore(String country, String city, String image) async {
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    if (u != null) {
      Firestore.instance
          .collection("USERS")
          .document(u.uid)
          .collection("Favrite")
          .document()
          .setData({'country': country, "city": city, "image": image});
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("To Save you hae to Login first"),
      ));
    }
  }

  sendJSONtoFireStore(Map<String, dynamic> places, List<dynamic> list1,
      List<dynamic> list2, String document) async {
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    var FinalList1 = list1.toSet().toList();
    var FinalList2 = list2.toSet().toList();
    print("Curren list ids" + FinalList1.toString());
    print("Curren list names" + FinalList2.toString());
    Map<dynamic, String> listnames = new Map<dynamic, String>();
    Map<dynamic, String> listids = new Map<dynamic, String>();
    for (int i = 0; i < FinalList1.length; i++) {
      listnames[i.toString()] = FinalList2[i].toString();
      listids[i.toString()] = FinalList1[i].toString();
    }
    places['subtopicname'] = listnames;
    places['subtopicid'] = listids;
    places['city'] = places['info']['name'];

    if (u != null) {
      city_bookmark_rome(places['info']['name']);
      print("Curren Doc " + document);
      if (document == "noDocument") {
        Firestore.instance
            .collection("USERS")
            .document(u.uid)
            .collection("Favrite")
            .document()
            .setData(places);
      } else {
        Firestore.instance
            .collection("USERS")
            .document(u.uid)
            .collection("Favrite")
            .document(document)
            .updateData(places);
      }

      showAlertDialog(context,
          "Trip saved. Would you like to go to your Saved Trips page?", true);
    } else {
      Fluttertoast.showToast(
          msg: "You must be logged in to save your trip.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Future.delayed(const Duration(milliseconds: 1000), () {
// Here you can write your code
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      });
    }
  }

  getSERPgetSERP(BuildContext context, String id) {
    double hieght = widget.list2.length * 40.toDouble();
    int colorCounter = 0;
    return Container(
      height: 50,
      child: ListView.builder(
          itemCount: widget.list2.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int i) {
            colorCounter++;
            if (colorCounter == 3) {
              colorCounter = 0;
            }
            return Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeDetailsserp(
                                      widget.list,
                                      widget.list2,
                                      widget.places,
                                      0.0,
                                      widget.list2[i],
                                      widget.places["info"]['name'].toString(),
                                      "&tbm=isch",widget.showlogout)));
                        },
                        child: Container(
                          height: 30,
                          color: colorCounter == 1
                              ? Color(0xff0b1c31)
                              : colorCounter == 2
                                  ? Color(0xff65a29c)
                                  : colorCounter == 2
                                      ? Color(0xff9e27a7)
                                      : Colors.orange,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 15.0),
                              child: new Text(
//                                    widget.list2[i]+" near "+widget.places["info"]['name'].toString(),
                                  widget.list2[i],
                                  style: new TextStyle(
//                                  shadows: [
//                                    Shadow(
//                                      blurRadius: 10.0,
//                                      color: Colors.grey,
//                                      offset: Offset(1.0, 1.0),
//                                    ),
//                                  ],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
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

  getSERPgetSERPdetails(BuildContext context, String id) {
    double hieght = widget.list2.length * 40.toDouble();
    int colorCounter = 0;
    return Container(
      height: 50,
      child: ListView.builder(
          itemCount: widget.list2.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int i) {
            colorCounter++;
            if (colorCounter == 3) {
              colorCounter = 0;
            }
            return Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeDetailsserp(
                                      widget.list,
                                      widget.list2,
                                      widget.places,
                                      0.0,
                                      widget.list2[i],
                                      widget.places["info"]['name'].toString() +
                                          " " +
                                          widget.places["country"]['name']
                                              .toString(),
                                      "",widget.showlogout)));
                        },
                        child: Container(
                          height: 30,
                          color: colorCounter == 1
                              ? Color(0xff65a29c)
                              : colorCounter == 2
                                  ? Color(0xff9e27a7)
                                  : colorCounter == 2
                                      ? Color(0xff0b1c31)
                                      : Colors.orange,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: new Text(
//                              widget.list2[i]+" near "+widget.places["info"]['name'].toString(),
                                  widget.list2[i],
                                  style: new TextStyle(
//                                    shadows: [
//                                      Shadow(
//                                        blurRadius: 10.0,
//                                        color: Colors.white,
//                                        offset: Offset(1.0, 1.0),
//                                      ),
//                                    ],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
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

  getTopics(BuildContext context, String id) {
    return FutureBuilder(
        future: fetchTopics(id), // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: Container(
                    height: 20, width: 20, child: CircularProgressIndicator()),
              ),
            );
          final List topics = snapshot.data['result']['topics'];
          print("Topics: " + topics.length.toString());
          int colorCounter = 0;
          return Container(
            height: 70,
            child: ListView.builder(
                itemCount: topics.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int i) {
                  colorCounter++;
                  if (colorCounter == 3) {
                    colorCounter = 0;
                  }
                  return Container(
                    height: 40,
                    width: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Container(
                              width: 150,
                              height: 30,
                              color: colorCounter == 1
                                  ? Color(0xff9e27a7)
                                  : colorCounter == 2
                                      ? Color(0xff65a29c)
                                      : colorCounter == 2
                                          ? Color(0xff0b1c31)
                                          : Colors.orange,
                              child: Center(
                                child: new Text(topics[i]["name"].toString(),
                                    style: new TextStyle(
//                                        shadows: [
//                                          Shadow(
//                                            blurRadius: 10.0,
//                                            color: Colors.grey,
//                                            offset: Offset(1.0, 1.0),
//                                          ),
//                                        ],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
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

  void dialog() {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.INFO,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "This feature is not available yet.Please give us 5 star so that we get accepted for flights detail sooner! Thank you",
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
      ),
     btnOkText: "Review",
      btnOkOnPress: (){
        LaunchReview.launch(
            iOSAppId: "1508607274",
            androidAppId: "trip.travelplanner.vacationholiday"

        );
      },
      btnCancelText: "Feedback",
      btnCancelOnPress: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            UserFeedback(widget.showlogout)));

      },

    ).show();
  }

  getNearPlaces(BuildContext context, String id) {
    return FutureBuilder(
        future: fecthnearplaces(id),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          List Near = snapshot.data['result']['near'];
          print("Near " + Near.length.toString());
          return Container(
            height: 150,
            child: ListView.builder(
                itemCount: Near.length,
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  CityDetail detail;
                  detail = CityDetail.fromJson(Near[i]["details"]);
                  return Wrap(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          city_near();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(widget.list,
                                      widget.list2, Near[i], true,widget.showlogout)));
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 20,
                                child: Stack(
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                              ),
                                              child: Hero(
                                                tag: detail.image,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: detail.image,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child: Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  child:
                                                                      CircularProgressIndicator())),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Container(
                                            child: new Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                        Near[i]["info"]['name'],
                                                        style: new TextStyle(
                                                            fontSize: 23.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red)),
                                                  ),
                                                  Center(
                                                    child: new Text(
                                                        Near[i]["country"]
                                                            ['name'],
                                                        style: new TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.grey)),
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
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 35, left: 345.0),
                                        child: Icon(
                                          Icons.navigate_next,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
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

  viaterflightbutton(BuildContext context, String id) {
    return FutureBuilder(
        future: viaterplacesTicket(id),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                //child: CircularProgressIndicator(),
              ),
            );

          return Center(
            child: Container(
                width: 300,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Card(
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Tours and tickets".toUpperCase(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                          Center(
                            child: Text(
                              "from " + snapshot.data + " EUR",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      )),
                )),
          );
        });
  }

  getViaterPlaces(BuildContext context, String id) {
    return FutureBuilder(
        future: viaterplaces(id),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          List viaterApi = snapshot.data['result']['activities']['city'];
          print("Near " + viaterApi.length.toString());
          return Container(
            height: 470,
            child: ListView.builder(
                itemCount: viaterApi.length,
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int i) {
                  return Wrap(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
//                          city_near();
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => DetailPage(widget.list,
//                                      widget.list2, Near[i], true)));
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 20,
                                  child: Stack(
                                    children: <Widget>[
                                      new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 120,
                                                minHeight: 170,
                                                maxWidth: 120,
                                                maxHeight: 170,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Hero(
                                                  tag: viaterApi[i]['photos'][0]
                                                      ["url"],
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl: viaterApi[i]
                                                                ['photos'][0]
                                                            ["url"],
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child: Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Container(
                                              child: new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Container(
                                                        width: 150,
                                                        height: 80,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: new Text(
                                                              viaterApi[i]
                                                                  ["title"],
                                                              softWrap: true,
                                                              style: new TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: new Text(
                                                            "From " +
                                                                viaterApi[i][
                                                                        "priceFrom"]
                                                                    .toString() +
                                                                " " +
                                                                viaterApi[i][
                                                                        "priceCurrency"]
                                                                    .toString(),
                                                            style: new TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: new Text(
                                                            "Duration " +
                                                                viaterApi[i][
                                                                        "duration"]
                                                                    .toString(),
                                                            style: new TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue)),
                                                      ),
                                                    ),
//
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Viater(
                                                      widget.list,
                                                      widget.list2,
                                                      widget.places,
                                                      0.0,
                                                      null,
                                                      null,
                                                      viaterApi[i]["url"],widget.showlogout)));
                                        },
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 80.0, right: 30),
                                            child: Icon(
                                              Icons.open_in_new,
                                              size: 30,
                                              color: Colors.lightBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          )),
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
        'http://gscrape.xeeve.com/api/searchgroup?lang='+Lang+"?" + str ;
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
        'http://gscrape.xeeve.com/api/searchnear?lang='+Lang+"?"+'id=' + id ;
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

    String url = 'http://gscrape.xeeve.com/api/searchnear?lang='+Lang+"?"+'id=' +
        id +
        "&" +
        str +
        'lang=en_US';
    print("URL NearCities " + url);
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

  Future<String> viaterplacesTicket(String id) async {
    var str = "";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }

    String url = 'http://gscrape.xeeve.com/api/city?lang='+Lang+"?"+'id=' + id;
    print("URL NearCities " + url);

//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    List viaterApi = json.decode(response.body)['result']['activities']['city'];
    List price = [];
    viaterApi.forEach((element) {
      price.add(element['priceFrom']);
//      print("ViaterAPiP" +element['priceFrom']); //
    });
    price.sort();
    print("ViaterAPipriceFrom" + price[0].toString()); //
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);

      return price[0].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to load album " + url);
      throw Exception('Failed to load album');
    }
  }

  Future<Map<String, dynamic>> viaterplaces(String id) async {
    var str = "";
    var url="";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }


    if(widget.list.length>0){
       url = 'http://gscrape.xeeve.com/api/city?lang='+Lang+"?"+'id=' + id+"&"+str;
    }else{
       url = 'http://gscrape.xeeve.com/api/city?id=' + id;
    }

    print("URLumer " + url);
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

  showAlertDialog(BuildContext context, String msg, bool citipage) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        if (citipage) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserLike(widget.showlogout)));
        } else {}
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
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

    if (user != null) {
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
      if (documents.length > 0) {
        print("documentsResult" + documents[0].documentID);

        documents[0]['subtopicname'].toString();
        Map<dynamic, dynamic> mapnames = documents[0]['subtopicname'];
        Map<dynamic, dynamic> mapids = documents[0]['subtopicid'];
        print("Subtopic 2" + mapnames.toString());
        mapnames.forEach((key, value) {
          widget.tempnames.add(value);
          print("Temp1 " + value);
        });

        mapids.forEach((key, value) {
          widget.tempids.add(value);
          print("Temp2 " + value);
        });
        return documents[0].documentID;
      }
      return "noDocument";
    }
  }
}
