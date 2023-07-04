import 'dart:convert';
import 'package:channel_id/Screens/LandingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';
import '../apiKey.dart';
import '../utility.dart';

class SearchChannelName extends StatefulWidget {
  @override
  _SearchChannelNameState createState() => _SearchChannelNameState();
}

class _SearchChannelNameState extends State<SearchChannelName> {
  final TextEditingController _channelNameController = TextEditingController();
  bool isName = false;
  bool isLoading = false;

  YoutubeAPI youtube = YoutubeAPI(API_KEY, maxResults: 25, type: "channel");

  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    String query = _channelNameController.text;
    videoResult = await youtube.search(
      query,
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  void _saveDetails(String id, String name, String url) {
    Map<String, String> userDetails = {
      'channelId': id,
      'name': name,
      'url': url,
    };

    saveChannelDetails(userDetails).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Channel added successfully!'),
        ),
      );
    });
  }

  Future<void> saveChannelDetails(Map<String, String> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList(keyId);
    List<Map<String, String>> list = encodedList
            ?.map((item) => Map<String, String>.from(json.decode(item)))
            .toList() ??
        [];
    list.add(userDetails);
    List<String> encodedUpdatedList =
        list.map((item) => json.encode(item)).toList();
    await prefs.setStringList(keyId, encodedUpdatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.play_circle),
        toolbarHeight: 40,
        backgroundColor: bgcolor,
        elevation: 0,
        title: const Text('My Channel'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _channelNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter YouTube Channel Name',
                      ),
                    ),
                  ),
                  TextButton(
                    autofocus: true,
                    onPressed: () {
                      setState(() async {
                        isLoading = true;
                        await callAPI();
                        isName = true;
                        isLoading = false;
                      });
                    },
                    child: const Text(
                      'Search Channel',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              if (isName)
                Expanded(
                  child: ListView(
                    children: videoResult.map<Widget>(listItem).toList(),
                  ),
                ),
              if (isLoading) const CircularProgressIndicator()
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

  Widget listItem(YouTubeVideo video) {
    return Card(
      child: MaterialButton(
        onPressed: () {
               _saveDetails(
              video.channelId!, video.channelTitle, video.thumbnail.small.url!);
               Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LandingScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: bgcolor,
                radius: 40,
                backgroundImage: NetworkImage(
                  video.thumbnail.small.url ?? '',

                ),
              ),
              Expanded(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        video.channelTitle,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
