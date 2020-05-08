import "package:flutter/material.dart";

class Walkthrough {
  String icon;
  String title;
  String description;
  Widget extraWidget;
  Color color;
  
  Walkthrough({this.icon, this.title, this.description, this.extraWidget,this.color}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}