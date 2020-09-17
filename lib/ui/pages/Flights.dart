import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:onboarding_flow/ui/screens/Feedback.dart';
import 'package:onboarding_flow/ui/model/FlightsDetails.dart';
import 'FlightsResults.dart';
class Flights extends StatefulWidget {
  String id;
  String lat;
  String lng;
  Flights(String id, String lat, String lng){
    this.id=id;
    this.lat=lat;
    this.lng=lng;
  }


  @override
  _FlightsState createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
//  DateTime DateReturnFrom = DateTime.now();
//  DateTime DateReturnTO = DateTime.now();
//  DateTime DateDepartureFrom = DateTime.now();
//  DateTime DateDepartureTo = DateTime.now();
  flightsdeta _flightsdetails;
  bool roundtrip = true;
  bool isdirect = false;
  TextEditingController _FlightFrom = new TextEditingController();
  TextEditingController _FlightTO = new TextEditingController();
  TextEditingController Numberofnight=new TextEditingController();
  String ReturnFrom =DateFormat('yyyy-MM-dd').format(DateTime.now());
  String ReturnTO =DateFormat('yyyy-MM-dd').format(DateTime.now());
  String DepartureFrom =DateFormat('yyyy-MM-dd').format(DateTime.now());
  String DepartureTo =DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<String> adultsList = ['1 Adult', '2 Adults', '3 Adults', '4 Adults','5 Adults','6 Adults']; // Option 2
  String _adults; // Option 2
  String _child;
  List<String> childList = ['1 Child', '2 Childs', '3 Childs', '4 Childs','5 Childs','6 Childs']; // Option 2
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1450,

      child: Column(
        children: <Widget>[
          SelectDestination(),
          SelectDeparture(),
          ReturnDate(),
          Numberofflights(),
          DirectFlights(),
          NoOfPassengers(),
          Padding(
            padding: const EdgeInsets.only(top:28.0),
            child: SizedBox(
              width: 320,
              height: 70,
              child: RaisedButton(

                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  print("Beenish ID "+ widget.id);
                  print("Beenish lat "+ widget.lat.toString());
                  print("Beenish long "+ widget.lng.toString());

                  _flightsdetails=new flightsdeta(
                      _FlightFrom.text,
                    _FlightTO.text,
                      DepartureFrom.toString(),
                      DepartureTo,
                      ReturnFrom,
                      ReturnTO,
                      Numberofnight.text,
                  isdirect,
                  roundtrip,
                  _adults,
                  _child,
                    widget.id,
                    widget.lng,
                    widget.lat
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          FlightsResults(true,_flightsdetails)));
                },
                child: Text("Search Flights",
                style: TextStyle(
                  fontSize: 25
                      ,color: Colors.white
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget SelectDestination(){

    return Container(
      height: 350,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.autorenew, size: 34),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text("Round Trip",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: roundtrip,
                    onChanged: (bool isOn) {
                      print(isOn);
                      setState(() {
                       roundtrip = isOn;
                        print(roundtrip);
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.flight_takeoff, size: 34),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("From",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                        ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _FlightFrom,
                  obscureText: false,

                  decoration: InputDecoration(

                    hintStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal
                    ),

                    focusedBorder: OutlineInputBorder(),

                    hintText: 'Paris, France',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.flight_land, size: 34),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("To",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                        ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: false,
                  controller: _FlightTO,
                  decoration: InputDecoration(

                    hintStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal
                    ),

                    focusedBorder: OutlineInputBorder(),

                    hintText: 'New York, York',
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
  Widget SelectDeparture(){
    final TextEditingController _departureFrom = TextEditingController();
    final TextEditingController _departureTO = TextEditingController();
    return Container(
      height: 200,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today, size: 34),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text("Departure Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 160,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Date From",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectDepartureFrom(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top:10.0,right: 5),
                              child: Text(
                                DepartureFrom.toString(),
                                style:
                                TextStyle(
                                  color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),

                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 160,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Date to",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectDepartureTo(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top:10.0,right: 5),
                              child: Text(
                                DepartureTo.toString(),
                                style:
                                TextStyle(
                                  color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),

                              )
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )




            ],
          )
      ),
    );
  }
  Future<void> _selectReturnFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != ReturnFrom)
      setState(() {
        ReturnFrom = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  Future<void> _selectReturnTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != ReturnFrom)
      setState(() {
        ReturnTO = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  Future<void> _selectDepartureFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != ReturnFrom)
      setState(() {
        DepartureFrom = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  Future<void> _selectDepartureTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != ReturnFrom)
      setState(() {
        DepartureTo = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
  Widget ReturnDate(){

    return Container(
      height: 200,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today, size: 34),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text("Return Date (Optional)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 160,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Date From",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectReturnFrom(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top:10.0,right:5),
                            child: Text(
                              ReturnFrom.toString(),
                            style:
                              TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),

                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 160,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18.0,right: 18.0,top:18.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Date to",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectReturnTo(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top:10.0,right:5),
                              child: Text(
                                ReturnTO.toString(),
                                style:
                                TextStyle(
                                  color: Colors.redAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),

                              )
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )




            ],
          )
      ),
    );
  }
  Widget Numberofflights(){

    return Container(
      height: 150,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:18.0,right: 18.0,top:0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.weekend, size: 34),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Number of nights",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Column(
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              obscureText: false,
                              controller: Numberofnight,
                              decoration: InputDecoration(

                                hintStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal
                                ),

                                focusedBorder: OutlineInputBorder(),

                                hintText: '10 Nights',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                )




              ],
            ),
          )
      ),
    );
  }
  Widget DirectFlights(){

    return Container(
      height: 80,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: <Widget>[
                        Transform.rotate(
                          angle: 1.6,
                          child: Icon(Icons.flight,
                              size: 34),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text("Direct Flights?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: isdirect,
                    onChanged: (bool isOn) {
                      print(isOn);
                      setState(() {
                        isdirect = isOn;
                        print(isdirect);
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),

            ],
          )
      ),
    );
  }
  Widget NoOfPassengers(){

   // Option 2
    return Container(
      height: 150,
      width: 360,
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 5),
            borderRadius: BorderRadius.circular(10),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20,
          child:Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:18.0,right: 18.0,top:0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person, size: 34),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Passengers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                          hint: Text('0 Adult',style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),), // Not necessary for Option 1
                          value: _adults,
                          onChanged: (newValue) {
                            setState(() {
                              _adults = newValue;
                            });
                          },
                          items: adultsList.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                          hint: Text('0 Child',style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),), // Not necessary for Option 1
                          value: _child,
                          onChanged: (newValue) {
                            setState(() {
                              _child = newValue;
                            });
                          },
                          items: childList.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                )




              ],
            ),
          )
      ),
    );
  }
}
