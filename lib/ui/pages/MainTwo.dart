import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();


class Maptwoo extends StatelessWidget {
  double latdouble;
  double longdouble;
  String city;
  List l1;
  List l2;
  Map<String, dynamic> places;
  Maptwoo(List l1, List l2, Map<String, dynamic> places, double latdouble, double longdouble, String city){

    this. latdouble=latdouble;
    this. longdouble=longdouble;
    this .city =city;
    this.l1=l1;
    this.l2=l2;
    this.places=places;
  }


  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {

        '/widget': (_) {
          return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      flutterWebViewPlugin.goBack();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      flutterWebViewPlugin.goForward();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.autorenew),
                    onPressed: () {
                      flutterWebViewPlugin.reload();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      },
    );
  }
}

class Maptwo extends StatefulWidget {
  double latdouble;
  double longdouble;
  String city;
  List l1;
  List l2;
  Map<String, dynamic> places;
  Maptwo(List l1, List l2, Map<String, dynamic> places, double latdouble, double longdouble, String city){

    this. latdouble=latdouble;
    this. longdouble=longdouble;
    this .city =city;
    this.l1=l1;
    this.l2=l2;
    this.places=places;
  }


  final String titl="";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Maptwo> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();


  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    getAddress().then((value) =>
        flutterWebViewPlugin.launch(

//      "https://www.google.com/maps/@?api=1&map_action=map&center="+
//          widget.latdouble.toString()+","+
//          widget.longdouble.toString()+"&query=museum"+"&zoom=13",
          "https://www.google.com/maps/dir/?api=1&origin="+value+"&destination=rome&travelmode=driving",
          geolocationEnabled: true,

          userAgent: kAndroidUserAgent,
          invalidUrlRegex:

          r'^(https).+(twitter)'
          , // prevent redirecting to twitter when user click on its icon in flutter website
        )
    );

  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }
  Future<bool> _NaigateBack(){
    flutterWebViewPlugin.dispose();
    Navigator.pop(context);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _NaigateBack,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(),
      ),
    );
  }
}
