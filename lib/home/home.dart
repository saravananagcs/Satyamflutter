import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satyamflutter/catalog/catlog_screen.dart';
import 'package:satyamflutter/checkout/checkoutScreen.dart';
import 'package:satyamflutter/constants/constants.dart';
import 'package:satyamflutter/login/login.dart';
import 'package:satyamflutter/masters/customer_master.dart';
import 'package:satyamflutter/masters/product_master.dart';
import 'package:satyamflutter/menu/day_close_report.dart';
import 'package:satyamflutter/menu/day_closing.dart';
import 'package:satyamflutter/menu/ledger_register.dart';
import 'package:satyamflutter/menu/outstanding_report.dart';
import 'package:satyamflutter/menu/payment_collection.dart';
import 'package:satyamflutter/menu/sales_report.dart';
import 'package:satyamflutter/menu/stock_report.dart';
import 'package:satyamflutter/menu/stock_transfer.dart';
import 'package:satyamflutter/menu/stock_transfer_report.dart';
import 'package:satyamflutter/myorders/myorder_screen.dart';
import 'package:satyamflutter/myorders/order_list.dart';
import 'package:satyamflutter/wishlist/wishlist.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shimmer/shimmer.dart';
import '../details/detail_screen.dart';
import '../product/product.dart';
import '../product/product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import '../category/categoryslider.dart';
import '../category/catrgory_screen.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../product/item_card.dart';
//import 'package:location/location.dart';


class Fruitdata {
  String id;
  String route;

  Fruitdata({
    this.id,
    this.route,
  });

  factory Fruitdata.fromJson(Map<String, dynamic> json) {
    return Fruitdata(
      id: json['id'],
      route: json['route'],
    );
  }
}

class categorydata {
  int id;
  String category;
  String image;

  categorydata({
    this.id,
    this.category,
    this.image,
  });

