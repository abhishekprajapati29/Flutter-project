import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fproject/Auth/login/model.dart';
import 'package:fproject/Auth/login/validator.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:fproject/DashBoard/dashboard.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/Team/plan.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Object with Validator implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck =>
      Rx.combineLatest2(email, password, (e, p) => true);

  Future<void> saveTokenPreferences(String token) async {
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<void> saveUserPreferences(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', data['id']);
    prefs.setString('username', data['username']);
    prefs.setString('email', data['email']);
    prefs.setString('teamName', data['teamName']);
    prefs.setInt('totalStorage', data['totalStorage']);
    prefs.setDouble('price', data['price']);
    prefs.setString('type', data['type']);
    prefs.setInt('projectCount', data['projectCount']);
    prefs.setInt('cloudStorage', data['cloudStorage']);
    prefs.setInt('noOfProject', data['noOfProject']);
    prefs.setInt('noOfMember', data['noOfMember']);
    prefs.setString('userImage', data['userImage']);
    prefs.setBool('selected', data['selected']);
    prefs.setString('txnDate', data['txnDate']);
    prefs.setString('duration', data['duration']);
  }

  submit(BuildContext context, Function submitLoadings, Function manageError,
      email, password) async {
    submitLoadings();
    Map data = {
      'username': _emailController.value,
      'password': _passwordController.value,
    };
    await http
        .post('https://abhishekpraja.pythonanywhere.com/api/auth/login',
            body: data)
        .then((value) async {
      if (value.statusCode == 200) {
        var item = json.decode(value.body);
        await getTotalStorage(item['token']).then((value) async {
          await getPlan(item['token'], item['user']['username'])
              .then((plan) async {
            final subPlanDetail = Plan_detail;
            await getCurrentUserProjects(item['token']).then((project) async {
              final projectCount = project.length;
              for (var item1 in subPlanDetail) {
                if (double.parse(item1['price'].toString()) ==
                    double.parse(plan.amount)) {
                  print('storage: ${value}');
                  print('storage1: ${item1['cloud_storage_value']}');
                  await saveUserPreferences({
                    'id': item['user']['id'],
                    'username': item['user']['username'],
                    'email': item['user']['email'],
                    'teamName': item['user']['profile']['teamName'],
                    'selected': item['user']['profile']['selected'],
                    'totalStorage': value,
                    'price': item1['price'],
                    'type': item1['type'],
                    'duration': double.parse(item1['price'].toString()) > 0
                        ? item1['time']
                        : 'Free',
                    'cloudStorage': item1['cloud_storage_value'],
                    'noOfProject': item1['No_of_Projects'],
                    'noOfMember': item1['No_of_project_members'],
                    'projectCount': projectCount,
                    'userImage': item['user']['image']['image'],
                    'txnDate': plan.txnDate
                  });
                }
              }
            });
          });
          await saveTokenPreferences(item['token']).then((_) {
            submitLoadings();
            Navigator.popAndPushNamed(context, '/dashboard');
          });
        });
      } else {
        print('data');
        manageError(value.body);
      }
    });
  }

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
