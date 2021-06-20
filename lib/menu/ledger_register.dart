import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ledger_register extends StatefulWidget {
//  wishlist(this.category, this.subcategory);

  @override
  ledger_register2 createState() => ledger_register2();
}

class ledger_register2 extends State<ledger_register> {

  String id;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  useridpicker() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('userid');
    });
  }

  @override
  void initState() {
    super.initState();
    useridpicker();
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

                    initialUrl: 'https://www.mireport.in/sms_mobile/Reports/CustomerTransaction.php?UID='+id.toString(),
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) {
    _controller.complete(webViewController);
    },
                ))]));
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
