import 'package:flutter/material.dart';

class HourWidget extends StatelessWidget {
  final String hour;
  final String temp;
  final String icon;

  HourWidget({this.hour, this.icon, this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            hour,
            style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade600),
          ),
          Image.asset(
            icon,
            height: 35,
          ),
          const SizedBox(height: 5),
          Text(
            temp,
            style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade600),
          ),
        ],
      ),
    );
  }
}
