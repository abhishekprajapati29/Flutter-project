import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/notes/notemain.dart';
import 'package:fproject/todo/components/Add/chips.dart';
import 'package:fproject/todo/components/Add/validator.dart';
import 'package:fproject/todo/todomain.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';

class BlocAdd extends Object with Validator implements BaseBloc {
  final _titleController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  Function(String) get titleChanged => _titleController.sink.add;
  Function(String) get descriptionChanged => _descriptionController.sink.add;

  Stream<String> get title => _titleController.stream.transform(titleValidator);
  Stream<String> get description =>
      _descriptionController.stream.transform(descriptionValidator);

  Stream<bool> get submitCheck =>
      Rx.combineLatest2(title, description, (t, d) => true);

  void initState() {
    getTokenPreferences();
  }

  Future<List<Todochip>> fetchAllRequests(
      int id, String token, List<String> chip, List<Todochip> todochips) async {
    final String TodoId = id.toString();
    return Future.wait(
      chip.map((String t) async {
        await http.post(
          'https://abhishekpraja.pythonanywhere.com/todochip/',
          body: {
            'chips': t,
            'todochip': TodoId,
          },
        ).then(
          (response) {
            final jsonData = json.decode(response.body);
            final todochip = Todochip(
                id: jsonData['id'],
                chips: jsonData['chips'],
                todochip: jsonData['todochip']);
            todochips.add(todochip);
          },
        );
      }),
    );
  }

  submit(BuildContext context, List<String> chip, String token,
      Function moveIndex, Function loadingUpadte, Function addData) async {
    loadingUpadte();
    Map data = {
      'title': _titleController.value,
      'description': _descriptionController.value,
    };
    await http.post('https://abhishekpraja.pythonanywhere.com/todo/',
        body: data,
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((res) async {
      final jsonData1 = json.decode(res.body);
      final int _todoId = jsonData1['id'];
      List<Todochip> todochip = [];
      await fetchAllRequests(_todoId, token, chip, todochip);
      final todo = Item(
          id: jsonData1['id'],
          user: jsonData1['user'],
          todochip: todochip,
          title: jsonData1['title'],
          description: jsonData1['description'],
          completed: jsonData1['completed'],
          timestamp: jsonData1['timestamp'],
          isExpanded: false);
      await addData(todo);
      loadingUpadte();
      moveIndex(0);
    });
  }

  @override
  void dispose() {
    _titleController?.close();
    _descriptionController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
