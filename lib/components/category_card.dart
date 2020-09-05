import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String categoryText;
  final String answer;

  CategoryCard({this.answer, this.categoryText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          width: 115,
          child: Padding(
            padding: const EdgeInsets.only(top: 35, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryText,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  answer,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
