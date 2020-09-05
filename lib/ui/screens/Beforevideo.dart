import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:emoji_feedback/emoji_feedback.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';

import 'BackgroundVideo.dart';
import 'NewHome.dart';
class beforeVideo extends StatefulWidget {
  @override
  _beforeVideoState createState() => _beforeVideoState();
}

class _beforeVideoState extends State<beforeVideo> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.blue,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Watch quick tutorial: how to use the app",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 35,
                color: Colors.white
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            NewHome(false))
    );

  }
}
