import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<List<AlbumModel>> getAlbumData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/images/';
  final albums = <AlbumModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final imagesData = <Imagelist>[];
        for (var item1 in item['imagelist']) {
          final image = Imagelist(
              id: item1['id'],
              user: item1['user'],
              albumId: item1['album_id'],
              src: item1['src'],
              thumbnail: item1['thumbnail'],
              thumbnailWidth: item1['thumbnailWidth'],
              thumbnailHeight: item1['thumbnailHeight'],
              caption: item1['caption'],
              selected: item1['selected'],
              size: item1['size'],
              favourite: item1['favourite']);
          imagesData.add(image);
        }
        final album = AlbumModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          timestamp: item['timestamp'],
          image: item['image'],
          imagelist: imagesData,
          favourite: item['favourite'],
          imagelistsize: item['imagelistsize'],
          selected: item['selected'],
        );
        albums.add(album);
      }
    }
  });
  return albums;
}

Future<void> deleteAlbum(id, token) async {
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/images/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}

String BooleanFunction(bool data) {
  if (data == true) {
    return 'false';
  }
  return 'true';
}

Future<AlbumModel> markedFavourite(id, favourite, token) async {
  AlbumModel finaldata;
  final String fav = BooleanFunction(favourite);
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/images/' +
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
      final jsonData = jsonDecode(data1.body);
      final imagesData = <Imagelist>[];
      for (var item1 in jsonData['imagelist']) {
        final image = Imagelist(
            id: item1['id'],
            user: item1['user'],
            albumId: item1['album_id'],
            src: item1['src'],
            thumbnail: item1['thumbnail'],
            thumbnailWidth: item1['thumbnailWidth'],
            thumbnailHeight: item1['thumbnailHeight'],
            caption: item1['caption'],
            selected: item1['selected'],
            size: item1['size'],
            favourite: item1['favourite']);
        imagesData.add(image);
      }
      finaldata = AlbumModel(
        id: jsonData['id'],
        user: jsonData['user'],
        title: jsonData['title'],
        timestamp: jsonData['timestamp'],
        image: jsonData['image'],
        imagelist: imagesData,
        favourite: jsonData['favourite'],
        imagelistsize: jsonData['imagelistsize'],
        selected: jsonData['selected'],
      );
    }
  });
  return finaldata;
}

Future<AlbumModel> createAlbum(
    String token, data, Function loadingChange) async {
  loadingChange();
  AlbumModel finaldata;
  print(data['name']);
  print(data['filename']);
  print(data['filepath']);
  var dio = new Dio();
  dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
  FormData formData = FormData.fromMap({
    "title": data['name'],
    "image": await MultipartFile.fromFile(data['filepath'],
        filename: data['filename']),
    "favourite": data['favourite'],
    "selected": true
  });
  await dio
      .post(
    "http://abhishekpraja.pythonanywhere.com/images/",
    data: formData,
  )
      .then((value) async {
    final jsonData = value.data;
    finaldata = AlbumModel(
      id: jsonData['id'],
      user: jsonData['user'],
      title: jsonData['title'],
      timestamp: jsonData['timestamp'],
      image: jsonData['image'],
      imagelist: [],
      favourite: jsonData['favourite'],
      imagelistsize: jsonData['imagelistsize'],
      selected: jsonData['selected'],
    );
  }).catchError((error) => print(error.response.toString()));
  loadingChange();
  return finaldata;
}

Future<AlbumModel> editAlbum(String token, data, Function loadingChange) async {
  loadingChange();
  AlbumModel finaldata;
  var dio = new Dio();
  dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
  FormData formData = FormData.fromMap({
    "title": data['name'],
    "image": await MultipartFile.fromFile(data['filepath'],
        filename: data['filename']),
    "favourite": data['favourite'],
    "selected": true
  });
  await dio
      .patch(
    "http://abhishekpraja.pythonanywhere.com/images/" +
        data['id'].toString() +
        '/',
    data: formData,
  )
      .then((value) async {
    final jsonData = value.data;
    finaldata = AlbumModel(
      id: jsonData['id'],
      user: jsonData['user'],
      title: jsonData['title'],
      timestamp: jsonData['timestamp'],
      image: jsonData['image'],
      imagelist: [],
      favourite: jsonData['favourite'],
      imagelistsize: jsonData['imagelistsize'],
      selected: jsonData['selected'],
    );
  }).catchError((error) => print(error.response.toString()));
  loadingChange();
  return finaldata;
}

_updateToken(String token, int id) async {
  print(token);
  print("id = $id = fas");
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/imagelist/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}

ondeleteAlbumImage(id, albumId) async {
  await getTokenPreferences().then((token) => _updateToken(token, id));
}

Future<AlbumModel> singleAlbum(token, id) async {
  AlbumModel finaldata;
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/images/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((data1) async {
    final jsonData = jsonDecode(data1.body);
    print(jsonData['id']);
    if (data1.statusCode == 200) {
      final jsonData = jsonDecode(data1.body);
      final imagesData = <Imagelist>[];
      for (var item1 in jsonData['imagelist']) {
        final image = Imagelist(
            id: item1['id'],
            user: item1['user'],
            albumId: item1['album_id'],
            src: item1['src'],
            thumbnail: item1['thumbnail'],
            thumbnailWidth: item1['thumbnailWidth'],
            thumbnailHeight: item1['thumbnailHeight'],
            caption: item1['caption'],
            selected: item1['selected'],
            size: item1['size'],
            favourite: item1['favourite']);
        imagesData.add(image);
      }
      finaldata = AlbumModel(
        id: jsonData['id'],
        user: jsonData['user'],
        title: jsonData['title'],
        timestamp: jsonData['timestamp'],
        image: jsonData['image'],
        imagelist: imagesData,
        favourite: jsonData['favourite'],
        imagelistsize: jsonData['imagelistsize'],
        selected: jsonData['selected'],
      );
    }
  });
  return finaldata;
}
