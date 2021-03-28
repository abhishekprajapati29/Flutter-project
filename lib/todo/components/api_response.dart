import 'dart:convert';

import 'package:fproject/todo/components/models.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> getTodoData(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/todo/';
  final notes = <Item>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final jsonData = jsonDecode(data.body);

      for (var item in jsonData) {
        final todochips = <Todochip>[];
        for (var chip in item['todochip']) {
          final todochip = Todochip(
              id: chip['id'], chips: chip['chips'], todochip: chip['todochip']);
          todochips.add(todochip);
        }
        final note = Item(
            id: item['id'],
            user: item['user'],
            todochip: todochips,
            title: item['title'],
            description: item['description'],
            completed: item['completed'],
            timestamp: item['timestamp'],
            isExpanded: false);
        notes.add(note);
      }
    }
  });
  return notes;
}

Future<Item> getSingleTodoData(String token, String id) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/todo/' + id + '/';
  Item editData;
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((data) {
    if (data.statusCode == 200) {
      final item = jsonDecode(data.body);
      final todochips = <Todochip>[];
      for (var chip in item['todochip']) {
        final todochip = Todochip(
            id: chip['id'], chips: chip['chips'], todochip: chip['todochip']);
        todochips.add(todochip);
      }
      editData = Item(
          id: item['id'],
          user: item['user'],
          todochip: todochips,
          title: item['title'],
          description: item['description'],
          completed: item['completed'],
          timestamp: item['timestamp'],
          isExpanded: false);
    }
  });
  return editData;
}

deleteTodoData(List<String> deleteData) async {
  deleteData.forEach((e) async => {
        await http
            .delete(
                'https://abhishekpraja.pythonanywhere.com/todochip/' + e + '/')
            .then((value) => print(value))
            .catchError((error) => print(error))
      });
}

editChipData(
    int todoId, data, List<Todochip> chips, List<Todochip> todochip) async {
  for (var da in data) {
    print(da);
  }
  data.forEach((e) async => {
        await http.post(
            Uri.encodeFull(
              'https://abhishekpraja.pythonanywhere.com/todochip/',
            ),
            body: {
              'chips': e,
              'todochip': todoId.toString(),
            }).then((value) {
          final jsonData = jsonDecode(value.body);
          final createtodochip = Todochip(
              id: jsonData['id'],
              chips: jsonData['chips'],
              todochip: jsonData['todochip']);
          todochip.add(createtodochip);
        }).catchError((error) => print(error))
      });
}

Future<Item> editTodo(data, List<String> edit) async {
  print(data['title']);
  print(data['token']);
  print(data['description']);
  print(data['id']);
  Item editData;
  Map finalData = {
    'title': data['title'],
    'description': data['description'],
  };
  await http.patch(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/todo/' + data['id'] + '/'),
      body: finalData,
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + data['token'],
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      final int _todoId = item['id'];
      List<Todochip> todochip = [];
      await deleteTodoData(edit);
      await editChipData(_todoId, data['editChip'], data['chips'], todochip);
      editData = Item(
          id: item['id'],
          user: item['user'],
          todochip: todochip,
          title: item['title'],
          description: item['description'],
          completed: item['completed'],
          timestamp: item['timestamp'],
          isExpanded: false);
    }
  });
  return editData;
}

Future<List<Todochip>> chipsTodo() async {
  List<Todochip> finaldata = [];
  await http
      .get(Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/todochip/'))
      .then((data1) async {
    if (data1.statusCode == 200) {
      final jsonData = jsonDecode(data1.body);
      for (var item in jsonData) {
        final again = Todochip(
            id: item['id'], chips: item['chips'], todochip: item['todochip']);
        finaldata.add(again);
      }
    }
  });
  return finaldata;
}

Future<void> deleteTodo(id, token) async {
  print(id);
  print(token);
  await http.delete(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/todo/' +
          id.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
}

Future<Item> markedCompletedTodo(id, token) async {
  Item finaldata;
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/todo/' +
          id.toString() +
          '/'),
      body: {
        'completed': "true"
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      List<Todochip> todochip = [];
      for (var chip in item['todochip']) {
        final todochips = Todochip(
            id: chip['id'], chips: chip['chips'], todochip: chip['todochip']);
        todochip.add(todochips);
      }
      final again = Item(
          id: item['id'],
          user: item['user'],
          todochip: todochip,
          title: item['title'],
          description: item['description'],
          completed: item['completed'],
          timestamp: item['timestamp'],
          isExpanded: false);
      finaldata = again;
    }
  });
  return finaldata;
}

Future<Item> markedInCompletedTodo(id, token) async {
  Item finaldata;
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/todo/' +
          id.toString() +
          '/'),
      body: {
        'completed': "false"
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((data1) async {
    if (data1.statusCode == 200) {
      final item = jsonDecode(data1.body);
      List<Todochip> todochip = [];
      for (var chip in item['todochip']) {
        final todochips = Todochip(
            id: chip['id'], chips: chip['chips'], todochip: chip['todochip']);
        todochip.add(todochips);
      }
      final again = Item(
          id: item['id'],
          user: item['user'],
          todochip: todochip,
          title: item['title'],
          description: item['description'],
          completed: item['completed'],
          timestamp: item['timestamp'],
          isExpanded: false);
      finaldata = again;
    }
  });
  return finaldata;
}
