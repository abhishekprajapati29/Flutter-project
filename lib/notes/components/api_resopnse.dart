import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

Future<List<NotesItem>> getNoteData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/note/';
  final notes = <NotesItem>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final notechips = <Notechip>[];
        for (var chip in item['notechip']) {
          final notechip = Notechip(
              id: chip['id'],
              noteChips: chip['note_chips'],
              notechip: chip['notechip']);
          notechips.add(notechip);
        }
        final note = NotesItem(
          id: item['id'],
          user: item['user'],
          notechip: notechips,
          noteTitle: item['note_title'],
          noteContent: item['note_content'],
          timestamp: item['timestamp'],
        );
        notes.add(note);
      }
    }
  });
  return notes;
}

Future<List<Notechip>> chipsNotes() async {
  List<Notechip> finaldata = [];
  await http
      .get(Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/notechip/'))
      .then((data1) async {
    if (data1.statusCode == 200) {
      final jsonData = jsonDecode(data1.body);
      for (var item in jsonData) {
        final again = Notechip(
            id: item['id'],
            noteChips: item['note_chips'],
            notechip: item['notechip']);
        finaldata.add(again);
      }
    }
  });
  return finaldata;
}

Future<List<Notechip>> fetchAllRequests(
    int id, String token, List<String> chip, List<Notechip> notechips) async {
  final String noteId = id.toString();
  for (var item in chip) {
    print(item);
  }
  return Future.wait(
    chip.map((String t) async {
      await http.post(
        'https://abhishekpraja.pythonanywhere.com/notechip/',
        body: {
          'note_chips': t,
          'notechip': noteId,
        },
      ).then(
        (response) {
          final jsonData = json.decode(response.body);
          final notechip = Notechip(
              id: jsonData['id'],
              noteChips: jsonData['note_chips'],
              notechip: jsonData['notechip']);
          notechips.add(notechip);
        },
      );
    }),
  );
}

addNote(BuildContext context, List<String> chip, String token, String content,
    String title, Function addData, Function loadingChange) async {
  loadingChange();
  Map data = {
    'note_title': title,
    'note_content': content,
  };
  await http.post('https://abhishekpraja.pythonanywhere.com/note/',
      body: data,
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((res) async {
    final jsonData1 = json.decode(res.body);
    final int _noteId = jsonData1['id'];
    List<Notechip> notechip = [];
    await fetchAllRequests(_noteId, token, chip, notechip);
    final note = NotesItem(
      id: jsonData1['id'],
      user: jsonData1['user'],
      notechip: notechip,
      noteTitle: jsonData1['note_title'],
      noteContent: jsonData1['note_content'],
      timestamp: jsonData1['timestamp'],
    );
    print(note.noteTitle);
    await addData(note);
    loadingChange();
    Navigator.pop(context);
  });
}

deleteNoteData(List<String> deleteData) async {
  deleteData.forEach((e) async => {
        await http
            .delete(
                'https://abhishekpraja.pythonanywhere.com/notechip/' + e + '/')
            .then((value) => print(value))
            .catchError((error) => print(error))
      });
}

Future<void> deleteNote(id, token) async {
  print(id);
  print(token);
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/note/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}

editChipData(int todoId, data, notechip) async {
  for (var da in data) {
    print(da);
  }
  data.forEach((e) async => {
        await http.post(
            Uri.encodeFull(
              'https://abhishekpraja.pythonanywhere.com/notechip/',
            ),
            body: {
              'note_chips': e,
              'notechip': todoId.toString(),
            }).then((value) {
          final jsonData = jsonDecode(value.body);
          final createnotechip = Notechip(
              id: jsonData['id'],
              noteChips: jsonData['note_chips'],
              notechip: jsonData['notechip']);
          notechip.add(createnotechip);
        }).catchError((error) => print(error))
      });
}

Future<NotesItem> editNote(
    title, content, Function loadingFunction, data) async {
  print(title);
  print(content);
  print(data['id']);
  print(data['token']);

  for (var item in data['chips']) {
    print(item);
  }
  loadingFunction();
  NotesItem editData;
  Map finalData = {
    'note_title': title,
    'note_content': content,
  };
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/note/' +
          data['id'].toString() +
          '/'),
      body: finalData,
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + data['token'],
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      final int _noteId = item['id'];
      List<Notechip> notechip = [];
      await deleteNoteData(data['editId']);
      await editChipData(_noteId, data['chips'], notechip);
      editData = NotesItem(
        id: item['id'],
        user: item['user'],
        notechip: notechip,
        noteTitle: item['note_title'],
        noteContent: item['note_content'],
        timestamp: item['timestamp'],
      );
    }
  });
  return editData;
}
