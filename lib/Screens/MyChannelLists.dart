import 'dart:convert';
import 'package:channel_id/Screens/videoLists.dart';
import 'package:channel_id/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChannels extends StatefulWidget {
  @override
  _MyChannelsState createState() => _MyChannelsState();
}

class _MyChannelsState extends State<MyChannels> {
  List<Map<String, String>> userDetailsList = [];

  @override
  void initState() {
    super.initState();
    getMobileNumberAndNameList().then((list) {
      setState(() {
        userDetailsList = list;
      });
    });
  }

  Future<List<Map<String, String>>> getMobileNumberAndNameList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(keyId);
    List<Map<String, String>> list =
        encodedList?.map((item) => Map<String, String>.from(json.decode(item))).toList() ?? [];
    return list;
  }

  void _deleteDetails(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(keyId);
    List<Map<String, String>> list =
        encodedList?.map((item) => Map<String, String>.from(json.decode(item))).toList() ?? [];
    list.removeAt(index);
    List<String> encodedUpdatedList = list.map((item) => json.encode(item)).toList();
    await prefs.setStringList(keyId, encodedUpdatedList);

    setState(() {
      userDetailsList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        toolbarHeight: 40,
        leading: const Icon(Icons.play_circle),
        backgroundColor: bgcolor,
        elevation: 0,
        title: const Text('My Channel'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.transparent,
                height: 22,),
              Expanded(
                child: ListView.builder(
                  itemCount: userDetailsList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(userDetailsList[index]['channelId']!),
                      onDismissed: (direction) {
                        _deleteDetails(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Channel deleted successfully!'),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: cards(userDetailsList[index]['channelId']!, userDetailsList[index]['name']!, userDetailsList[index]['url']!)
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

  Widget cards(String id, String name, String url) {
    double _w = MediaQuery.of(context).size.width;
    return InkWell(
      enableFeedback: true,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoLists(id: id, title: name),
            ));
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(_w / 20, _w / 20, _w / 20, 0),
        padding: EdgeInsets.all(_w / 20),
        height: _w / 4.4,
        width: _w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffEDECEA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(.1),
              radius: _w / 15,
              backgroundImage: NetworkImage(url),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: _w / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      textScaleFactor: 1.6,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.navigate_next_outlined)
          ],
        ),
      ),
    );
  }

}