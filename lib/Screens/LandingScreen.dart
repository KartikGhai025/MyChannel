import 'package:flutter/material.dart';
import 'MyChannelLists.dart';
import '../utility.dart';
import 'searchChannel.dart';

class LandingScreen extends StatefulWidget {
  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //drawer: Drawer(),
      body: Stack(
        children: [
          bodies[currentIndex],
          CustomPaint(
            painter: MyPainter(),
            child: Container(height: 0),
          ),
        ],
      ),
      backgroundColor: bgcolor,

      bottomNavigationBar: Container(
        height: size.width * .130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < 2; i++)
              InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = i;
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: size.width * .014),
                    Icon(listOfIcons[i],
                        size: size.width * .076, color: Colors.white),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        top: i == currentIndex ? 0 : size.width * .029,
                        right: size.width * .0422,
                        left: size.width * .0422,
                      ),
                      width: size.width * .153,
                      height: i == currentIndex ? size.width * .014 : 0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.add_circle,
 //   Icons.favorite_rounded
  ];
}

List<Widget> bodies = [
  MyChannels(),
  //HomeScreen(),
  SearchChannelName(),
 // FavoritesScreen()
];
