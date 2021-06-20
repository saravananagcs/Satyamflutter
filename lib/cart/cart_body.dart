import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:satyamflutter/cart/cart_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'cart_card.dart';
import 'package:http/http.dart' as http;

class cart_body extends StatefulWidget {

  List<cart_contacts> cartlist;
  cart_body(this.cartlist);

  @override
  _BodyState createState() => _BodyState(cartlist);
}

class _BodyState extends State<cart_body> {
  List<cart_contacts> cartlist;
  _BodyState(this.cartlist);

  Future<void> downloadJSON2() async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');

    cartlist.clear();
    var data = {
      'userid': id,
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
//    sum = cartlist.map((expense) => expense.total).fold(0, (prev, amount) => prev + amount);
    return cartlist;
  }

  Future<List> itemdelete (BuildContext context,String cartid) async {
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

    }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: (20 / 375.0) * MediaQuery.of(context).size.width),

//      EdgeInsets.symmetric(20),
//      EdgeInsets.only(top: size.height * 0.3),
      child: ListView.builder(
        itemCount: cartlist.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(cartlist[index].cartid.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                cartlist.removeAt(index);

              });
              itemdelete(context,cartlist[index].cartid.toString());
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
            child: CartCard( cart: cartlist[index]),
          ),
        ),
      ),
    );
  }
}

