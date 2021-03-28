import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fproject/Auth/forgetpassword/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Object with Validator implements BaseBloc {
  final _verifyEmailController = BehaviorSubject<String>();

  Function(String) get verifyEmailChanged => _verifyEmailController.sink.add;

  Stream<String> get verifyEmail =>
      _verifyEmailController.stream.transform(verifyEmailValidator);

  Future<void> saveTokenPreferences(String token) async {
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  submit(BuildContext context, Function submitLoadings, Function manageError,
      email, Function sendStatus) async {
    submitLoadings();
    Map data = {
      'email': _verifyEmailController.value,
    };

    await http
        .post('https://abhishekpraja.pythonanywhere.com/reset/', body: data)
        .then((value) async {
      if (value.statusCode == 200) {
        var item = json.decode(value.body);
        if (item['status'] == 'OK2') {
          sendStatus();
        }
      } else {
        print('data');
        manageError('Email is Invalid!');
      }
    });
  }

  @override
  void dispose() {
    _verifyEmailController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
