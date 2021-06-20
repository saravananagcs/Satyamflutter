//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_screen.dart';
//import 'package:flutter_svg/svg.dart';
import 'Body.dart';
import '../product/product.dart';

class details_screen extends StatelessWidget {
  final Product product;
  final String customer;

  const details_screen({Key key, this.product,this.customer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: product.color as Color,
      appBar: buildAppBar(context),
      body: Body(product: product,customer : customer),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color as Color,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => cart_screen(customer),
                ));
          },
        ),
        SizedBox(width: 20.0 / 2)
      ],
    );
  }
}