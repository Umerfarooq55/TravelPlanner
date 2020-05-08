import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onboarding_flow/product/Product.dart';
import 'package:onboarding_flow/product/ShoppingListItem.dart';


class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.product}) :super(key: key);

  List<Product> product;


  @override
  _ShoppingListState createState() {
    return new _ShoppingListState();
  }
}

class _ShoppingListState extends State<ShoppingList> {

  @override
  Widget build(BuildContext context) {
    return  new ListView(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                children: widget.product.map((Product product) {
                  return new ShoppingItemList(product);
                }).toList(),
    );
  }
}