  factory categorydata.fromJson(Map<String, dynamic> json) {
    return categorydata(
      id: json['id'],
      category: json['category'],
      image: json['image'],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String email;
  final String id;

  const ProfileScreen(this.email, this.id);

  @override
  HomePage createState() => HomePage(email, id);
}

class HomePage extends State<ProfileScreen> {

  final String email;
  final String id;
  int selectedIndex = 0;
  HomePage(this.email, this.id);
  final list = new List<Product>();
  final categorylist = new List<categorydata>();
  bool showImageWidget = false;
  LatLng currentPostion;
  var position;


  @override
  void initState() {
    super.initState();
    downloadJSON();
    categoryJSON();
    fetchFruits();
    _getUserLocation();

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showImageWidget = true;
      });
    });
  }

  void _getUserLocation() async {

    position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(currentPostion.toString()),
      ));
    });

  }




  Future<void> categoryJSON() async {
    categorylist.clear();

    var url = Uri.parse(
        'https://www.mireport.in/sms_mobile/satyam_flutter_categorylist.php');
    var response = await http.get(url);

    final items = json.decode(response.body);

    items.forEach((api2) {
      final ab2 = new categorydata(
          id: int.parse(api2['id']),
          image: api2['image'],
          category: api2['category']);

      categorylist.add(ab2);
    });
  }

  Future<void> downloadJSON() async {
    list.clear();

    var url =
        Uri.parse('https://www.mireport.in/sms_mobile/satyam_flutter_productlist.php');
    var response = await http.get(url);

    final items = json.decode(response.body);

    items.forEach((api) {
      final ab = new Product(
          id: int.parse(api['id']),
          image: api['image'],
          title: api['product'],
          price: int.parse(api['price']),
          description: api['description'],
          size: int.parse(api['size']),
          currentstock : int.parse(api['currentstock']),
          color: Color(int.parse(api['colour'])));
      list.add(ab);
    });
  }

  Future<void> Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggin_value', "No");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginUser()));
    print("you choose yes");
  }


  Future<List<Fruitdata>> fetchFruits() async {

    var response = await http
        .get('https://www.mireport.in/sms_mobile/satyam_flutter_route_spinner.php');

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Fruitdata> listOfFruits = items.map<Fruitdata>((json) {
        return Fruitdata.fromJson(json);
      }).toList();

      return listOfFruits;
    } else {
      throw Exception('Failed to load data.');
    }

  }

  Future<List> routesaver(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    email = prefs.getString('username');
    String id = prefs.getString('userid');
//    String qty = prefs.getString('itemcount');

    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_route_saver.php';

//    final response = await http.post("https://www.mireport.in/sms_mobile/flutter_addtocart.php", body: {

//    });

    var data = {
      "userid": id.toString(),
      "date": finalDate.toString(),
      "route": selectedroute.toString(),
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
    };

    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    if (message == 'added successfully') {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('route', selectedroute.toString());

      Navigator.pop(context);
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

  var selectedroute;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Image.asset('images/satyamlogo.jpeg',
                fit: BoxFit.cover, height: 62.00, width: 107.00),
            iconTheme: IconThemeData(color: CupertinoColors.black),
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_rounded),
                tooltip: 'Logout',
                color: CupertinoColors.black,
                onPressed: () {
                  showAlertDialog(context);
                },
              ),
            ],
          ),
          drawer: Drawer(

            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[
                Container(
                  height: 38,
                  margin: const EdgeInsets.only(bottom: 10, top: 10, left: 5),
                  child: Image.asset('images/satyamlogo.jpeg'),
                ),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.alt_route, size: 20),
                    title: Text("Today's Plan"),
                    onTap: () => showpopupDialog(context)),
            ListTile(
                leading: const Icon(Icons.airplay_rounded, size: 20),
                title: Text("Catalog"),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              catlog_screen()),
                    )),
                ListTile(
                    leading: const Icon(Icons.access_time, size: 20),
                    title: Text("Day Closing"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              day_closing()),
                    )),
                Divider(), //here is a divider
                Text("Collection",style: TextStyle(fontSize: 16.0,
                    color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined, size: 20),
                    title: Text("Payment Collection"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              payment_collection()),
                    )),Divider(), //here is a divider
                Text("Inventory",style: TextStyle(fontSize: 16.0,
                    color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                ListTile(
                    leading: const Icon(Icons.add_chart, size: 20),
                    title: Text("Stock Report"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              stock_report()),
                    )),
                ListTile(
                    leading: const Icon(Icons.art_track_outlined, size: 20),
                    title: Text("Stock Transfer"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              stock_transfer()),
                    )),
                Divider(), //here is a divider
                Text("Reports",style: TextStyle(fontSize: 16.0,
                    color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                ListTile(
                    leading: const Icon(Icons.assignment_ind_outlined, size: 20),
                    title: Text("Day Close Report"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              day_close_report()),
                    )),
                ListTile(
                    leading: const Icon(Icons.assignment_turned_in_outlined, size: 20),
                    title: Text("Stock Transfer Report"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              stock_transfer_report()),
                    )),
                ListTile(
                    leading: const Icon(Icons.add_task_outlined , size: 20),
                    title: Text("Sales Report"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              sales_report()),
                    )),
                ListTile(
                    leading: const Icon(Icons.app_registration_rounded, size: 20),
                    title: Text("Ledger Register"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ledger_register()),
                    )),

                ListTile(
                    leading: const Icon(Icons.upcoming_outlined, size: 20),
                    title: Text("Outstanding Report"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              outstanding_report()),
                    )),
                Divider(), //here is a divider
                Text("Masters",style: TextStyle(fontSize: 16.0,
                  color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                ListTile(
                    leading: const Icon(Icons.contact_mail_outlined, size: 20),
                    title: Text("Customer master"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              customer_master()),
                    )),
                ListTile(
                    leading: const Icon(Icons.storefront_outlined, size: 20),
                    title: Text("Product master"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              product_master()),
                    )),
              ],
            ),
          ),

          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
