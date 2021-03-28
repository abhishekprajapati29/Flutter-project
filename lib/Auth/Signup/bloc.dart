import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fproject/Auth/Signup/validator.dart';
import 'package:fproject/DashBoard/dashboard.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Object with Validator implements BaseBloc {
  final _usernameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordConfirmChanged =>
      _passwordConfirmController.sink.add;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);
  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get passwordConfirm =>
      _passwordConfirmController.stream.transform(passwordConfirmValidator);

  Stream<bool> get submitCheck =>
      Rx.combineLatest2(email, password, (e, p) => true);

  Future<void> saveTokenPreferences(String token) async {
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
      'username': _usernameController.value,
      'email': _emailController.value,
      'password': _passwordController.value,
      'password1': _passwordConfirmController.value,
    };
    await http
        .post('https://abhishekpraja.pythonanywhere.com/api/auth/register',
            body: data)
        .then((value) async {
      if (value.statusCode == 200) {
        var item = json.decode(value.body);
        await http.post(
            Uri.encodeFull(
                'https://abhishekpraja.pythonanywhere.com/userprofile/'),
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + item['token'],
            });
        await http.post(
            Uri.encodeFull(
                'https://abhishekpraja.pythonanywhere.com/userprofile_image/'),
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + item['token'],
            }).then((userimage) async {
          final userImage = jsonDecode(userimage.body);
          final DateTime date = DateTime.now();
          await http.post(
              Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/Subs/'),
              body: {
                'username': item['user']['username'],
                'status': 'TXN_SUCCESS',
                'order_id': item['user']['id'].toString(),
                'amount': '0.0',
                'bank_name': 'Free',
                'transaction_id': item['user']['id'].toString(),
                'txn_date': date.toString()
              },
              headers: {
                "Accept": 'application/json',
                "Authorization": 'Token ' + item['token'],
              }).then((subs) async {
            final sub = jsonDecode(subs.body);
            await saveUserPreferences({
              'id': item['user']['id'],
              'username': item['user']['username'],
              'email': item['user']['email'],
              'teamName': 'default_team_name',
              'selected': false,
              'totalStorage': 0,
              'price': 0.0,
              'type': 'Free',
              'duration': 'Free',
              'cloudStorage': 209715200,
              'noOfProject': 1,
              'noOfMember': 2,
              'projectCount': 0,
              'userImage': userImage['image'],
              'txnDate': date.toString()
            });
          });
        });
        await saveTokenPreferences(item['token']).then((_) {
          submitLoadings();
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MenuDashboardPage();
            },
          ));
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
    _usernameController?.close();
    _passwordConfirmController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
