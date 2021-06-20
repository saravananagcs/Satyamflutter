import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:satyamflutter/cart/size_config.dart';
import 'package:satyamflutter/checkout/checkoutScreen.dart';

import 'cart_screen.dart';
//import 'package:shop_app/components/default_button.dart';



class CheckoutCard extends StatelessWidget {

  CheckoutCard(this.cart);

  final List<cart_contacts> cart;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical:(15 / 375.0) * MediaQuery.of(context).size.width,
        horizontal: (30 / 375.0) * MediaQuery.of(context).size.width,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: (40 / 812.0) * MediaQuery.of(context).size.height,
                  width: (40 / 375.0) * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("images/receipt.svg"),
                ),
                Spacer(),
//                Text(
//            "${cart.length} items",
////                  count.toString()+" items",
////                  style: Theme.of(context).textTheme.caption,
//                ),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF757575),
                )
              ],
            ),
            SizedBox(height: (20 / 812.0) * MediaQuery.of(context).size.height),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\₹",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (190 / 375.0) * MediaQuery.of(context).size.width,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: Color(0xFFFF7643),
                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("test"),
                      ));
                    },
                    child: Text(
                      "Check Out".toUpperCase(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}