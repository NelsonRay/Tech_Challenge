import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final String location;
  final String image;
  final String weather;

  LocationTile({this.location, this.weather, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.blue),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Text(
            location,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            '$weather°',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Image.asset(
            'assests/icons/10d.png',
            height: 30,
          )
        ],
      ),
    );
  }
}
