import 'dart:convert';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_screen.dart';
import 'package:satyamflutter/home/home.dart';
import 'package:satyamflutter/myorders/myorder_screen.dart';
import 'package:satyamflutter/myorders/order_list.dart';
import 'package:satyamflutter/product/product.dart';
import 'package:satyamflutter/product/product_body.dart';
import 'package:satyamflutter/product/product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class wishlist extends StatefulWidget {


//  wishlist(this.category, this.subcategory);

  @override
  wishlist2 createState() =>
      wishlist2();
}

class wishlist2 extends State<wishlist> {
//  final String category;
//  final String subcategory;
//
//
//  wishlist2(this.category, this.subcategory);

  int selectedIndex = 0;
  final productlist = new List<Product>();
  var email;
  var id;
  String customer;

  @override
  void initState() {
    super.initState();
    main();
  }

  Future<void> downloadJSON() async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('username');
    id = prefs.getString('userid');

    productlist.clear();
    var data = {
      'userid': id.toString(),
//      'subcategory': subcategory.toString()
    };
    var url = Uri.parse(
        'https://www.mireport.in/sms_mobile/satyam_flutter_wishlist.php');
    var response = await http.post(url, body: json.encode(data));

    final items = json.decode(response.body);

    items.forEach((api) {
      final ab = new Product(
          id: int.parse(api['id']),
          image: api['image'],
          title: api['product'],
          price: int.parse(api['price']),
          description: api['description'],
          size: int.parse(api['size']),
          color: Color(int.parse(api['colour'])));
      productlist.add(ab);
    });
    return productlist;
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('username');
    id = prefs.getString('userid');
    customer = prefs.getString('customer');
//    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: buildAppBar(),
      body: FutureBuilder(
          future: downloadJSON(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return product_body("Wishlist",productlist);
            }
          }),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.white,
          selectedItemBackgroundColor: Colors.red,
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
                  builder: (context) => ProfileScreen(email.toString(), id),
                ));
          }

          if (selectedIndex == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => product_screen("%", "%"),
                ));
          }
          if (selectedIndex == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => wishlist(),
                ));
          }
          ;
          if (selectedIndex == 3) {
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
          FFNavigationBarItem(
            iconData: Icons.favorite,
            label: 'Wishlist',
          ),
          FFNavigationBarItem(
            iconData: Icons.assignment_turned_in_rounded,
            label: 'My Orders',
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF535353)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            // By default our  icon color is white
            color: Color(0xFF535353),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            // By default our  icon color is white
            color: Color(0xFF535353),
          ),
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
