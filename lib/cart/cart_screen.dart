import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:satyamflutter/checkout/checkoutScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'cart_body.dart';
import 'cart_card.dart';
import 'check_out_card.dart';
import 'package:http/http.dart' as http;

class cart_contacts {
  final String image, title, description;
  final int price, size, id, qty, total, cartid;
  final Color color;

  cart_contacts({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
    this.qty,
    this.total,
    this.cartid,
  });


}


class cart_screen extends StatefulWidget {

  String customer;

  cart_screen(this.customer);

//  final String category;
//  final String subcategory;
//
//  CartScreen(this.category, this.subcategory);

  @override
  CartScreen2 createState() => CartScreen2(customer);
}

class CartScreen2 extends State<cart_screen> {
  final cartlist = new List<cart_contacts>();
  var email;
  var id;

  var sum;
  int count;
  Timer _everySecond;
  String customer;

  CartScreen2(this.customer);


  Future<List> checkoutdata(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username');
    String id = prefs.getString('userid');
    String qty = prefs.getString('itemcount');

//  double a = double.parse(product.price.toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
//  double b = double.parse(qty.toString()); // this is my second text field
//  double tot = ( a * b ) ;
//  String total = tot.toString();


//                  String total = 100.toString();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CheckoutScreen(
                  sum.toString(),
                  id.toString(),
                  "0",
                  "0",
                  "0",
                  "0",
                  "Multi",
                  customer),
        ));
  }

  @override
  void initState() {
    super.initState();
  }


  Future<void> downloadJSON2() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('username');
    id = prefs.getString('userid');

    cartlist.clear();
    var data = {
      'userid': id,
      'customer': customer.toString()
    };
    var url =
    Uri.parse('https://www.mireport.in/sms_mobile/satyam_flutter_cartlist.php');
    var response = await http.post(url, body: json.encode(data));

    final items = json.decode(response.body);

    items.forEach((api) {
      final ab = new cart_contacts(
          id: int.parse(api['id']),
          qty: int.parse(api['qty']),
          image: api['image'],
          title: api['product'],
          price: int.parse(api['price']),
          description: api['description'],
          size: int.parse(api['size']),
          total: int.parse(api['total']),
          cartid: int.parse(api['cartid']),
          color: Color(int.parse(api['colour'])));
      cartlist.add(ab);
    });
    sum = cartlist.map((expense) => expense.total).fold(
        0, (prev, amount) => prev + amount);
    return cartlist;
  }

  Future<List> itemdelete(BuildContext context, String cartid) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('userid');

    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_delete_item.php';
    var data = {
      "userid": id.toString(),
      "cartid": cartid.toString(),
    };

    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
    ));

//    downloadJSON2();

  }


  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('username');
    id = prefs.getString('userid');
//    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: downloadJSON2(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return WillPopScope(
                onWillPop: () async {
                  return Navigator.canPop(context);
                },
                child: Scaffold(
                  appBar: buildAppBar(context),
                  body:
                  Container(
                      child: ListView.builder(
                        itemCount: cartlist.length,
                        itemBuilder: (context, index) =>
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                key: Key(cartlist[index].cartid.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    itemdelete(context,
                                        cartlist[index].cartid.toString());
                                    cartlist.removeAt(index);
                                  });
                                },
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset("images/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: CartCard(cart: cartlist[index]),
                              ),
                            ),
                      )),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (15 / 375.0) * MediaQuery
                          .of(context)
                          .size
                          .width,
                      horizontal: (30 / 375.0) * MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                height: (40 / 812.0) * MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                width: (40 / 375.0) * MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F6F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset("images/receipt.svg"),
                              ),
                              Spacer(),
                              Text("Selected Customer :   "+customer),
                              const SizedBox(width: 10),
//                              Icon(
//                                Icons.arrow_forward_ios,
//                                size: 12,
//                                color: Color(0xFF757575),
//                              )
                            ],
                          ),
                          SizedBox(height: (20 / 812.0) * MediaQuery
                              .of(context)
                              .size
                              .height),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Total:\n",
                                  children: [
                                    TextSpan(
//                                  text: "₹"+cartlist[0].price.toString(),
                                      text: "₹" + sum.toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (190 / 375.0) * MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  color: Color(0xFFFF7643),
                                  onPressed: () {
                                    checkoutdata(context);

//                                List<String> chckList = cartlist.map((e) => json.encode(e.toJson())).toList();
//                                addcart(cartlist,context);
//                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                  content: Text(json.encode(chckList)),
//                                ));
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
                  ),
                ));
          }
        }
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${cartlist.length} items",
//            count.toString() + " items",
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
        ],
      ),
    );
  }
}
