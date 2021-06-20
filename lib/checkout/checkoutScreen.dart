import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/checkout/changeAddressScreen.dart';
import 'package:satyamflutter/home/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'colors.dart';
import 'customNavBar.dart';
import 'customTextInput.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;

//class Customerdata {
////  String id;
//  String customername;
//
//  Customerdata({
////    this.id,
//    this.customername,
//  });
//
//  factory Customerdata.fromJson(Map<String, dynamic> json) {
//    return Customerdata(
////      id: json['id'],
//      customername: json['customername'],
//    );
//  }
//}

class CheckoutScreen extends StatefulWidget {
  String total;
  String id;
  String productid;
  String size;
  String colour;
  String username;
  String type;
  String customer;

  CheckoutScreen(this.total, this.id, this.productid, this.size, this.colour,
      this.username, this.type, this.customer);

//  final String category;
//  final String subcategory;
//
//  CartScreen(this.category, this.subcategory);

  @override
  CheckoutScreen2 createState() => CheckoutScreen2(
      total, id, productid, size, colour, username, type, customer);
}

class CheckoutScreen2 extends State<CheckoutScreen> {
//  static const routeName = "/checkoutScreen";

  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "India";
  FocusNode textSecondFocusNode = new FocusNode();
  var uuid = Uuid();
  var position;
  LatLng currentPostion;

  String total;
  String id;
  String productid;
  String size;
  String colour;
  String username;
  String type;
  String customer;

  CheckoutScreen2(this.total, this.id, this.productid, this.size, this.colour,
      this.username, this.type, this.customer);

  void _getUserLocation() async {
    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
//      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//        content: Text(currentPostion.toString()),
//      ));
    });
  }

//  Future<List<Customerdata>> fetchFruits() async {
//
//    WidgetsFlutterBinding.ensureInitialized();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
////    email = prefs.getString('username');
//    String route = prefs.getString('route');
//
//    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_customer_spinner.php';
//
//    var data = {
//      "route": route.toString(),
//    };
////    var response = await http
////        .get('https://www.mireport.in/sms_mobile/flutter_customer_spinner.php');
//
//    var response = await http.post(url, body: json.encode(data));
//    var message = jsonDecode(response.body);
//
//    if (response.statusCode == 200) {
//      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
//
//      List<Customerdata> listOfFruits = items.map<Customerdata>((json) {
//        return Customerdata.fromJson(json);
//      }).toList();
//
//      return listOfFruits;
//    } else {
//      throw Exception('Failed to load data.');
//    }
//  }
  var selectedpayment;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
    _getUserLocation();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
            });
          },
          focusNode: textSecondFocusNode,
//          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
//        _isEditingText = true;
          });
        },
        child: Text(
          initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }

  void showFloatingFlushbar(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            height: Helper.getScreenHeight(context) * 0.7,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
//                    IconButton(
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                      icon: Icon(Icons.clear),
//                    ),
                  ],
                ),
                Image.asset(
                  "images/vector4.png",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Thank You!",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "for your order",
                  style: Helper.getTheme(context)
                      .headline4
                      .copyWith(color: AppColor.primary),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                      "Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Track My Order"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  username.toString(), id.toString())));
                    },
                    child: Text(
                      "Back To Home",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<List> placeorder(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');
    String qty = prefs.getString('itemcount');

    var url =
        'https://www.mireport.in/sms_mobile/satyam_flutter_placeorder2.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {

//    });

    var data = {
      "type": type.toString(),
      "userid": id.toString(),
      "productid": productid.toString(),
      "qty": qty.toString(),
      "amount": total.toString(),
      "deliverycost": "0",
      "discount": "0",
      "netamount": total.toString(),
      "address": _editingController.text.toString(),
      "size": size.toString(),
      "colour": colour.toString(),
      "payment": selectedpayment.toString(),
      "uuid": uuid.v1().toString(),
      "customer": customer.toString(),
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
    };

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
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
              label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

//  var selectedcustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Checkout",
                        style: Helper.getTheme(context).headline5,
                      ),
                    ),
                  ],
                ),

//                SizedBox(
//                  height: 20,
//                ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(horizontal: 20),
//                  child: Text("Delivery Address"),
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(horizontal: 20),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      SizedBox(
//                        width: Helper.getScreenWidth(context) * 0.6,
//                        child: _editTitleTextField(),
////                        Text(
////                          "653 Nostrand Ave., Brooklyn, NY 11216",
//////                          style: Helper.getTheme(context).headline3,
////                        ),
//                      ),
//                      TextButton(
//                        onPressed: () {
//                          _isEditingText = true;
//                          FocusScope.of(context)
//                              .requestFocus(textSecondFocusNode);
//                        },
//                        child: Text(
//                          "Change",
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//
//                SizedBox(
//                  height: 20,
//                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Customer"),
                ),
                SizedBox(
                  height: 20,
                ),
                PaymentCard(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(customer),
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
//                      Container(
//                        width: 15,
//                        height: 15,
//                        decoration:
//                        ShapeDecoration(
//                          shape: CircleBorder(
//                            side: BorderSide(color: AppColor.orange),
//                          ),
//                        ),
//                      )
                    ],
                  ),
                ),
