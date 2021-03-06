import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;

import 'CityDetails.dart';
import 'place_detail.dart';

const kGoogleApiKey = "AIzaSyB_gPmsFE9D0vnEcR5m5lGlwzBMLRaQBmA";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);



class HomeDetails extends StatefulWidget {
  double latdouble;
  double longdouble;
  String city;
  List l1;
      List l2;
  Map<String, dynamic> places;
  HomeDetails(List l1, List l2, Map<String, dynamic> places, double latdouble, double longdouble, String city){

    this. latdouble=latdouble;
    this. longdouble=longdouble;
    this .city =city;
    this.l1=l1;
    this.l2=l2;
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
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Future<bool> _NaigateBack(){
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            DetailPage(widget.l1,widget.l2,widget.places,true))
    );
  }
  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();


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
              DetailPage(widget.l1,widget.l2,widget.places,true))
      );
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
      child: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.only(top:40,right: 8.0,left: 8.0),
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
              url:"https://www.google.com/maps/@?api=1&map_action=map&center="+
                  widget.latdouble.toString()+","+
                  widget.longdouble.toString()+"&query=museum"+"&zoom=13",


//      url:"https://www.google.com/maps/search/"+widget.city+"+"+allsub,
//      url: "https://www.google.com/maps/search/?api=1&query="+widget.longdouble.toString()+","+widget.latdouble.toString(),
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
                leading: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            DetailPage(widget.l1,widget.l2,widget.places,true))
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color:Colors.black,
                    size: 25.0,
                  ),
                ),
                title: new Text(widget.places['info']['name']+" ("+widget.places['country']['name']+")"),
              ),
            ),
          ),
        ),
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

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {

      final lat = widget.latdouble;
      final lng = widget.longdouble;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });


    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 5000);
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {

        this.places = result.results;
        result.results.forEach((f) {
//          final markerOptions = MarkerOptions(
//              position:
//                  LatLng(f.geometry.location.lat, f.geometry.location.lng),
//              infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"));
//          mapController.addMarker(markerOptions);
          final MarkerId markerId = MarkerId(f.placeId);
          final Marker marker = Marker(
            markerId: markerId,
            position: LatLng(
                f.geometry.location.lat, f.geometry.location.lng
            ),
            infoWindow: InfoWindow(title: "${f.name}", snippet:"${f.types?.first}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceDetailWidget(f.placeId)),
              );
            },
          );
          markers[markerId] = marker;
          print("MArker2: "+markers.length.toString());
        });
      } else {
        this.errorMessage = result.errorMessage;
      }
      setState(() {

      });
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);

      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity,
            style: Theme.of(context).textTheme.body1,
          ),
        ));
      }

      if (f.types?.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
                fontWeight: FontWeight.bold
            ),
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }
}
