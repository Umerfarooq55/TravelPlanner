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
import 'package:onboarding_flow/ui/model/FlightsDetails.dart';
import 'package:onboarding_flow/ui/model/FlightsModel.dart';
import 'package:onboarding_flow/ui/pages/GoandReturn.dart';
import 'package:onboarding_flow/ui/pages/playstore.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyB_gPmsFE9D0vnEcR5m5lGlwzBMLRaQBmA";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class FlightsResults extends StatefulWidget {
  bool showlogout;
  bool isInstructionView = false;
  flightsdeta _flightsdetails;
  FlightsResults(bool showlogout,flightsdeta _flightsdetails) {
    this._flightsdetails=_flightsdetails;
    this.showlogout = showlogout;
  }

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<FlightsResults> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  int index = 0;
  String url;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  TextEditingController feedback = TextEditingController();

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();

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

  Future<FlightsModel> getflights() async {
    var obj = new Map<dynamic, dynamic>();
    String isdirect="0";
    String RoundTrip="0";
    String Adult="0";
    String Child="";
    if(widget._flightsdetails.Adults=="1 Adult"){
      Adult="1";
    }
    if(widget._flightsdetails.Adults=="2 Adults"){
      Adult="2";
    }
    if(widget._flightsdetails.Adults=="3 Adults"){
      Adult="3";
    }
    if(widget._flightsdetails.Adults=="4 Adults"){
      Adult="4";
    }
    if(widget._flightsdetails.Adults=="5 Adults"){
      Adult="5";
    }
    if(widget._flightsdetails.Adults=="6 Adults"){
      Adult="6";
    }

    if(widget._flightsdetails.Child=="1 Child"){
      Child="1";
    }
    if(widget._flightsdetails.Adults=="2 Childs"){
      Child="2";
    }
    if(widget._flightsdetails.Adults=="3 Childs"){
      Child="3";
    }
    if(widget._flightsdetails.Adults=="4 Childs"){
      Child="4";
    }
    if(widget._flightsdetails.Adults=="5 Childs"){
      Child="5";
    }
    if(widget._flightsdetails.Adults=="6 Childa"){
      Child="6";
    }

    if(widget._flightsdetails.isdirect){
      isdirect="1";

    }else{
      isdirect="0";
    }
    if(widget._flightsdetails.isRoundTrip){
      RoundTrip="1";

    }else{
      RoundTrip="0";
    }
     url =
        "https://gscrape.xeeve.com/api/flights?id="+widget._flightsdetails.ID+
            "&lang=en"+
            "&latitude="+widget._flightsdetails.lat+
            "&longitude="+widget._flightsdetails.Lng+
            "&dategofrom="+widget._flightsdetails.DepartureDateFrom+
            "&dategoto="+widget._flightsdetails.DepartureDateTo+
            "&datereturnfrom="+widget._flightsdetails.ReturnDateFrom+
            "&datereturnto="+widget._flightsdetails.DeturnDateTo+
            "&nightsfrom="+widget._flightsdetails.NumberOfNights+
            "&direct="+isdirect+
            "&adults="+Adult+
            "&children="+Child;
    print("Flights URL"+url);
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("citiesname Response : " + response.body);

    return  FlightsModel.fromJson(json.decode(response.body));
  }

  void dialog() {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      dialogType: DialogType.SUCCES,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Select Routes",
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      btnOkText: "RETURN",

      btnOkColor: Colors.amber,
      btnOkOnPress: (){

      },
      btnCancelText: "GO",
        btnCancelColor: Colors.deepOrange,
      btnCancelOnPress: () {}
    ).show();
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
    double _lowerValue = 50;

    double _upperValue = 180;
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
      body: FutureBuilder(
        future: getflights(),
        builder: (context,  AsyncSnapshot<FlightsModel> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container (
                  width: 250,
                  child: Text(
                    url.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
              )
                ],

              ),
            );
        var totalFlights = snapshot.data.places.length;
          return Container(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Container (
                            child: Text(
                              "Total $totalFlights flights Found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:30,top: 8.0),
                          child: Text(
                            "Choose Price Range",
                            style: TextStyle(
                              color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(child: Text(
                            "0 EUR                                             1000 EUR",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 50, right: 50),
                          alignment: Alignment.centerLeft,
                          child:FlutterSlider(
                            values: [30, 420],
                            rangeSlider: true,
                            max: 500,
                            min: 0,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              _lowerValue = lowerValue;
                              _upperValue = upperValue;
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:30,top: 8.0),
                          child: Text(
                            "Choose Hours Range",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(child: Text(
                            "0 hr                                             10 hr",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 50, right: 50),
                          alignment: Alignment.centerLeft,
                          child:FlutterSlider(
                            values: [30, 420],
                            rangeSlider: true,
                            max: 500,
                            min: 0,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              _lowerValue = lowerValue;
                              _upperValue = upperValue;
                              setState(() {});
                            },
                          ),
                        ),

                      ],
                    )
                  ],
                ),

            Container(
              width:  MediaQuery.of(context).size.width,
              height:   MediaQuery.of(context).size.height-400,
              child: ListView.builder(
                  itemCount:snapshot.data.places.length,
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int i) {

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 450,
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
//                                    Padding(
//                                      padding: const EdgeInsets.all(18.0),
//                                      child: Row(
//
//                                        children: <Widget>[
//                                          Hero(
//                                            tag: i.toString(),
//                                            child: Material(
//                                              color: Colors.transparent,
//                                              child: InkWell(
//                                                child: CachedNetworkImage(
//                                                  fit: BoxFit.fill,
//                                                  imageUrl:snapshot.data.places[i]['routes']['go'][0]['operatingCarrierIcon'],
//                                                  placeholder: (context, url) => Center(
//                                                      child: Container(
//                                                          width: 20,
//                                                          height: 20,
//                                                          child:
//                                                          CircularProgressIndicator())),
//                                                  errorWidget: (context, url, error) =>
//                                                      Icon(Icons.error),
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(left: 8.0),
//                                            child: Text(
//                                              snapshot.data.places[i]['routes']['go'][0]['operatingCarrierName'].toString(),
//                                              style: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 20),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0,left: 120),
                                      child: Text(
                                      "\$"+ snapshot.data.places[i]['price'].toString()+" "+snapshot.data.places[i]['currency'].toString(),
                                        style: TextStyle(
                                          color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
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
                                             snapshot.data.places[i]['goDepartureTime'].toString().substring(0,9),
                                             style: TextStyle(
                                                 color: Colors.grey,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 15),
                                           ),Text(
                                             snapshot.data.places[i]['goCityCodeFrom'].toString(),
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 35),
                                           ),Text(
                                             snapshot.data.places[i]['goDepartureTime'].toString().substring(11,19),
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
                                            snapshot.data.places[i]['goArrivalTime'].toString().substring(0,9),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),Text(
                                            snapshot.data.places[i]['goCityCodeTo'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35),
                                          ),Text(
                                            snapshot.data.places[i]['goArrivalTime'].toString().substring(11,19),
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
                                  snapshot.data.places[i]['goDuration'].toString().substring(0,2)+"h "+
                                      snapshot.data.places[i]['goDuration'].toString().substring(2,4)+"m ",
//                                      snapshot.data.places[i]['goDuration'].toString().substring(4,6)+"s ",
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
                                          side: BorderSide(color: Colors.blue)),
                                      onPressed: () {
                                        List<dynamic>  Go;
                                        List<dynamic>  retun;
                                        List<dynamic>  Results;
                                        Go =  snapshot.data.places[i]['routes']['go'];
                                         retun=snapshot.data.places[i]['routes']['return'];
                                        Results=snapshot.data.places;
                                        print("Go List 1 "+Go[0].toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GoandReturn(true,Go,retun,Results
                                                      )));
                                      },
                                      child: Text("Routes Details",
                                        style: TextStyle(
                                            fontSize: 25
                                            ,color: Colors.blue
                                        ),),
                                    ),
                                  ),
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
                                                        snapshot.data.places[i]['url'])));
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
          );
        },
      ),
    );

  }

}
