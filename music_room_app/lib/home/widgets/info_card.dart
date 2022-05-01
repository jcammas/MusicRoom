import 'package:flutter/material.dart';
import 'package:music_room_app/constant_colors.dart';

class InfoCard extends StatefulWidget {
  final String cardName;
  final IconData icon;
  final String route;
  const InfoCard({
    Key? key,
    required this.cardName,
    required this.icon,
    required this.route,
  }) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      child: SizedBox(
        width: screenWidth * 0.4,
        child: Card(
          shadowColor: const Color(0XFFDDDDDD),
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFD0D0D0), width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.cardName,
                          style: const TextStyle(
                            color: policeColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 35,
                          color: deepBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.025,
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, widget.route),
    );
  }
}
