import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onboarding_flow/models/user.dart';
import 'package:onboarding_flow/ui/pages/homepage.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_flow/ui/screens/Topics.dart';
import 'package:onboarding_flow/ui/screens/UserLike.dart';
import 'package:onboarding_flow/ui/screens/Feedback.dart';
import 'package:onboarding_flow/ui/screens/sign_in_screen.dart';
import 'package:onboarding_flow/ui/screens/welcome_screen.dart';

import '../../Filters.dart';

class NewHome extends StatefulWidget {

  bool showlogout;
  NewHome(bool bool){

    showlogout=bool;
  }
  
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }
  Future<String> getUID() async {
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    return u.uid;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key: _scaffoldKey,
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
          elevation: 0.5,
          leading: new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: Text("Travel Planner"),
          centerTitle: true,
        ),
        drawer: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                currentAccountPicture: new CircleAvatar(
                  radius: 50.0,
                  backgroundColor: const Color(0xFF778899),
                  backgroundImage:
                  AssetImage("assets/newicon.png") ,
                ),
              ),
//            AssetImage("assets/newicon.png")
              ListTile(
                title: Text('Saved trips'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          UserLike())
                  );
                },
              ),
              ListTile(
                title: Text('Feeback'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          UserFeedback())
                  );
                },
              ),
              widget.showlogout?    ListTile(
                title: Text('Log out'),
                onTap: () async {
                  _logOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          WelcomeScreen())
                  );


                },
              ):   ListTile(
                title: Text('Log in'),
                onTap: () async {
                  Navigator.of(context).pushNamed("/signin");

                },
              )
            ],
          ),
        ),
        body:
        Topics());


  }
  Future<CityModel> fetchAlbum() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CityModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  void _logOut() async {
    Auth.signOut();
  }
}
