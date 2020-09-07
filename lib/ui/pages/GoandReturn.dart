import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:emoji_feedback/emoji_feedback.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/ui/model/FlightsModel.dart';
import 'package:onboarding_flow/ui/pages/playstore.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyB_gPmsFE9D0vnEcR5m5lGlwzBMLRaQBmA";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class GoandReturn extends StatefulWidget {
  bool showlogout;
  bool isInstructionView = false;
  List<dynamic>  goapi;
  List<dynamic>  returapi;
  List<dynamic>  results;
  GoandReturn(bool showlogout,  List<dynamic> go, List<dynamic>  retur, List<dynamic> results) {
    this.showlogout = showlogout;
    this.goapi=go;
    this.returapi=retur;
    this.results=results;
  }

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<GoandReturn> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  int index = 0;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  TextEditingController feedback = TextEditingController();
  bool Go = true;
  bool Return = false;
  @override
  void dispose() {

    super.dispose();
  }

  FirebaseAnalytics analytics = FirebaseAnalytics();

  Future<void> _sendAnalyticsEvent(String name) async {
    await analytics.logEvent(
      name: 'MapDetails',
      parameters: <String, dynamic>{
        'UserinMapDetailsPage': "yes",
      },
    );
  }

  @override
  void initState() {}


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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Go = true;
                        Return = false;
                      
                      });
                    },
                    child: new Text("Go ".toUpperCase(),
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Go ? Colors.blue : Colors.grey))),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Go = false;
                      Return = true;
                     
                    });
                  },
                  child: new Text("Return".toUpperCase(),
                      style: new TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Return ? Colors.blue : Colors.grey)),
                ),
              ),

            ],
          )
      ),
    );

  }

  Widget circles(){
    return  Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 15.0,
            height: 15.0,
            decoration: new BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),

          ),

          Transform.rotate(
            angle: 1.6,
            child: Icon(Icons.flight,
                color: Colors.grey,
                size: 34),
          ),

          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ), Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 5.0,
            height: 5.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),

          ),
          Container(
            width: 15.0,
            height: 15.0,
            decoration: new BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
  Widget SelectDestination() {}

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
        title: Text("Available Flights"),
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new IconButton(
            icon: new Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Go?GoUI():ReturnUI(),
    );

  }
Widget GoUI (){
  double _lowerValue = 50;

  double _upperValue = 180;
  List< dynamic> go= widget.goapi;
  Map<dynamic,dynamic> GoMAp;
  Map<dynamic,dynamic> Goapi = go[0];
  print("Beenish "+     Goapi['operatingCarrierIcon'].toString());
    return  Container(

      child: Column(
        children: <Widget>[
          Header(),
          Container(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Container(
                  width:  MediaQuery.of(context).size.width,
                  height:   MediaQuery.of(context).size.height-150,
                  child: ListView.builder(
                      itemCount:go.length,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int i) {

                        GoMAp = go[i];
                        String ImageURL =  GoMAp['operatingCarrierIcon'];
                        print("Image URL "+ i.toString() +" " +ImageURL.toString());
                        if(ImageURL=="null"||ImageURL==""||ImageURL==null){
                          ImageURL="null";
                        }
                        Map<dynamic,dynamic> results = widget.results[i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 420,
                            width: 360,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Row(
                                            children: <Widget>[
                                              ImageURL=="null"?Container(): Hero(
                                                tag: i.toString(),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl:   ImageURL,
                                                      placeholder: (context, url) => Center(
                                                          child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                              CircularProgressIndicator())),
                                                      errorWidget: (context, url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GoMAp['operatingCarrierName']==null?
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                 "No name in api or no image exist",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ):
                                              Container(
                                                width: 150,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    GoMAp['operatingCarrierName'].toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 18.0),
                                          child: Text(
                                            "\$"+ results['price'].toString()+" "+results['currency'].toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18.0, top: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                GoMAp['departureTime'].toString().substring(0,9),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),Text(
                                                GoMAp['cityCodeFrom'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35),
                                              ),Text(
                                                GoMAp['departureTime'].toString().substring(11,19),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                GoMAp['arrivalTime'].toString().substring(0,9),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),Text(
                                                GoMAp['cityCodeTo'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35),
                                              ),Text(
                                                GoMAp['arrivalTime'].toString().substring(11,19),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                    circles(),
                                    Text(
                                      results['goDuration'].toString().substring(0,2)+"h "+
                                          results['goDuration'].toString().substring(2,4)+"m ",

                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 25),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top:10.0),
                                      child: SizedBox(
                                        width: 320,
                                        height: 70,
                                        child: RaisedButton(

                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(

                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide(color: Colors.black)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Playstore(
                                                            null,
                                                            null,
                                                            null,
                                                            0.0,
                                                            null,
                                                            null,
                                                            results['url'])));
                                          },
                                          child: Text("Book Now",
                                            style: TextStyle(
                                                fontSize: 25
                                                ,color: Colors.black
                                            ),),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        ],

      ),
    );
}
  Widget ReturnUI (){
    double _lowerValue = 50;

    double _upperValue = 180;
    List< dynamic> go= widget.returapi;
    Map<dynamic,dynamic> GoMAp;
    Map<dynamic,dynamic> Goapi = go[0];
    print("Beenish "+     Goapi['operatingCarrierIcon'].toString());
    return  Container(

      child: Column(
        children: <Widget>[
          Header(),
          Container(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Container(
                  width:  MediaQuery.of(context).size.width,
                  height:   MediaQuery.of(context).size.height-150,
                  child: ListView.builder(
                      itemCount:go.length,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int i) {
                        GoMAp = go[i];
                        Map<dynamic,dynamic> results = widget.results[i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 420,
                            width: 360,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Row(
                                            children: <Widget>[
                                              Hero(
                                                tag: i.toString(),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl:    GoMAp['operatingCarrierIcon'],
                                                      placeholder: (context, url) => Center(
                                                          child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                              CircularProgressIndicator())),
                                                      errorWidget: (context, url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    GoMAp['operatingCarrierName'].toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 18.0),
                                          child: Text(
                                            "\$"+ results['price'].toString()+" "+results['currency'].toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18.0, top: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                GoMAp['departureTime'].toString().substring(0,9),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),Text(
                                                GoMAp['cityCodeFrom'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35),
                                              ),Text(
                                                GoMAp['departureTime'].toString().substring(11,19),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                GoMAp['arrivalTime'].toString().substring(0,9),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),Text(
                                                GoMAp['cityCodeTo'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35),
                                              ),Text(
                                                GoMAp['arrivalTime'].toString().substring(11,19),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                    circles(),
                                    Text(
                                      results['goDuration'].toString().substring(0,2)+"h "+
                                          results['goDuration'].toString().substring(2,4)+"m "+
                                          results['goDuration'].toString().substring(4,6)+"s ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 25),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top:10.0),
                                      child: SizedBox(
                                        width: 320,
                                        height: 70,
                                        child: RaisedButton(

                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(

                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide(color: Colors.black)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Playstore(
                                                            null,
                                                            null,
                                                            null,
                                                            0.0,
                                                            null,
                                                            null,
                                                            results['url'])));
                                          },
                                          child: Text("Book Now",
                                            style: TextStyle(
                                                fontSize: 25
                                                ,color: Colors.black
                                            ),),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        ],

      ),
    );
  }
}
