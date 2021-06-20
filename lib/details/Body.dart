import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../product/product.dart';
import '../product/product_title_with_image.dart';

import 'AddToCart.dart';
import 'ColorAndSize.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';

class Body extends StatelessWidget {
  final Product product;
  final String customer;

  const Body({Key key, this.product, this.customer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: 20.0,
                    right: 20.0,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ColorAndSize(product: product),
                      SizedBox(height: 20.0 / 2),
                      Description(product: product),
                      SizedBox(height: 20.0 / 2),
                      CounterWithFavBtn(product: product),
                      SizedBox(height: 20.0 / 2),
                      AddToCart(product: product,customer: customer)
                    ],
                  ),
                ),
                ProductTitleWithImage(product: product)
              ],
            ),
          )
        ],
      ),
    );
  }
}