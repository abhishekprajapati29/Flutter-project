import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fproject/diary/components/model.dart';
import 'package:http/http.dart' as http;

Future<List<DiaryModel>> getDiaryData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/diary/';
  final diarys = <DiaryModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final diary = DiaryModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          text: item['text'],
          postedDate: item['posted_date'],
        );
        diarys.add(diary);
      }
    }
  });
  return diarys;
}

addDiarys(BuildContext context, String token, String text, String title,
    Function addData, Function loadingChange) async {
  loadingChange();
  Map data = {
    'title': title,
    'text': text,
  };
  await http.post('https://abhishekpraja.pythonanywhere.com/diary/',
      body: data,
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((res) async {
    final jsonData1 = json.decode(res.body);
    final diary = DiaryModel(
      id: jsonData1['id'],
      user: jsonData1['user'],
      title: jsonData1['title'],
      text: jsonData1['text'],
      postedDate: jsonData1['posted_date'],
    );
    await addData(diary);
    loadingChange();
    Navigator.pop(context);
  });
}

Future<void> deleteDiary(id, token) async {
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/diary/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}

Future<DiaryModel> editDiary(
    title, text, Function loadingFunction, data) async {
  loadingFunction();
  DiaryModel editData;
  Map finalData = {
    'title': title,
    'text': text,
  };
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/diary/' +
          data['id'].toString() +
          '/'),
      body: finalData,
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + data['token'],
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      editData = DiaryModel(
        id: item['id'],
        user: item['user'],
        title: item['title'],
        text: item['text'],
        postedDate: item['posted_date'],
      );
    }
  });
  return editData;
}
