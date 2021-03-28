import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fproject/File/components/model.dart';
import "package:http/http.dart" as http;

Future<List<FileModel>> getFileData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/file/';
  final files = <FileModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final file = FileModel(
            id: item['id'],
            user: item['user'],
            title: item['title'],
            file: item['file'],
            type: item['type'],
            size: item['size'],
            selected: item['selected'],
            timestamp: item['timestamp'],
            favourite: item['favourite']);
        files.add(file);
      }
    }
  });
  return files;
}

String BooleanFunction(bool data) {
  if (data == true) {
    return 'false';
  }
  return 'true';
}

Future<FileModel> markedFavourite(id, favourite, token) async {
  FileModel finaldata;
  final String fav = BooleanFunction(favourite);
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/file/' +
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
      finaldata = FileModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          file: item['file'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
    }
  });
  return finaldata;
}

Future<void> deleteFile(id, token) async {
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/file/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}