//                PaymentCard(
//                  widget: FutureBuilder<List<Customerdata>>(
//                      future: fetchFruits(),
//                      builder: (context, snapshot) {
//                        switch (snapshot.connectionState) {
//                          case ConnectionState.none:
//                          case ConnectionState.waiting:
//                            return Center(child: CircularProgressIndicator());
//                          default:
//                            return Stack(
//                              overflow: Overflow.visible,
//                              children: <Widget>[
//                                StatefulBuilder(builder: (BuildContext context,
//                                    StateSetter dropDownState) {
//                                  return DropdownButton<String>(
//                                    isExpanded: true,
//                                    hint: new Text("Select Customer"),
//                                    value: selectedcustomer,
//                                    underline: Container(),
//                                    items: snapshot?.data.map((data) {
//                                      return new DropdownMenuItem<String>(
//                                        value: data.customername,
//                                        child: new Text(
//                                          data.customername,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.w500),
//                                        ),
//                                      );
//                                    }).toList() ??
//                                        [],
//                                    onChanged: (String value) {
//                                      dropDownState(() {
//                                        selectedcustomer = value;
//                                      });
//                                    },
//                                  );
//                                }),
//                              ],
//                            );
//                        }
//                      }),
//                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment method"),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: Helper.getScreenHeight(context) * 0.7,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Add Credit/Debit Card",
//                                              style: Helper.getTheme(context)
//                                                  .headline3,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Divider(
                                          color: AppColor.placeholder
                                              .withOpacity(0.5),
                                          thickness: 1.5,
                                          height: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInput(
                                            hintText: "card Number"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Expiry"),
                                            SizedBox(
                                              height: 50,
                                              width: 100,
                                              child: CustomTextInput(
                                                hintText: "MM",
                                                padding: const EdgeInsets.only(
                                                    left: 35),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 100,
                                              child: CustomTextInput(
                                                hintText: "YY",
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInput(
                                            hintText: "Security Code"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInput(
                                            hintText: "First Name"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInput(
                                            hintText: "Last Name"),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: Helper.getScreenWidth(
                                                      context) *
                                                  0.4,
                                              child: Text(
                                                  "You can remove this card at anytime"),
                                            ),
                                            Switch(
                                              value: false,
                                              onChanged: (_) {},
                                              thumbColor:
                                                  MaterialStateProperty.all(
                                                AppColor.secondary,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                  ),
                                                  SizedBox(width: 40),
                                                  Text("Add Card"),
                                                  SizedBox(width: 40),
                                                ],
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
//                        child: Row(
//                          children: [
//                            Icon(Icons.add),
//                            Text(
//                              "Add Card",
//                              style: TextStyle(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            )
//                          ],
//                        ),
                      ),
                    ],
                  ),
                ),


                PaymentCard(
                  widget: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownButton<String>(
                          isExpanded: true,
//                          hint: new Text("Select Payment"),
                          value: selectedpayment,
                          underline: Container(),
                          items: <String>['Cash', 'Credit'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            dropDownState(() {
                              selectedpayment = value;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),

//                SizedBox(
//                  height: 10,
//                ),
//                PaymentCard(
//                  widget: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      Row(
//                        children: [
//                          SizedBox(
//                            width: 40,
//                            child: Image.asset("images/visa2.png"),
//                          ),
//                          SizedBox(
//                            width: 10,
//                          ),
//                          Text("**** **** **** 2187"),
//                        ],
//                      ),
//                      Container(
//                        width: 15,
//                        height: 15,
//                        decoration: ShapeDecoration(
//                          shape: CircleBorder(
//                            side: BorderSide(color: AppColor.orange),
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                PaymentCard(
//                  widget: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      Row(
//                        children: [
//                          SizedBox(
//                            width: 40,
//                            height: 30,
//                            child: Image.asset("images/paypal.png"),
//                          ),
//                          SizedBox(
//                            width: 10,
//                          ),
//                          Text("johndoe@gmail.com"),
//                        ],
//                      ),
//                      Container(
//                        width: 15,
//                        height: 15,
//                        decoration: ShapeDecoration(
//                          shape: CircleBorder(
//                            side: BorderSide(color: AppColor.orange),
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total"),
                          Text(
                            "\₹" + total.toString(),
//                            style: Helper.getTheme(context).headline3,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Cost"),
                          Text(
                            "\₹0",
//                            style: Helper.getTheme(context).headline3,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount"),
                          Text(
                            "-\₹0",
//                            style: Helper.getTheme(context).headline3,
                          )
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: AppColor.placeholder.withOpacity(0.25),
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total"),
                          Text(
                            "\₹" + total.toString(),
//                            style: Helper.getTheme(context).headline3,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        placeorder(context);
                      },
                      child: Text("Place Order"),
                    ),
                  ),
                )
              ],
            ),
          ),
//          Positioned(
//            bottom: 0,
//            left: 0,
//            child: CustomNavBar(),
//          ),
        ],
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    Key key,
    Widget widget,
  })  : _widget = widget,
        super(key: key);

  final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: AppColor.placeholder.withOpacity(0.25),
              ),
            ),
            color: AppColor.placeholderBg,
          ),
          child: _widget),
    );
  }
}
