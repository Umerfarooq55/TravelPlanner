import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import "package:onboarding_flow/models/walkthrough.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:package_info/package_info.dart';
class WalkthroughScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final List<Walkthrough> pages = [
  Walkthrough(
      icon: 'assets/images/slide1.png',
      title: "Travel Planner",
      color: Color(0xff6495ED),
      description:
          "Your personal travel assistant, at the tap of your finger.",
    ),
  Walkthrough(
    icon: 'assets/images/slide2.png',
    title: "",
    color: Color(0xff6495ED),
    description: "Plan your travel based on what you love to do",
  ),
  Walkthrough(
      icon:'assets/images/slide3.png',
      title: "",
      color: Color(0xff6495ED),
      description:
      "Select your interests (eg. hicking, lakes, pubs..",
    ),
    Walkthrough(
      icon: 'assets/images/slide4.png',
      title: "",
      color: Color(0xff6495ED),
      description:
      "Find cities where you can do what you like",
    ),
  ];

  WalkthroughScreen({this.prefs});

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.white30,
              activeColor: Colors.white,
              size: 6.5,
              activeSize: 8.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context),
      ),
    );
  }

  List<Widget> _getPages(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      Walkthrough page = widget.pages[i];
      widgets.add(
        new Container(
          color:page.color,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Image(
                  image: AssetImage(page.icon),
                  color:Colors.white,
                  width:125,
                  height: 125,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
                  page.title,
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  page.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: page.extraWidget,
              )
            ],
          ),
        ),
      );
    }
    widgets.add(
      new Container(
        color:Color(0xff6495ED),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/slide5.png'),
                color:Colors.white,
                width:125,
                height: 125,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
                  "Explore those cities, and plan your next trip!",
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
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: " Let's get started!",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('seen', true);
                    Navigator.of(context).pushNamed("/root");
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  color: Color.fromRGBO(212, 20, 15, 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widgets;
  }

  Color changeColor(int i) {

    switch (1) {
      case 0:
        return Colors.grey;
      // do something
        break;
      case 1:
        return Colors.black54;
      case 2:
      // do something
        return Colors.pink;
        break;

    }
  }

  @override
  void initState() {
  getimei().then((id) =>
  mobileInfo().then((value) =>
      Firestore.instance
          .collection("MobileID")
          .document(id)
          .setData(
          {
            "current_version":value
          }
      )

  )
  );

  }

  Future<String> getimei() async {

     print("GETIMEI");
    String imei = "IOS";
     print("GETIMEI:  "+imei);
    return imei;
  }
  Future<String> mobileInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print("packageInfo:  "+packageInfo.version);
    return packageInfo.version;
  }
}
