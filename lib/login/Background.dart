import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "images/top1.png",
                width: size.width * 0.85
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "images/top2.png",
                width: size.width* 0.85
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: Image.asset(
                "images/main.png",
                width: size.width * 0.35
            ),
          ),
          Positioned(
            bottom: -60,
            right: 0,
            child: Image.asset(
                "images/bottom1.png",
                width: size.width / 0.85
            ),
          ),
          Positioned(
            bottom: -60,
            right: -80,
            child: Image.asset(
                "images/bottom2.png",
                width: size.width / 0.85
            ),
          ),
          child
        ],
      ),
    );
  }
}