import 'dart:convert';
//import 'dart:js';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/checkout/checkoutScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_svg/svg.dart';
import '../product/product.dart';
import '../cart/cart_screen.dart';
import 'package:http/http.dart' as http;

class AddToCart extends StatefulWidget {

  AddToCart({
    Key key,
    this.product, this.customer,
  }) : super(key: key);

  final Product product;
  final String customer;

//  final String category;
//  final String subcategory;
//
//  CartScreen(this.category, this.subcategory);

  @override
  AddToCart2 createState() =>
      AddToCart2(product: product,customer: customer);
}


class AddToCart2 extends State<AddToCart> {
  AddToCart2({
    Key key,
    this.product,  this.customer,
  }) ;

  final Product product;
  final String customer;
  String qty;
  String id;
  String email;


  void showFloatingFlushbar(BuildContext context) {
    Flushbar flushbar;
    flushbar = Flushbar(
      title: 'Added to Cart',
      message: product.title.toString(),
      duration: Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticInOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: Colors.blue[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      backgroundGradient: LinearGradient(
        colors: [Colors.blueGrey, Colors.green],
      ),
      isDismissible: false,
      icon: Icon(
        Icons.check,
        color: Colors.yellow,
      ),
      mainButton: FlatButton(
        onPressed: () {
          flushbar.dismiss();
        },
        child: Text(
          'DONE',
          style: TextStyle(color: Colors.white),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
    )..show(context);
  }


  var position;
  LatLng currentPostion;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


  void _getUserLocation() async {
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }



  Future<List> checkoutdata (BuildContext context) async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('username');
    id = prefs.getString('userid');
    qty = prefs.getString('itemcount');

    double a = double.parse(product.price.toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
    double b = double.parse(qty.toString()); // this is my second text field
    double tot = ( a * b ) ;
    String tota = tot.toString();
    String total = tota.toString().substring(0,tota.length-2);
//                  String total = 100.toString();
    String colour = product.color.toString().substring(6, product.color.toString().length-1);

    var qtyvalue = int.parse(qty.toString());
    var curstkvalue = int.parse(product.currentstock.toString());

    if(qtyvalue.compareTo(curstkvalue) < 0){

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(total.toString(),id.toString(),product.id.toString(),product.size.toString(),colour,email.toString(),"Single",customer),
          ));

    }else{
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Available Stock is "+product.currentstock.toString()),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }



  }

  Future<List> senddata(BuildContext context) async {

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    id = prefs.getString('userid');
    qty = prefs.getString('itemcount');

    var qtyvalue = int.parse(qty.toString());
    var curstkvalue = int.parse(product.currentstock.toString());

    if(qtyvalue.compareTo(curstkvalue) < 0){

      var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_addtocart.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {
//    });



      var data = {"userid": id.toString(),
        "productid": product.id.toString(),
        "qty": qty.toString(),
        "colour": product.color.toString().substring(6, product.color.toString().length-1),
        "size": product.size.toString(),
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString()};

//    var data = {"userid": '1',
//      "productid": '4',
//      "qty": '2',
//      "colour": 'test',
//      "size": '11'};

      var response = await http.post(url, body: json.encode(data));

      var message = jsonDecode(response.body);


      if (message == 'added successfully') {
        showFloatingFlushbar(context);
      } else {
//      showFloatingFlushbar(context);
      }

    }else{
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Available Stock is "+product.currentstock.toString()),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }



  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(right: 20.0),
//            height: 50,
//            width: 58,
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(18),
//              border: Border.all(
//                color: product.color as Color,
//              ),
//            ),
//            child: IconButton(
//              icon: Icon(Icons.shopping_cart,
//                color: product.color as Color,
//              ),
//              onPressed: () {senddata(context);},
//            ),
//          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: product.color as Color,
                onPressed: () {

//                  checkoutdata(context);
                  senddata(context);

//                  double a = double.parse(product.price.toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
//                  double b = double.parse(qty.toString()); // this is my second text field
//                  double tot = ( a * b ) ;
//                  String total = tot.toString();
////                  String total = 100.toString();
//
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => CheckoutScreen(total.toString(),id.toString(),product.id.toString()),
//                      ));
                },

                child: Text(
                  "Add To Cart".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

