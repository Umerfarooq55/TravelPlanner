import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/model/city.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:onboarding_flow/ui/model/CityDetail.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_flow/ui/pages/CityDetails.dart';

import 'NewHome.dart';

class UserLike extends StatefulWidget {
  bool showlogout;
  UserLike(bool showlogout) {
     showlogout= showlogout;
  }

  @override
  _UserLikeState createState() => _UserLikeState();
}

class _UserLikeState extends State<UserLike> {
  int _selectedIndex = 0;
  final List<City> _allCities = City.allCities();
  Future<CityModel> futureAlbum;
  List<String> list = [];
  List<String> list2 = [];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),

          title: new Text("Saved Trips",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getUserLikeBody(context)));
  }

  Future<FirebaseUser> getUID() async {
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    return u;
  }

  getUserLikeBody(BuildContext context) {
    list2 = [];
    list = [];
    return FutureBuilder(
      future: getUID(),
      builder: (BuildContext context, uid) {


        if(uid.data==null) return Center(child: Padding(
          padding: const EdgeInsets.all(42.0),
          child: Text("You must login to use this feature",
          textAlign: TextAlign.center,
          style: TextStyle(

            fontSize: 35,
            color: Colors.amber
          ),),
        ));
        if (!uid.hasData)

          return Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        print("UID : " + uid.data.uid.toString());
        return StreamBuilder(
            stream: Firestore.instance
                .collection("USERS")
                .document(uid.data.uid.toString())
                .collection("Favrite")
                .snapshots(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, snapshot) {

              if (!snapshot.hasData)

                return Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

              return    snapshot.data.documents.length> 0?  ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int i) {
                    list2 = [];
                    list = [];
                    String subtopic=" ";
                    print("Subtopic " +
                        snapshot.data.documents[i]['subtopicname'].toString());
                    Map<dynamic, dynamic> mapnames =
                        snapshot.data.documents[i]['subtopicname'];
                    Map<dynamic, dynamic> mapids =
                        snapshot.data.documents[i]['subtopicid'];
                    print("Subtopic 2" + mapnames.toString());
                    mapnames.forEach((key, value) {
                      subtopic +=  value+", ";
                      list2.add(value);
                    });
                    mapids.forEach((key, value) {
                      list.add(value);
                    });
                    Map<dynamic, dynamic> places =  snapshot.data.documents[i].data;
                    return Wrap(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        list,
                                        list2,
                                       places,
                                        false,widget.showlogout)));
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Card(
                                  color: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 20,
                                  child: Stack(
                                    children: <Widget>[
                                      new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 120,
                                                minHeight: 120,
                                                maxWidth: 120,
                                                maxHeight: 120,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Hero(
                                                  tag:
                                                      snapshot.data.documents[i]
                                                          ['details']['image'],
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl: snapshot.data
                                                                .documents[i][
                                                            'details']['image'],
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child: Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Container(
                                              child: new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Center(
                                                      child: new Text(
                                                          snapshot
                                                              .data
                                                              .documents[i]
                                                                  ['info']
                                                                  ['name']
                                                              .toString(),
                                                          style: new TextStyle(
                                                              fontSize: 23.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .green)),
                                                    ),
                                                    Center(
                                                      child: new Text(
                                                          snapshot
                                                              .data
                                                              .documents[i]
                                                                  ['country']
                                                                  ['name']
                                                              .toString(),
                                                          style: new TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Firestore.instance
                                                            .collection("USERS")
                                                            .document(uid.data.uid)
                                                            .collection(
                                                                "Favrite")
                                                            .document(snapshot
                                                                .data
                                                                .documents[i]
                                                                .documentID)
                                                            .delete();
                                                      },
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  left: 5.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 30,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    new Container(
                                                      constraints: new BoxConstraints(
                                                          maxWidth: MediaQuery.of(context).size.width - 164),
                                                      child:  Text(subtopic,
                                                          style: new TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color:
                                                              Colors.amber)),
                                                    ),


//                                                    getSERPgetSERP(context, ""),
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 35, left: 295.0),
                                          child: Icon(
                                            Icons.navigate_next,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ],
                    );
                  }): Center(
                    child: Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: Text("Your list is empty..",
                textAlign: TextAlign.center,
                style: TextStyle(

                        fontSize: 35,
                        color: Colors.amber
                ),),
                    ),
                  );
            });
      },
    );
  }

  getSERPgetSERP(BuildContext context, String id) {
    print("Lenthg" + list2.length.toString());
    double hieght = list2.length * 40.toDouble();
    return Container(
      height: 10,
      child: ListView.builder(
          itemCount: list2.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int i) {
            return Container(
              height: 10,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) =>
//                                  HomeDetailsserp(widget.list,widget.list2,widget.places,0.0, widget.list2[i], widget
//                                      .places["info"]
//                                  ['name'].toString()))
//                          );
                        },
                        child: Container(
                          child: new Text(" near ",
                              style: new TextStyle(
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.grey,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // First Task
/* Widget _getItemUI(BuildContext context, int index) {
   return new Text(_allCities[index].name);
 }*/
  sendDatatoFireStore(String country, String city, String image) async {
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    if (u != null) {
      Firestore.instance
          .collection("USERS")
          .document(u.uid)
          .collection("Favrite")
          .document()
          .setData({'country': country, "city": city, "image": image});
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("To Save you hae to Login first"),
      ));
    }
  }
}
