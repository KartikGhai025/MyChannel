import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteDetailsList = [];

  @override
  void initState() {
    super.initState();
    getFavoriteDetailsList().then((list) {
      setState(() {
        favoriteDetailsList = list;
      });
    });
  }

  Future<List<Map<String, dynamic>>> getFavoriteDetailsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> list = encodedList
        ?.map((item) => Map<String, dynamic>.from(json.decode(item)))
        .toList() ??
        [];
    return list;
  }

  Future<void> _removeFromFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('favoriteDetailsList');
    List<Map<String, dynamic>> list = encodedList
        ?.map((item) => Map<String, dynamic>.from(json.decode(item)))
        .toList() ??
        [];

    list.removeAt(index);

    List<String> encodedUpdatedList =
    list.map((item) => json.encode(item)).toList();
    await prefs.setStringList('favoriteDetailsList', encodedUpdatedList);

    setState(() {
      favoriteDetailsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 40,
        leading: const Icon(Icons.play_circle),
        backgroundColor: bgcolor,
        elevation: 0,
        title: Text('My Channel'),
        centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 25,),
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteDetailsList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        _removeFromFavorites(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                            'Mobile Number: ${favoriteDetailsList[index]['mobileNumber']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${favoriteDetailsList[index]['name']}'),
                            Text('Age: ${favoriteDetailsList[index]['age']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          CustomPaint(
            painter: MyPainter(),
            child: Container(height: 0),
          ),
        ],
      ),
    );
  }
}
