import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class catlog_screen extends StatefulWidget {
//  wishlist(this.category, this.subcategory);

  @override
  catlog_screen2 createState() => catlog_screen2();
}

class catlog_screen2 extends State<catlog_screen> {

  @override
  void initState() {
    super.initState();
//    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: 'https://www.mireport.in/sms_mobile/satyam_flutter_catelog.php'))
          ],
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
//      title: Text("Catalog"),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF535353)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
//        IconButton(
//          icon: Icon(
//            Icons.search,
//            // By default our  icon color is white
//            color: Color(0xFF535353),
//          ),
//          onPressed: () {},
//        ),
//        IconButton(
//          icon: Icon(
//            Icons.shopping_cart,
//            // By default our  icon color is white
//            color: Color(0xFF535353),
//          ),
//          onPressed: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => cart_screen(),
//                ));
//          },
//        ),
//        SizedBox(width: 20.0 / 2)
      ],
    );
  }
}
