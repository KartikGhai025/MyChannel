import 'package:channel_id/Screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';
import '../utility.dart';

class VideoLists extends StatefulWidget {
  String title;
  String id;
  VideoLists({required this.id, required this.title});

  @override
  _VideoListsState createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
  Channel? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel =
        await APIService.instance.fetchChannel(channelId: widget.id);
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      height: 100.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel!.profilePictureUrl),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel!.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel!.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoScreen(id: video.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        height: 140.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel!.uploadPlaylistId);
    List<Video> allVideos = _channel!.videos
      ..addAll(moreVideos as Iterable<Video>);
    setState(() {
      _channel!.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: const Icon(Icons.play_circle),
        backgroundColor: bgcolor,
        elevation: 0,
        title: Text(widget.title),
        centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: Container(
          color: bgcolor,
          // color: Colors.deepPurpleAccent,
          height: MediaQuery.of(context).size.width * .130,
          child: const BackButton(
            color: Colors.white,
          )),
      body: _channel != null
          ? Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading &&
                        _channel!.videos.length !=
                            int.parse(_channel!.videoCount) &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: 1 + _channel!.videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _buildProfileInfo();
                      }
                      Video video = _channel!.videos[index - 1];
                      return _buildVideo(video);
                    },
                  ),
                ),
                CustomPaint(
                  painter: MyPainter(),
                  child: Container(height: 0),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
