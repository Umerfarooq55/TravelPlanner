import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onboarding_flow/ui/model/city.dart';
import 'package:onboarding_flow/ui/model/CityModel.dart';
import 'package:onboarding_flow/ui/model/CityDetail.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_flow/ui/pages/CityDetails.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageWithoutAppbar extends StatefulWidget {
  List<dynamic> list;
  List<dynamic> list2;
  bool searchture;
  List<dynamic> searchnames;
      bool distancetrue;
  bool subtopicstrue;
  double lowerValue;
  HomePageWithoutAppbar(List<dynamic> list, List<dynamic> list2,List<dynamic> searchnames,bool searchture,bool distancetrue, bool subtopicstrue, double lowerValue) {
    this.list = list;
    this.list2 = list2;
    this.searchture=searchture;
    this.searchnames=searchnames;
    this.distancetrue=distancetrue;
    this.lowerValue=lowerValue;
    this.subtopicstrue=subtopicstrue;
  }
  @override
  _HomePageWithoutAppbarState createState() => _HomePageWithoutAppbarState();
}

class _HomePageWithoutAppbarState extends State<HomePageWithoutAppbar> {
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
    return Container(
      height: 500,
      child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: getHomePageWithoutAppbarBody(context)),
    );
  }
    Future<bool> checklocationpermission() async {
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        return true;
      }else{
        return false;
      }
    }
  getHomePageWithoutAppbarBody(BuildContext context)  {



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
         if(snapshot.data.places.length>0) {
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
                       onTap: () {
                         String str = "";

                         Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) =>
                                 DetailPage(widget.list, widget.list2,
                                     snapshot.data.places[i], true))

                         );
                       },
                       child: Container(

                         child: Padding(
                           padding: const EdgeInsets.all(4.0),
                           child: new Card(
                               shape: RoundedRectangleBorder(

                                 side: BorderSide(
                                     color: Colors.white70, width: 1),
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
                                     crossAxisAlignment: CrossAxisAlignment
                                         .start,
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
                                             child:detail.image!=null? Hero(
                                               tag: detail.image,
                                               child: Material(
                                                 color: Colors.transparent,
                                                 child: InkWell(
                                                   child: CachedNetworkImage(
                                                     fit: BoxFit.fill,
                                                     imageUrl: detail.image,
                                                     placeholder: (context,
                                                         url) =>
                                                         Center(
                                                             child: Container(
                                                                 width: 50,
                                                                 height: 50,
                                                                 child:
                                                                 CircularProgressIndicator())),
                                                     errorWidget: (context, url,
                                                         error) =>
                                                         Icon(Icons.error),
                                                   ),
                                                 ),
                                               ),
                                             ):Container(),
                                           )),
                                       Padding(
                                         padding: const EdgeInsets.only(
                                             left: 12.0),
                                         child: Container(
                                           child: new Column(
                                               mainAxisAlignment: MainAxisAlignment
                                                   .start,
                                               crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                               children: <Widget>[

                                                 Center(
                                                   child: new Text(
                                                       snapshot.data
                                                           .places[i]["info"]
                                                       ['name'],
                                                       style: new TextStyle(
                                                           fontSize: 23.0,
                                                           fontWeight: FontWeight
                                                               .bold,
                                                           color: Colors.red)),
                                                 ),
                                                 Center(
                                                   child: new Text(
                                                       snapshot.data
                                                           .places[i]["country"]
                                                       ['name'],
                                                       style: new TextStyle(
                                                           fontSize: 18.0,
                                                           fontWeight: FontWeight
                                                               .normal,
                                                           color: Colors.grey)),
                                                 ),


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
                                       child: Icon(Icons.navigate_next,
                                         size: 50, color: Colors.grey,),
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
         }else{
           return Center(child: Padding(
             padding: const EdgeInsets.all(28.0),
             child: Text("No Results.Please try different filters",
               textAlign: TextAlign.center,style: TextStyle(
               fontSize: 22,
                 fontWeight:FontWeight.bold,
                 color:Colors.black87

             ),),
           ));
         }
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
    var searchnames = "";
    String url;
    print("filter subtopics "+widget.subtopicstrue.toString());
    print("filter search "+widget.searchture.toString());
    print("filter distance "+widget.distancetrue.toString());
    for (int i = 0; i < widget.list.length; i++) {
      str += "topicid[]=" + widget.list[i].toString() + "&";
    }
    for (int b = 0; b < widget.searchnames.length; b++) {
      searchnames += "filtercountry[]=" + widget.searchnames[b].toString() + "&";
    }
    print("SearchURL3 "+widget.searchture.toString());
    if(widget.searchture&&!widget.subtopicstrue&&!widget.distancetrue){

        url =
            'http://gscrape.xeeve.com/api/searchgroup?'+ searchnames+ 'lang=en_US';
        print("search true "+url);
    }
    if(widget.distancetrue&&!widget.subtopicstrue&&!widget.searchture){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
       url =
          "http://gscrape.xeeve.com/api/searchgroup?filterlatitude="+position.latitude.toString()+"&filterlongitude="+position.longitude.toString()+"&filterdistance="+widget.lowerValue.toString();
      print("distance true "+url);
    }
   if(widget.subtopicstrue&&!widget.distancetrue&&!widget.searchture) {
     url =
         'http://gscrape.xeeve.com/api/searchgroup?' + str + 'lang=en_US';
     print("Subtopics  true "+url);
   }
    if(!widget.subtopicstrue&&!widget.distancetrue&&!widget.searchture) {
      url =
      "http://gscrape.xeeve.com/api/searchgroup?topicid[]=143&topicid[]=144&lang=en_US";
      print("No filter "+url);
    }
    if(widget.subtopicstrue&&widget.distancetrue&&!widget.searchture) {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      url =
          'http://gscrape.xeeve.com/api/searchgroup?' + str +"filterlatitude="+position.latitude.toString()+"&filterlongitude="+position.longitude.toString()+"&filterdistance="+widget.lowerValue.toString();
      print("Subtopics & distance  true "+url);
    }
    if(widget.subtopicstrue&&!widget.distancetrue&&widget.searchture) {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      url =
          'http://gscrape.xeeve.com/api/searchgroup?' + str +searchnames;
      print("Subtopics & search  true "+url);
    }
    if(!widget.subtopicstrue&&widget.distancetrue&&widget.searchture) {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      url =
        'http://gscrape.xeeve.com/api/searchgroup?' + searchnames +"filterlatitude="+position.latitude.toString()+"&filterlongitude="+position.longitude.toString()+"&filterdistance="+widget.lowerValue.toString();
      print("distance & search  true "+url);
    }
    if(widget.subtopicstrue&&widget.distancetrue&&widget.searchture){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     url="https://gscrape.xeeve.com/api/searchgroup?lang=en_US&"+str+"filterlatitude="+position.latitude.toString()+"&filterlongitude="+position.longitude.toString()+"&filterdistance="+widget.lowerValue.toString()+"&"+searchnames;
    }

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
      return CityModel.fromJson(json.decode(response.body));
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
