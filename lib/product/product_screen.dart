import 'dart:convert';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_screen.dart';
import 'package:satyamflutter/myorders/myorder_screen.dart';
import 'package:satyamflutter/myorders/order_list.dart';
import 'package:satyamflutter/product/test_search.dart';
import 'package:satyamflutter/wishlist/wishlist.dart';
import '../category/categoryslider.dart';
import '../details/detail_screen.dart';
import 'product.dart';
import 'product_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';
import 'item_card.dart';
import 'package:http/http.dart' as http;



class product_screen extends StatefulWidget {
  final String category;
  final String subcategory;

  product_screen(this.category, this.subcategory);

  @override
  product_screen2 createState() =>
      product_screen2(category.toString(), subcategory.toString());
}

class product_screen2 extends State<product_screen> {
  final String category;
  final String subcategory;


  product_screen2(this.category, this.subcategory);

  int selectedIndex = 0;
  final productlist = new List<Product>();
  var email;
  var id;
  bool activeSearch;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    main();
    activeSearch = false;
  }

  Future<void> downloadJSON() async {
    productlist.clear();
    var data = {
      'category': category.toString(),
      'subcategory': subcategory.toString()
    };
    var url = Uri.parse(
        'https://www.mireport.in/sms_mobile/satyam_flutter_productlist2.php');
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
          currentstock: int.parse(api['currentstock']),
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
              return product_body(subcategory,productlist);
            }
          }),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.white,
          selectedItemBackgroundColor: Colors.orange,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: 1,
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
//          if (selectedIndex == 2) {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => wishlist(),
//                ));
//          }
//          ;
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
//          FFNavigationBarItem(
//            iconData: Icons.favorite,
//            label: 'Wishlist',
//          ),
          FFNavigationBarItem(
            iconData: Icons.assignment_turned_in_rounded,
            label: 'My Orders',
          ),
        ],
      ),
    );
  }





//  AppBar buildAppBar() {
//    if (activeSearch){
//      return AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0,
//        leading: Icon(Icons.search,color: Color(0xFF535353)),
//        title: TextField(
//          decoration: InputDecoration(
//            hintText: "here's a hint",
//          ),
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.close,color: Color(0xFF535353)),
//            onPressed: () => setState(() => activeSearch = false),
//          )
//        ],
//      );
//   }
//    else {
//      return AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Color(0xFF535353)),
//          onPressed: () => Navigator.pop(context),
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.search,
//              // By default our  icon color is white
//              color: Color(0xFF535353),
//            ),
//            onPressed: () => setState(() => activeSearch = true),
//          ),
//          IconButton(
//            icon: Icon(
//              Icons.shopping_cart,
//              // By default our  icon color is white
//              color: Color(0xFF535353),
//            ),
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => cart_screen(),
//                  ));
//            },
//          ),
//          SizedBox(width: 20.0 / 2)
//        ],
//      );
//    }
  }
//}
