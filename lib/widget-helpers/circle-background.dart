import 'package:flutter/material.dart';

class CircleBackground extends StatelessWidget {
  const CircleBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(color: Colors.green[500]),
                )),
            Positioned(
                child: Container(
              width: 500,
              height: 700,
              decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(100)),
            )),
            Positioned(
                child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
            )),
            child
          ],
        ));
  }
}
