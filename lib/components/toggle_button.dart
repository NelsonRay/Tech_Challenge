import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final Widget firstChild;
  final Widget secondChild;
  final Color firstColor;
  final Color secondColor;
  final EdgeInsetsGeometry padding;

  // callBacks for used to change the user's preferences in the drawer
  final Function firstCallback;
  final Function secondCallback;

  ToggleButton({
    this.firstChild,
    this.secondChild,
    this.firstColor,
    this.secondColor,
    this.firstCallback,
    this.secondCallback,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Container(
              height: 50,
              width: 60,
              padding:
                  const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: firstColor,
              ),
              child: Center(child: firstChild),
            ),
            onTap: firstCallback,
          ),
          GestureDetector(
            child: Container(
              height: 50,
              width: 60,
              padding:
                  const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: secondColor,
              ),
              child: Center(child: secondChild),
            ),
            onTap: secondCallback,
          ),
        ],
      ),
    );
  }
}
