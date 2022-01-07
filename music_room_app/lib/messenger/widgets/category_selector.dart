import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = [
    "Messages",
    "Online",
    "Room",
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.09,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = i;
              });
            },
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenWidth * 0.05),
                child: Text(
                  categories[i].toString(),
                  style: TextStyle(
                      color: i == selectedIndex
                          ? Color(0XFF072BB8)
                          : Colors.black54,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                )),
          );
        },
      ),
    );
  }
}
