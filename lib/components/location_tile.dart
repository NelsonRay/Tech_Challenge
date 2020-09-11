import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final String cityName;
  final String countryName;
  final String temperature;
  final String iconPath;
  final Function callBack;
  final EdgeInsetsGeometry padding;

//  final Function deleteCallback;

  LocationTile({
    this.cityName,
    this.countryName,
    this.temperature,
    this.iconPath,
    this.callBack,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: callBack,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey.shade600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Material(
            elevation: 5,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      countryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      iconPath,
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