//              categoryslider(),
                  new SizedBox(
                    height: 8.0,
                  ),
              showImageWidget
                  ? CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,

                        // enlargeCenterPage: true,
                        //scrollDirection: Axis.vertical,
                        onPageChanged: (index, reason) {
                          setState(
                            () {
                              _currentIndex = index;
                            },
                          );
                        },
                      ),
                      items: categorylist.map((imageUrl) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://www.mireport.in/sms_mobile/images/' +
                                            imageUrl.image),
                                    fit: BoxFit.cover),
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => catrgory_screen(
                                            imageUrl.category))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      imageUrl.category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ));
                        });
                      }).toList(),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        child: Card(
                          color: Colors.grey,
                        ),
                        baseColor: Colors.white70,
                        highlightColor: Colors.grey[200],
                        direction: ShimmerDirection.ltr,
                      )),
              CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,

                    autoPlay: true,
                    // enlargeCenterPage: true,
                    //scrollDirection: Axis.vertical,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          _currentIndex = index;
                        },
                      );
                    },
                  ),
                  items: [
                    Container(
                      height: 150.0,
                      margin: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
                          gradient: new LinearGradient(
                              colors: [Colors.yellow, Colors.redAccent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              tileMode: TileMode.clamp)),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    AssetImage('images/ordertaking.jpg'),
                              )),
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Orders Taken',
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          )),
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 20.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    '73',
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white70),
                                  ),
                                  new Text(
                                    'Qty',
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.white70),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 150.0,
                      margin: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
                          gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              tileMode: TileMode.clamp)),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    AssetImage('images/customer.jpg'),
                              )),
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Customers Visited',
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),

                            ],
                          )),
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 20.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    '12',
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white70),
                                  ),
                                  new Text(
                                    'Shops',
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.white70),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 150.0,
                      margin: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
                          gradient: new LinearGradient(
                              colors: [Colors.pinkAccent, Colors.purple],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              tileMode: TileMode.clamp)),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    AssetImage('images/collection.jpg'),
                              )),
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Today Collection',
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          )),
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 20.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    '53',
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white70),
                                  ),
                                  new Text(
                                    'Thousand',
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.white70),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 150.0,
                      margin: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
                          gradient: new LinearGradient(
                              colors: [Colors.green, Colors.orange],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              tileMode: TileMode.clamp)),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    AssetImage('images/overdue.jpg'),
                              )),
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Total Overdue',
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          )),
                          new Padding(
                              padding:
                                  new EdgeInsets.only(left: 10.0, right: 20.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    '11',
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white70),
                                  ),
                                  new Text(
                                    'Lakhs',
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.white70),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Popular Products",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
                  showImageWidget
                      ?
              SizedBox(
                height: 250.0,
                child: ListView.builder(
                  itemExtent: 200.0,
                  shrinkWrap: true,
//            physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => ItemCard(
                    product: list[index],
                    press: () => {},
//                        Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => details_screen(
//                            product: list[index],
//                          ),
//                        )),
                  ),
                ),
              ): SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        child: Card(
                          color: Colors.grey,
                        ),
                        baseColor: Colors.white70,
                        highlightColor: Colors.grey[200],
                        direction: ShimmerDirection.ltr,
                      )),
            ]),
          ),
          bottomNavigationBar: FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemBackgroundColor: Colors.blue,
              selectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.black,
            ),
            selectedIndex: 0,
            onSelectTab: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (selectedIndex == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(email.toString(), id),
                    ));
              }

              if (selectedIndex == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => product_screen("%", "%"),
                    ));
              }
//              if (selectedIndex == 2) {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => wishlist(),
//                    ));
//              };
              if (selectedIndex == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => order_list(),
                    ));
              };
            },
            items: [
              FFNavigationBarItem(
                iconData: Icons.home,
                label: 'Home',
              ),
              FFNavigationBarItem(
                iconData: Icons.list,
                label: 'Products',
              ),
//              FFNavigationBarItem(
//                iconData: Icons.favorite,
//                label: 'Wishlist',
//              ),
              FFNavigationBarItem(
                iconData: Icons.assignment_turned_in_rounded,
                label: 'My Orders',
              ),
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Warning!'),
      content: Text('Do you want to logut?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            print("you choose no");
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Logout();
          },
          child: Text('Yes'),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String finalDate = '';
  String day = '';

  getCurrentDate() {
    var date = new DateTime.now().toString();
    var date2 = new DateTime.now();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

//    setState(() {

    finalDate = formattedDate.toString();
    day = DateFormat('EEEE').format(date2);

//     day = new DateTime.now().weekday.toString();

//    });
  }

  showpopupDialog(BuildContext context) {
    // set up the AlertDialog
    getCurrentDate();
//    fetchFruits();

    AlertDialog alert = AlertDialog(
      content: FutureBuilder<List<Fruitdata>>(
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
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
//                            key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Today's Plan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Text(
                                "$finalDate , $day",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PaymentCard(widget: StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter dropDownState) {
                              return DropdownButton<String>(
                                isExpanded: true,
                                hint: new Text("Select Route"),
                                value: selectedroute,
                                underline: Container(),
                                items: snapshot?.data.map((data) {
                                      return new DropdownMenuItem<String>(
                                        value: data.route,
                                        child: new Text(
                                          data.route,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                                onChanged: (String value) {
                                  dropDownState(() {
                                    selectedroute = value;
                                  });
                                },
                              );
                            })),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white, // light
                                    fontStyle: FontStyle.italic, // italic
                                  ),
                                ),
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.pop(context);
                                  routesaver(context);

//                                      if (_formKey.currentState.validate()) {
//                                        _formKey.currentState.save();
//                                      }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
            }
          }),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Column getCardByTitle(String title) {
    String img = "";
    if (title == "Customer")
      img = "images/pic1.jpg";
    else if (title == "Product")
      img = "images/pic4.png";
    else if (title == "Sales")
      img = "images/pic2.png";
    else if (title == "Collection")
      img = "images/pic3.png";
    else if (title == "Inventory")
      img = "images/pic5.png";
    else if (title == "Report") img = "images/pic6.png";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: Container(
              child: new Stack(
            children: <Widget>[
              new Image.asset(
                img,
                width: 80.0,
                height: 80,
              )
            ],
          )),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
