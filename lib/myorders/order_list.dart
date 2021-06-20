import 'dart:convert';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/home/home.dart';
import 'package:satyamflutter/product/product_screen.dart';
import 'package:satyamflutter/wishlist/wishlist.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'myorder_screen.dart';

class orders_contacts {
  final String uuid, customername, addedon;

  orders_contacts({
    this.uuid,
    this.customername,
    this.addedon,
  });
}

class order_list extends StatefulWidget {
  @override
  order_list2 createState() => order_list2();
}

class order_list2 extends State<order_list> {
  final cartlist = new List<orders_contacts>();
  var email;
  var id;

  var sum;
  int count;

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
    };
    var url =
        Uri.parse('https://www.mireport.in/sms_mobile/satyam_flutter_orderlist.php');
    var response = await http.post(url, body: json.encode(data));

    final items = json.decode(response.body);

    items.forEach((api) {
      final ab = new orders_contacts(
        uuid: api['uuid'],
        customername: api['customername'],
        addedon: api['addedon'],
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
                      itemBuilder: (context, index) =>
                              GestureDetector( //You need to make my child interactive
                             onTap: () =>
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => myorder_screen(cartlist[index].uuid.toString()),
                                     )),
//                                 print(cartlist[index].uuid),
                               child : Card(
                          shadowColor: Colors.grey,
                          color: Colors.white,
                          child: Row(children: [
                            SizedBox(width: 20, height: 80),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartlist[index].customername,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  cartlist[index].addedon,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ],
                            )
                          ]))),
//                          Padding(
//                        padding:
//                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                        child: Row(
//                          children: [
//                            SizedBox(width: 20),
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Text(
//                                  cartlist[index].customername,
//                                  style: TextStyle(
//                                      color: Colors.blue,
//                                      fontSize: 18,
//                                      fontWeight: FontWeight.bold),
//                                  maxLines: 2,
//                                ),
//                                SizedBox(height: 5),
//                                Text(
//                                  cartlist[index].addedon,
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 16,
//                                      fontWeight: FontWeight.bold),
//                                  maxLines: 2,
//                                ),
//
//                              ],
//                            )
//                          ],
//                        ),
//                      ),
                    ),
                  ),
                  bottomNavigationBar: FFNavigationBar(
                    theme: FFNavigationBarTheme(
                      barBackgroundColor: Colors.white,
                      selectedItemBorderColor: Colors.white,
                      selectedItemBackgroundColor: Colors.green,
                      selectedItemIconColor: Colors.white,
                      selectedItemLabelColor: Colors.black,
                    ),
                    selectedIndex: 2,
                    onSelectTab: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (selectedIndex == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(email.toString(), id),
                            ));
                      }

                      if (selectedIndex == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => product_screen("%", "%"),
                            ));
                      }
//                      if (selectedIndex == 2) {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => wishlist(),
//                            ));
//                      }
//                      ;
                      if (selectedIndex == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => order_list(),
                            ));
                      }
                      ;
                    },
                    items: [
                      FFNavigationBarItem(
                        iconData: Icons.home,
                        label: 'Home',
                      ),
                      FFNavigationBarItem(
                        iconData: Icons.list,
                        label: 'Products',
                      ),
//                      FFNavigationBarItem(
//                        iconData: Icons.favorite,
//                        label: 'Wishlist',
//                      ),
                      FFNavigationBarItem(
                        iconData: Icons.assignment_turned_in_rounded,
                        label: 'My Orders',
                      ),
                    ],
                  ),
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
