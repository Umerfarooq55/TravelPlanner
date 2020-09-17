import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/model/city.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:onboarding_flow/ui/model/CityDetail.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_flow/ui/pages/CityDetails.dart';

class HomePage extends StatefulWidget {
  List<dynamic> list;
  List<dynamic> list2;

  HomePage(List<dynamic> list, List<dynamic> list2) {
    this.list = list;
    this.list2 = list2;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<City> _allCities = City.allCities();
  Future<CityModel> futureAlbum;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Future<void> _sendAnalyticsEvent(String name) async {

    await analytics.logEvent(
      name: 'CityPage',
      parameters: <String, dynamic>{
        'UserinCityPage':"yes",

      },
    );
  }
  @override
  void initState() {
    futureAlbum = fetchAlbum();
    CityDetail detail;
    futureAlbum.then((value) {
      print("places " + value.places.toString());
      detail = CityDetail.fromJson(value.places[0]["details"]);
      print("places " + value.places[0].toString());
      print("image " + detail.image.toString());
      print("shortDec " + detail.shortDes.toString());
    });
    _sendAnalyticsEvent("");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

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
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.of(context).pushNamed("/main")

          ),
          title: new Text(
              widget.list2.length>2?
              "Cities for "+  ""+widget.list2[0]+", "+widget.list2[1]+", "+widget.list2[2]
                  : widget.list2.length>1?"Cities for "+""+widget.list2[0]+", "+widget.list2[1]:
              "Cities for "+ ""+widget.list2[0] ,
              style: new TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getHomePageBody(context)));
  }

  getHomePageBody(BuildContext context)  {

  
    
    return FutureBuilder(

        future: fetchAlbum(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<CityModel> snapshot) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          return ListView.builder(
              itemCount: snapshot.data.places.length,
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int i) {
                CityDetail detail;
                detail =
                    CityDetail.fromJson(snapshot.data.places[i]["details"]);
                return Wrap(
                  children: <Widget>[

                    GestureDetector(
                      onTap: (){
             String str="";

                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                DetailPage(widget.list,widget.list2,snapshot.data.places[i],true,false))

                        );
                      },
                      child: Container(

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Card(
                              shape: RoundedRectangleBorder(

                                side: BorderSide(color: Colors.white70, width: 1),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 20,
                              child: Stack(

                          children: <Widget>[

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        bottomLeft: Radius.circular(8.0),


                                      ),
                                      child: Hero(
                                        tag: detail.image,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: detail.image,
                                              placeholder: (context, url) => Center(
                                                  child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                      CircularProgressIndicator())),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0),
                                  child: Container(
                                    child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Center(
                                            child: new Text(
                                                snapshot.data.places[i]["info"]
                                                ['name'],
                                                style: new TextStyle(
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)),
                                          ),
                                          Center(
                                            child: new Text(
                                                snapshot.data.places[i]["country"]
                                                ['name'],
                                                style: new TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey)),
                                          ),


                                        ]),
                                  ),
                                ),


                              ],
                            ),


                              Align(
                                alignment:Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top:35,left:295.0),
                                  child: Icon(Icons.navigate_next,
                                    size:50,color: Colors.grey,),
                                ),
                              ),

                          ],

                              )),
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
  }

  // First Task
/* Widget _getItemUI(BuildContext context, int index) {
   return new Text(_allCities[index].name);
 }*/
  sendDatatoFireStore(String country , String city , String image ) async{
    final FirebaseUser u = await FirebaseAuth.instance.currentUser();

    if(u != null) {
      Firestore.instance
          .collection("USERS")
          .document(u.uid)
          .collection("Favrite")
          .document()
          .setData({
        'country': country,
        "city": city,
        "image": image
      });
    }else{

      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
            "To Save you hae to Login first"),
      ));

    }
  }
  Future<CityModel>   fetchAlbum() async {
    var str = "";
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }
    String url =
        'http://gscrape.xeeve.com/api/searchgroup?' + str + 'lang=en_US';
//    String url =   "http://gscrape.xeeve.com/api/searchgroup?topicid[]=2&topicid[]=3&lang=en_US";
    final response = await http.get(url);
    print("URL : " + url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Response : " + response.body);

      return CityModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to load album " + url);
      throw Exception('Failed to load album');
    }
  }

  _showSnackBar(BuildContext context, City item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name} is a city in ${item.country}"),
      backgroundColor: Colors.amber,
    );
    Scaffold.of(context).showSnackBar(objSnackbar);
  }
}
