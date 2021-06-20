import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;
  const ItemCard({
     Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
//               width: 160,

              decoration: BoxDecoration(
                color: product.color as Color,
                borderRadius: BorderRadius.circular(16),

              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.network('https://www.mireport.in/sms_mobile/images/'+product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(color: Color(0xFFACACAC)),
            ),
          ),
          Text(
            "\₹${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}