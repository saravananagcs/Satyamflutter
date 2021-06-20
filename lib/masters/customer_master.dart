import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class customer_master extends StatefulWidget {
  @override
  customer_masterPageState createState() => customer_masterPageState();
}

class customer_masterPageState extends State<customer_master> {
  String customertype;
  String shoptype;

  String route;
  final customerController = TextEditingController();

  Future<List> customersaver(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');
//    String qty = prefs.getString('itemcount');

    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_customer_saver.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {

//    });

    var data = {
      "userid": id.toString(),
      "customername": customerController.text.toString(),
      "route": route.toString(),
      "customertype": customertype.toString(),
      "shoptype": shoptype.toString(),
    };

    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

//    if (message == 'Added successfully') {

//      Navigator.pop(context);
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
//    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Master'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
//                Text('TextFormField'),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: customerController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        labelText: "Customer Name",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 10.0),
                Text('Customer Type'),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: DropdownButton<String>(
                    value: customertype,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, size: 22),
                    underline: SizedBox(),
                    hint: Text('Select shoptype'),
                    items: <String>['Wholesaler', 'Retailer', 'Distributor']
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //Do something with this value
                      setState(() {
                        customertype = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Text('Shop Type'),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: DropdownButton<String>(
                    value: shoptype,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, size: 22),
                    underline: SizedBox(),
                    hint: Text('Select shoptype'),
                    items: <String>[
                      'Petty Kadai',
                      'Malligai Kadai',
                      'Canteen',
                      'Hotel',
                      'Edu.Institution',
                      'Super Market',
                      'Departmental Store',
                      'Chain of Stores',
                      'Govt. Co.op. Stores',
                      'Company',
                      'Hospital',
                      'Medical Store',
                      'Cinema Theatre'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //Do something with this value
                      setState(() {
                        shoptype = value;
                      });
                    },
                  ),
                ),

                SizedBox(height: 10.0),
                Text('Route'),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: DropdownButton<String>(
                    value: route,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, size: 22),
                    underline: SizedBox(),
                    hint: Text('Select Route'),
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //Do something with this value
                      setState(() {
                        route = value;
                      });
                    },
                  ),
                ),

                SizedBox(height: 30.0),
                MaterialButton(
                  color: Colors.orange,
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    customersaver(context);

                  },
                ),
              ])),
        ));
  }
}
