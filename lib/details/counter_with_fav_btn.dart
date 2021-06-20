import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:satyamflutter/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'CartCounter.dart';
import 'favourite_button.dart';

class CounterWithFavBtn extends StatelessWidget {
  const CounterWithFavBtn({
    Key key, this.product,
  }) : super(key: key);

  final Product product;

  Future<List> senddata(BuildContext context) async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');
    String qty = prefs.getString('itemcount');


    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_addtowishlist.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {
//    });



    var data = {"userid": id.toString(),
      "productid": product.id.toString(),
//      "qty": qty.toString(),
      "colour": 'test',
      "size": product.size.toString()};

//    var data = {"userid": '1',
//      "productid": '4',
//      "qty": '2',
//      "colour": 'test',
//      "size": '11'};

    var response = await http.post(url, body: json.encode(data));

    var message = jsonDecode(response.body);


    if (message == 'Saved') {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.toString()),
      ));

//    } else {
////      showFloatingFlushbar(context);
//
//      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//        content: Text(message.toString()),
//      ));
    }
  }

  Future<List> deletedata(BuildContext context) async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');
    String qty = prefs.getString('itemcount');


    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_delete_wishlist.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {
//    });



    var data = {"userid": id.toString(),
      "productid": product.id.toString(),
//      "qty": qty.toString(),
      "colour": 'test',
      "size": product.size.toString()};


    var response = await http.post(url, body: json.encode(data));

    var message = jsonDecode(response.body);


    if (message == 'Removed') {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.toString()),
      ));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(),
Text("Available current Stock : "+product.currentstock.toString()),
//        Container(
//          padding: EdgeInsets.all(8),
//          height: 32,
//          width: 32,
//          decoration: BoxDecoration(
//            color: Color(0xFFFF6464),
//            shape: BoxShape.circle,
//          ),
//          child: SvgPicture.asset("images/heart_1.svg"),
//        )
        FavoriteButton(
          isFavorite: false,
          iconSize: 40.0,
          valueChanged: (_isFavorite) {
            if(_isFavorite == true){

              senddata(context);

            } else {

              deletedata(context);

            }

            print('Is Favorite $_isFavorite)');
          },
        ),
      ],
    );
  }
}
