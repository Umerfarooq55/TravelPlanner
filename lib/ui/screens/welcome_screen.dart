import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:onboarding_flow/ui/screens/NewHome.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:package_info/package_info.dart';
import 'package:upgrader/upgrader.dart';







class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  
  void dialog() {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Hello! This app is still in beta. Please don't rate it on the store yet. We're working hard to make it awesome for you soon! Meanwhile, feel free to leave your feedback anytime from the app menu. Thank you.",
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),),
      tittle: 'This is Ignored',
      desc:   'This is also Ignored',
      btnCancelText: "Feedback",
//      btnCancelOnPress: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) =>
//                UserFeedback())
//        );
//      },
      btnOkOnPress: () {},

    ).show();
  }
  @override
  Widget build(BuildContext context) {
    return Page();
  }

  @override
  void initState() {
//    Future.delayed(const Duration(milliseconds: 1000), () {
//      dialog();
//    });
  }
}



class Page extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Future<void> _sendAnalyticsEvent(String name) async {

    await analytics.logEvent(
      name: 'Skip_Lgin',
      parameters: <String, dynamic>{
        'skip':"yes",

      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6495ED),
      body: new ListView(

        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Icon(
              Icons.phone_iphone,
              color:Colors.white,
              size: 125.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35.0, right: 15.0, left: 15.0),
            child: Text(
              "Welcome to Travel Planner!",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                fontFamily: "OpenSans",
              ),
            ),
          ),


          Update()

        ],
      ),
    );
  }


  Future<double> mobileInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print("packageInfo:  "+packageInfo.version);
    return double.parse(packageInfo.version);
  }
  FutureBuilder Update(){

    return FutureBuilder(
      future: mobileInfo(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) Container();
       double usermobileapp = snapshot.data;
    return StreamBuilder(
    stream: Firestore.instance
        .collection("currentversion")
        .document("1")
        .snapshots(), // a previously-obtained Future<String> or null
    builder: (BuildContext context, snapshot) {
      if(!snapshot.hasData) Container();
         if(snapshot.data!=null){
           double currentmobileapp = double.parse( snapshot.data['current'].toString());
           if(usermobileapp>=currentmobileapp){
             return Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Your personal Travel Assistant. Please signup or login to access all features.",
                     softWrap: true,
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.black,
                       decoration: TextDecoration.none,
                       fontSize: 18.0,
                       fontWeight: FontWeight.normal,
                       fontFamily: "OpenSans",
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                   child: SizedBox(
                     width: 300,
                     child: CustomFlatButton(
                       title: "Log In",
                       fontSize: 22,

                       fontWeight: FontWeight.w700,
                       textColor: Colors.white,
                       onPressed: () {
                         Navigator.of(context).pushNamed("/signin");
                       },
                       splashColor: Colors.black12,
                       borderColor: Colors.white,
                       borderWidth: 0,
                       color:Colors.indigo,
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                   child: SizedBox(
                     width: 300,

                     child: CustomFlatButton(
                       title: "Sign Up",
                       fontSize: 22,
                       fontWeight: FontWeight.w700,
                       textColor: Colors.black54,
                       onPressed: () {
                         Navigator.of(context).pushNamed("/signup");
                       },
                       splashColor: Colors.black12,
                       borderColor: Colors.black12,
                       borderWidth: 2,
                       color:Colors.amberAccent,
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                   child: SizedBox(
                     width: 300,
                     child: CustomFlatButton(
                       title: "Skip",
                       fontSize: 22,
                       fontWeight: FontWeight.w700,
                       textColor: Colors.white,
                       onPressed: () {
                         _sendAnalyticsEvent("").then((value) =>
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) =>
                                     NewHome(false))
                             )
                         );


                       },
                       splashColor: Colors.black12,
                       borderColor: Colors.black12,
                       borderWidth: 2,

                     ),
                   ),
                 ),

               ],
             );
           }else{
             return Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Please update to latest version to continue using the app.",
                     softWrap: true,
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.black,
                       decoration: TextDecoration.none,
                       fontSize: 18.0,
                       fontWeight: FontWeight.bold,
                       fontFamily: "OpenSans",
                     ),
                   ),
                 ),
                 Padding(
                   padding:
                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                   child: SizedBox(
                     width: 300,
                     child: CustomFlatButton(
                       title: "Update App",
                       fontSize: 22,

                       fontWeight: FontWeight.w700,
                       textColor: Colors.white,
                       onPressed: () {
                         LaunchReview.launch(
                             iOSAppId: "1508607274",
                             androidAppId: "trip.travelplanner.vacationholiday"

                         );
                       },
                       splashColor: Colors.black12,
                       borderColor: Colors.white,
                       borderWidth: 0,
                       color:Colors.indigo,
                     ),
                   ),
                 ),

               ],
             );
           }
//      if(!snapshot.hasData) Container();
//
//      if()

         }else{
           return Container();
         }


    }
    );
        });

//
    }
  }

