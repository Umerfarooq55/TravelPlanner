import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CityDetails.dart';
import 'place_detail.dart';




class HomeDetails extends StatefulWidget {
  double latdouble;
  double longdouble;
  String city;
  List l1;
      List l2;
  Map<String, dynamic> places;
  bool showlogout;
  HomeDetails(bool showlogout,List l1, List l2, Map<String, dynamic> places, double latdouble, double longdouble, String city){

    this. latdouble=latdouble;
    this. longdouble=longdouble;
    this .city =city;
    this.l1=l1;
    this.l2=l2;
    this.showlogout=showlogout;
    this.places=places;
  }

  
  
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeDetails> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;

  bool isLoading = false;
  String errorMessage;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription _nav;
  String url;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Future<bool> _NaigateBack(){
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            DetailPage(widget.l1,widget.l2,widget.places,true,widget.showlogout))
    );
  }
  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _nav.cancel();

    super.dispose();
  }
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Future<void> _sendAnalyticsEvent(String name) async {

    await analytics.logEvent(
      name: 'city_map',
      parameters: <String, dynamic>{
        'UserinMapDetailsPage':"yes",

      },
    );
  }



  @override
  void initState() {

    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              DetailPage(widget.l1,widget.l2,widget.places,true,widget.showlogout))
      );
    });
   _nav= flutterWebViewPlugin.onUrlChanged.listen((String umer) async {
      print("navigating to...$url");
      if (umer.startsWith("intent://") )
      {
        await flutterWebViewPlugin.stopLoading();
        await flutterWebViewPlugin.goBack();
        if (await canLaunch(url))
        {
          print("launch $url");
          await launch(url);
          return;
        }
        print("couldn't launch $url");
      }
    });

    _sendAnalyticsEvent("");
  }

  @override
  Widget build(BuildContext context) {
//         print("URL "+"https://www.google.com/maps/@?api=1&map_action=map&center="+
//             widget.latdouble.toString()+","+
//             widget.longdouble.toString()+"&query=museum"+"&zoom=12");
         String allsub="";
         widget.l2.forEach((element) {
           allsub += element+"+";
         });
         print("URL "+"https://www.google.com/maps/@?api=1&map_action=map&center="+
             widget.latdouble.toString()+","+
             widget.longdouble.toString()+"&zoom=12");

    return WillPopScope(
      onWillPop: _NaigateBack,
      child: FutureBuilder(
        future: getAddress(),
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


          return
            FutureBuilder(
              future: getcityAddress(),
              builder: (context, getcityAddress) {

                if (!snapshot.hasData) return Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                );
                if(snapshot.hasData&&getcityAddress.data.toString()!=null) {
                  String v =getcityAddress.data;
                  try {
                    url = "https://www.google.com/maps/dir/?api=1&origin=" +
                        snapshot.data + "&destination=" + v +
                        "&travelmode=driving&zoom=150";
                    return Container(
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 40, right: 8.0, left: 8.0),
                        child: Card(

                          shape: RoundedRectangleBorder(

                            side: BorderSide(

                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.hardEdge,
                          elevation: 5,
                          child: new WebviewScaffold(
                            withLocalStorage: true,
                            withJavascript: true,
                            withZoom: true,
                            displayZoomControls: true,
                            url: url,
//      url:"https://www.google.com/maps/search/"+widget.city+"+"+allsub,
//      url: "https://www.google.com/maps/search/?api=1&query="+widget.longdouble.toString()+","+widget.latdouble.toString(),
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
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          DetailPage(
                                              widget.l1, widget.l2, widget.places,
                                              true,widget.showlogout))
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                              ),
                              title: new Text(
                                  widget.places['info']['name'] + " (" +
                                      widget.places['country']['name'] + ")"),
                            ),
                          ),
                        ),
                      ),
                    );
                  }  catch(e) {
                    return     Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    );

                  }


                }
        });
        }
      ),
    );
    Widget expandedChild;
//    if (isLoading) {
//      expandedChild = Center(child: CircularProgressIndicator(value: null));
//    } else if (errorMessage != null) {
//      expandedChild = Center(
//        child: Text(errorMessage),
//      );
//    } else {
////      expandedChild = buildPlacesList();
//    }
//    print("Marker : "+markers.length.toString());
//    return Scaffold(
//        key: homeScaffoldKey,
//        appBar: AppBar(
//          title:  Text(widget.city),
//          actions: <Widget>[
//            isLoading
//                ? IconButton(
//                    icon: Icon(Icons.timer),
//                    onPressed: () {},
//                  )
//                : IconButton(
//                    icon: Icon(Icons.refresh),
//                    onPressed: () {
//                      refresh();
//                    },
//                  ),
//            IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                _handlePressButton();
//              },
//            ),
//          ],
//        ),
////        body: GoogleMap(
////            onMapCreated: _onMapCreated,
////            initialCameraPosition: CameraPosition(
////                                         target:  LatLng(widget.latdouble,widget.longdouble),
////                                         zoom: -20.0,
////                                       ),
////          onTap: (LatLng pos) {
////            setState(() {
////              print("Position" +pos.toString());
////            });
////          },
////          markers: Set<Marker>.of(markers.values),
////        )
//
//
//    );
  }
  Future<String> getcityAddress()async {//call this async method from whereever you need




    final coordinates = new Coordinates(
        widget.latdouble,widget.longdouble);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first.addressLine.toString();
  }



  Future<dynamic> getAddress()async {//call this async method from whereever you need


    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }

    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first.addressLine;
  }



}
