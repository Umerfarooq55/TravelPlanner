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

import 'NewHome.dart';

const kGoogleApiKey = "AIzaSyB_gPmsFE9D0vnEcR5m5lGlwzBMLRaQBmA";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);


class UserFeedback extends StatefulWidget {
  bool showlogout;

  UserFeedback(bool showlogout){
    this.showlogout= showlogout;
  }

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<UserFeedback> {
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

  Future<bool> _NaigateBack() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            NewHome(widget.showlogout))
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
      name: 'MapDetails',
      parameters: <String, dynamic>{
        'UserinMapDetailsPage': "yes",

      },
    );
  }


  @override
  void initState() {

  }

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
          title: Text("Feedback"),
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
        body: Container(

          child: Column(
              children: <Widget>[
          Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Center(
            child: EmojiFeedback(
                currentIndex: 0,
                onChange: (afterindex) {
                  index = afterindex;
                }
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            controller: feedback,
            minLines: 10,
            maxLines: 15,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Write your feedback here',
              filled: true,
              fillColor: Color(0xFFDBEDFF),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
        padding: const EdgeInsets.only(top:18.0),
    child: NiceButton(
    width: 255,
    elevation: 8.0,
    radius: 52.0,
    text: "Submit",
    background: Colors.red,
    onPressed: () async {
      final FirebaseUser u = await FirebaseAuth.instance.currentUser();
      if (u != null) {
        Firestore.instance
            .collection("Feedback")
            .document(u.uid)
            .setData(
            {
              "feedback": feedback.text,
              "Emojii": index
            }
        );


        Future.delayed(const Duration(milliseconds: 1000), () {
          Fluttertoast.showToast(
              msg: "We received your feedback. Thank you",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pop(context);
          });
        });
      } else {
        Firestore.instance
            .collection("Feedback")
            .document(feedback.text.length.toString())
            .setData(
            {
              "feedback": feedback.text,
              "Emojii": index
            }
        );


        Future.delayed(const Duration(milliseconds: 1000), () {
          Fluttertoast.showToast(
              msg: "We received your feedback. Thank you",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pop(context);
          });
        });
      };
    }
    ),
    ),
    ],
    )


    )
    );
    }
  }