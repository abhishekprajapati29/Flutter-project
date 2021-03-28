import 'dart:convert';
import 'package:fproject/Video/components/model.dart';
import "package:http/http.dart" as http;

Future<List<VideoModel>> getVideoData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/video/';
  final videos = <VideoModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final video = VideoModel(
            id: item['id'],
            user: item['user'],
            title: item['title'],
            video: item['Video'],
            type: item['type'],
            size: item['size'],
            selected: item['selected'],
            timestamp: item['timestamp'],
            favourite: item['favourite']);
        videos.add(video);
      }
    }
  });
  return videos;
}

String BooleanFunction(bool data) {
  if (data == true) {
    return 'false';
  }
  return 'true';
}

Future<VideoModel> markedFavourite(id, favourite, token) async {
  VideoModel finaldata;
  final String fav = BooleanFunction(favourite);
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/video/' +
          id.toString() +
          '/'),
      body: {
        'favourite': fav
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      finaldata = VideoModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          video: item['Video'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
    }
  });
  return finaldata;
}

Future<void> deleteVideo(id, token) async {
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/video/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}
