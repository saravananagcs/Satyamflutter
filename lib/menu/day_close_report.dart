import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class day_close_report extends StatefulWidget {
//  wishlist(this.category, this.subcategory);

  @override
  day_close_report2 createState() => day_close_report2();
}

class day_close_report2 extends State<day_close_report> {
  var id;
  String url;

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
//    if (Platform.isAndroid) WebView.platform = SurfaceAndroidViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Column(children: [
          Expanded(
            child: new WebView(
              initialUrl:
                  'https://www.mireport.in/sms_mobile/Reports/DayCloseReport.php?UID=' +
                      id.toString(),
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        ]));
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
    );
  }
}
