import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCounter extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}



class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1;

  Future<List> senddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('itemcount', numOfItems.toString());

  }

  @override
  void initState() {
    super.initState();
    senddata();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
                senddata();
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0 / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
                senddata();
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: () => press(),
        child: Icon(icon),
      ),
    );
  }
}


