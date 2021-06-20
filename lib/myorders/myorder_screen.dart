import 'dart:convert';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/home/home.dart';
import 'package:satyamflutter/product/product_screen.dart';
import 'package:satyamflutter/wishlist/wishlist.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class orders_contacts {
  final String image, title, description, customer;
  final int price, size, id, qty;
  final Color color;

  orders_contacts({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
    this.qty,
    this.customer,
  });
}

class myorder_screen extends StatefulWidget {
  String uuid;

  myorder_screen(this.uuid);

  @override
  myorder_screen2 createState() => myorder_screen2(uuid);
}

class myorder_screen2 extends State<myorder_screen> {

  final cartlist = new List<orders_contacts>();
  var email;
  var id;
  var sum;
  int count;
  String uuid;

  myorder_screen2(this.uuid);

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
      'userid': id.toString(),
      'uuid': uuid.toString(),
    };
    var url =
        Uri.parse('https://www.mireport.in/sms_mobile/satyam_flutter_myorders.php');
    var response = await http.post(url, body: json.encode(data));

    final items = json.decode(response.body);

    items.forEach((api) {
      final ab = new orders_contacts(
        id: int.parse(api['id']),
        title: api['product'],
        price: int.parse(api['price']),
        size: int.parse(api['size']),
        image: api['image'],
        color: Color(int.parse(api['colour'])),
        description: api['description'],
        qty: int.parse(api['qty']),
        customer: api['customername'],
      );
      cartlist.add(ab);
    });
//    sum = cartlist.map((expense) => expense.total).fold(0, (prev, amount) => prev + amount);
    return cartlist;
  }

  int selectedIndex = 0;

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
                  body: Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: AspectRatio(
                                aspectRatio: 0.88,
                                child: Container(
                                  padding: EdgeInsets.all((10 / 375.0) *
                                      MediaQuery.of(context).size.width),
                                  decoration: BoxDecoration(
                                    color: cartlist[index].color,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.network(
                                      'https://www.mireport.in/sms_mobile/images/' +
                                          cartlist[index].image),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartlist[index].customer,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartlist[index].title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 10),
                                Text.rich(
                                  TextSpan(
                                    text: "Net amount : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.black),
                                      children: [
                                        TextSpan(
                                            text: "\₹${cartlist[index].price}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFFF7643)),)
                                      ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text.rich(
                                  TextSpan(
                                    text: "Size : ${cartlist[index].size}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: " ,  Qty : ${cartlist[index].qty}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
//                  bottomNavigationBar: FFNavigationBar(
//                    theme: FFNavigationBarTheme(
//                      barBackgroundColor: Colors.white,
//                      selectedItemBorderColor: Colors.white,
//                      selectedItemBackgroundColor: Colors.green,
//                      selectedItemIconColor: Colors.white,
//                      selectedItemLabelColor: Colors.black,
//                    ),
//                    selectedIndex: 3,
//                    onSelectTab: (index) {
//                      setState(() {
//                        selectedIndex = index;
//                      });
//                      if (selectedIndex == 0) {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) =>
//                                  ProfileScreen(email.toString(), id),
//                            ));
//                      }
//
//                      if (selectedIndex == 1) {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => product_screen("%", "%"),
//                            ));
//                      }
//                      if (selectedIndex == 2) {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => wishlist(),
//                            ));
//                      }
//                      ;
////                      if (selectedIndex == 3) {
////                        Navigator.push(
////                            context,
////                            MaterialPageRoute(
////                              builder: (context) => myorder_screen(),
////                            ));
////                      }
////                      ;
//                    },
//                    items: [
//                      FFNavigationBarItem(
//                        iconData: Icons.home,
//                        label: 'Home',
//                      ),
//                      FFNavigationBarItem(
//                        iconData: Icons.list,
//                        label: 'Products',
//                      ),
//                      FFNavigationBarItem(
//                        iconData: Icons.favorite,
//                        label: 'Wishlist',
//                      ),
//                      FFNavigationBarItem(
//                        iconData: Icons.assignment_turned_in_rounded,
//                        label: 'My Orders',
//                      ),
//                    ],
//                  ),
                ));
          }
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${cartlist.length} items",
//            count.toString() + " items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
