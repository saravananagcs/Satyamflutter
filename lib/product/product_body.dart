import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/cart/cart_screen.dart';
import 'package:satyamflutter/checkout/checkoutScreen.dart';
import '../category/categoryslider.dart';
import '../details/detail_screen.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

import 'item_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customerdata {
//  String id;
  String customername;

  Customerdata({
//    this.id,
    this.customername,
  });

  factory Customerdata.fromJson(Map<String, dynamic> json) {
    return Customerdata(
//      id: json['id'],
      customername: json['customername'],
    );
  }
}

class product_body extends StatefulWidget {
  List<Product> list;
  String subcategory;

  product_body(this.subcategory, this.list);

  @override
  product_body2 createState() => product_body2(subcategory, list);
}

class product_body2 extends State<product_body> {
  List<Product> list = [];
  List<Product> _searchResult = [];
  String subcategory;
  TextEditingController controller;

  bool activeSearch;

  String query = '';
  var selectedcustomer;

  product_body2(this.subcategory, this.list);

  Future<List<Customerdata>> fetchFruits() async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String route = prefs.getString('route');

    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_customer_spinner.php';

    var data = {
      "route": route.toString(),
    };
//    var response = await http
//        .get('https://www.mireport.in/sms_mobile/flutter_customer_spinner.php');

    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();

      List<Customerdata> listOfFruits = items.map<Customerdata>((json) {
        return Customerdata.fromJson(json);
      }).toList();

      return listOfFruits;
    } else {
      throw Exception('Failed to load data.');
    }
  }
  Future customersave(String customer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customer', customer);
  }


  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    activeSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildAppBar(),

        PaymentCard(
          widget: FutureBuilder<List<Customerdata>>(
              future: fetchFruits(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        StatefulBuilder(builder: (BuildContext context,
                            StateSetter dropDownState) {
                          return DropdownButton<String>(
                            isExpanded: true,
                            hint: new Text("Select Customer"),
                            value: selectedcustomer,
                            underline: Container(),
                            items: snapshot?.data.map((data) {
                              return new DropdownMenuItem<String>(
                                value: data.customername,
                                child: new Text(
                                  data.customername,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList() ??
                                [],
                            onChanged: (String value) {
                              dropDownState(() {
                                selectedcustomer = value;
                                customersave(selectedcustomer.toString());
                              });
                            },
                          );
                        }),
                      ],
                    );
                }
              }),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: (subcategory == '%')
                ? Text(
                    "All",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : Text(
                    subcategory,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
//        categoryslider(),
        Expanded(
//            color: Colors.white,
            child: query.isEmpty
                ? GridView.builder(
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) => ItemCard(
                          product: list[index],
                          press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => details_screen(
                                  product: list[index],customer: selectedcustomer.toString()
                                ),
                              )),
                        ))
                : GridView.builder(
                    itemCount: _searchResult.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) => ItemCard(
                          product: _searchResult[index],
                          press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => details_screen(
                                  product: _searchResult[index],
                                ),
                              )),
                        ))
//          child: Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 20.0),
//            child: GridView.builder(
//                itemCount: list.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                  mainAxisSpacing: 20.0,
//                  crossAxisSpacing: 20.0,
//                  childAspectRatio: 0.75,
//                ),
//                itemBuilder: (context, index) => ItemCard(
//                      product: list[index],
//                      press: () => Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => details_screen(
//                              product: list[index],
//                            ),
//                          )),
//                    )),
//          ),
            ),
      ],
    );
  }
  void setResults(String query) {
    _searchResult = list
        .where((elem) =>
    elem.title
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()) ||
        elem.title
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

//  onSearchTextChanged(String text) async {
//    _searchResult.clear();
//    if (text.isEmpty) {
//      setState(() {});
//      return;
//    }
//
//    list.forEach((userDetail) {
//      if (userDetail.title.toLowerCase().contains(text) ||
//          userDetail.title.toLowerCase().contains(text))
//        _searchResult.add(userDetail);
//    });
//
//    setState(() {});
//  }

  AppBar buildAppBar() {
    if (activeSearch) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.search, color: Color(0xFF535353)),
        title: TextField(
          controller: controller,
          onChanged: (v) {
            setState(() {
              query = v;
              setResults(query);
            });
          },
          decoration: InputDecoration(
            hintText: "here's a hint",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Color(0xFF535353)),
            onPressed: () => setState(() => {
              activeSearch = false,
              controller.clear(),
              setResults('')}
    ),
          )
        ],
      );
    } else {
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
            onPressed: () => setState(() => activeSearch = true),
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
                    builder: (context) => cart_screen(selectedcustomer.toString()),
                  ));
            },
          ),
          SizedBox(width: 20.0 / 2)
        ],
      );
    }
  }
}
