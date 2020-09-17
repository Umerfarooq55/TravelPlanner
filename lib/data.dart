import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data {
  final String title;
  Map<String,dynamic> contents = {};
  bool _isSelected;

  Data(this.title, this.contents);
}
List<Data> vehicles = [
  new Data(
    'Culture',
    {
      "ancient ruins":[false,143],
      "architectural buildings":[false,144],
      "bridges":[false,148],
      "castles":[false,145],
      "cathedrals":[false,141],
      "cemeteries":[false,146],
      "churches":[false,140],
      "fountains":[false,152],
      "historical sites":[false,139],
      "mines":[false,149],
      "monuments":[false,150],
      "religious sites":[false,142],
      "statues":[false,151],
      "towers":[false,147],
    }
  ),
  new Data(
    'Fun/Kids',
    {
      "adventure":[false,164],
      "adventure parks":[false,154],
      "amusement parks":[false,158],
      "aquariums":[false,155],
      "festival":[false,167],
      "food":[false,165],
      "playgrounds":[false,156],
      "shooting ranges":[false,163],
      "shopping":[false,166],
      "theme parks":[false,160],
      "treasure hunts":[false,162],
      "water parks":[false,159],
      "157":[false,157],
    }
  ),
  new Data(
    'Nature',
    {
      "beaches":[false,171],
      "caves":[false,179],
      "countryside":[false,-1],
      "desert":[false,-1],
      "docks":[false,-1],
      "farms":[false,-1],
      "forest":[false,-1],
      "gardens":[false,180],
      "geological formations":[false,184],
      "hiking trails":[false,177],
      "horse trails":[false,183],
      "islands":[false,181],
      "lakes":[false,175],
      "mountains":[false,170],
      "national parks":[false,185],
      "natural places":[false,-1],
      "nature":[false,169],
      "nature reserves":[false,172],
      "off-road trails":[false,186],
      "parks":[false,173],
      "ranches":[false,-1],
      "rivers":[false,174],
      "scenic roads":[false,-1],
      "secret":[false,-1],

      "slopes":[false,176],
      "valleys":[false,182],
      "volcanoes":[false,-1],
      "walking trails":[false,178],
      "walkways":[false,-1],
      "wildlife":[false,-1]
    }
  ),
  new Data(
    'Night Life',
    {
      "bars":[false,-1],
      "casinos":[false,-1],
      "clubs":[false,-1],
      "disco":[false,-1],
      "events":[false,-1],
      "nightlife":[false,-1],
      "pubs":[false,-1],
      "wine bars":[false,-1],
    }
  ),
  new Data(
    'Sport',
    {
      "abseiling":[false,-1] ,
      "biking":[false,-1] ,
      "boat rides":[false,-1] ,
      "bodyboard":[false,-1] ,
      "canoeing" :[false,-1],
      "climbing":[false,-1] ,
      "diving" :[false,-1],
      "fishing":[false,-1],
      "hiking" :[false,-1],
      "hunting":[false,-1] ,
      "jet skiing" :[false,-1],
      "kayaking":[false,-1],
      "kiteboarding" :[false,-1],
      "kitesurfing":[false,-1],
      "paddle" :[false,-1],
      "hunting":[false,-1] ,
      "paddleboarding" :[false,-1],
      "parachute":[false,-1],

      "rafting":[false,-1] ,
      "running" :[false,-1],
      "scuba diving":[false,-1],
      "skateboard" :[false,-1],
      "skiing":[false,-1],
      "snorkeling" :[false,-1],
      "snow tubing":[false,-1] ,
      "snowboard" :[false,-1],
      "surf":[false,-1],
      "swimming":[false,-1] ,
      "trail running" :[false,-1],
      "wakeboard":[false,-1],
      "water skiing" :[false,-1],
      "water sports":[false,-1],
      "windsurfing" :[false,-1],

    }
  ),
  new Data(
    'Wellness',
    {
      "hammam":[false,-1] ,
      "spa":[false,-1] ,
      "therms":[false,-1] ,
      "turkish baths":[false,149],
      "wellness" :[false,-1],
    }
  ),
];