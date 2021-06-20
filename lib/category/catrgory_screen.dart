import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_screen.dart';
import 'categoryslider.dart';
import '../details/detail_screen.dart';
import '../product/product.dart';
import '../product/product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../product/item_card.dart';

class subcategorydata {
  int id;
  int categoryid;
  String subcategory;
  String image;

  subcategorydata({
    this.id,
    this.categoryid,
    this.image,
    this.subcategory,
  });

  factory subcategorydata.fromJson(Map<String, dynamic> json) {
    return subcategorydata(
      id: json['id'],
      categoryid: json['categoryid'],
      image: json['image'],
      subcategory: json['subcategory'],
    );
  }
}

class catrgory_screen extends StatefulWidget {
  String category;

  catrgory_screen(this.category);

  @override
  catrgory_screen2 createState() => catrgory_screen2(category);
}

class catrgory_screen2 extends State<catrgory_screen> {
  String category;
  String customer;
  Future<void> _subcategory;

  catrgory_screen2(this.category);

  final subcategorylist = new List<subcategorydata>();

  Future<void> subcategoryJSON() async {
    subcategorylist.clear();
    var data = {'category': category.toString()};
    var url = Uri.parse(
        'https://www.mireport.in/sms_mobile/satyam_flutter_subcategorylist2.php');
    var response = await http.post(url, body: json.encode(data));

    final items = json.decode(response.body);

    items.forEach((api2) {
      final ab2 = new subcategorydata(
          id: int.parse(api2['id']),
          image: api2['image'],
          subcategory: api2['subcategory'],
          categoryid: int.parse(api2['categoryid']));

      subcategorylist.add(ab2);
    });
    return subcategorylist;
  }
  Future<void> getcustomer() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer = prefs.getString('customer');

  }

  @override
  void initState() {
    super.initState();

    getcustomer();

//    _subcategory = subcategoryJSON();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                category,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
//        categoryslider(),

            FutureBuilder(
                future: subcategoryJSON(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                        child: ListView.builder(
                            itemExtent: 200.0,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            scrollDirection: Axis.vertical,
                            itemCount: subcategorylist.length,
                            itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://www.mireport.in/sms_mobile/images/' +
                                              '${subcategorylist.toList()[index].image}'),
                                      fit: BoxFit.cover),
                                ),
                                child: GestureDetector(
                                  onTap: () => {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => product_screen(category.toString(), '${subcategorylist.toList()[index].subcategory}'),
                                  ))
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        '${subcategorylist.toList()[index].subcategory}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ))));
                  }
                }),

//            ListView.builder(
//                itemExtent: 200.0,
//                shrinkWrap: true,
//                physics: ClampingScrollPhysics(),
//                padding: const EdgeInsets.all(8.0),
//                scrollDirection: Axis.vertical,
//                itemCount: subcategorylist.length,
//                itemBuilder: (context, index) => Container(
//                    margin: EdgeInsets.all(5.0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10.0),
//                      image: DecorationImage(
//                          image: NetworkImage(
//                              'https://www.mireport.in/sms_mobile/images/' +
//                                  '${subcategorylist.toList()[index].image}'),
//                          fit: BoxFit.cover),
//                    ),
//                    child: GestureDetector(
//                      onTap: () => {},
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          Text(
//                            '${subcategorylist.toList()[index].subcategory}',
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 28.0,
//                            ),
//                            textAlign: TextAlign.center,
//                          ),
//                        ],
//                      ),
//                    ))),
          ],
        )));
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
