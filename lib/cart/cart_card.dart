import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_body.dart';
import 'package:satyamflutter/cart/size_config.dart';

import 'cart_screen.dart';

//class CartCard extends StatefulWidget {
//
//  const CartCard({
//    Key key,
//    @required this.cart,
//  }) : super(key: key);
//
//  final cart_contacts cart;

//  List<cart_contacts> cartlist;
//  CartCard(this.cartlist);

//  @override
//  CartCard2 createState() => CartCard2(cartlist);
//}
class CartCard extends StatelessWidget  {

//  List<cart_contacts> cartlist;
//  CartCard2(this.cartlist);
  const CartCard({
  Key key,
  @required this.cart,
  }) : super(key: key);

  final cart_contacts cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all((10 / 375.0) * MediaQuery.of(context).size.width),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network('https://www.mireport.in/sms_mobile/images/'+cart.image),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.title,
              style: TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\₹${cart.price}",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                children: [
                  TextSpan(
                      text: " x${cart.qty}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}