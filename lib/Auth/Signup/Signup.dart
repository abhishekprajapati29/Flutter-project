//import 'package:bloc/bloc.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';

import 'bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _error = "";
  final bloc = Bloc();
  bool submitLoading = false;
  @override
  Widget build(BuildContext context) {
    void submitLoadings() {
      setState(() {
        this.submitLoading = !submitLoading;
      });
    }

    manageError(data) {
      final jsonData = json.decode(data);
      print(jsonData['non_field_errors'][0]);
      setState(() {
        this._error = jsonData['non_field_errors'][0];
      });
      print('data');
      submitLoadings();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.teal[500],
                        Colors.teal[800],
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.teal[100],
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ],
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(100)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.teal[200],
                                        blurRadius: 200.0,
                                        offset: Offset(0, 10))
                                  ],
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 100,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.teal[100],
                                        blurRadius: 200.0,
                                        offset: Offset(0, 10))
                                  ],
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 50,
                        width: 80,
                        height: 50,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 100, right: 130),
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                        right: 0,
                        top: 100,
                        width: 280,
                        height: 280,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Mobile login-pana.png'))),
                            )),
                      ),
                    ],
                  ),
                ),
                _error != ""
                    ? SizedBox(
                        height: 25,
                      )
                    : Container(),
                _error != ""
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _error,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.teal[100],
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: StreamBuilder<String>(
                                    stream: bloc.username,
                                    builder: (context, snapshot) => TextField(
                                      onChanged: bloc.usernameChanged,
                                      style: TextStyle(color: Colors.teal),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Username",
                                          labelStyle: TextStyle(
                                              color: Colors.teal[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          labelText: "Username",
                                          errorText: snapshot.error),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.teal,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: StreamBuilder<String>(
                                    stream: bloc.email,
                                    builder: (context, snapshot) => TextField(
                                      onChanged: bloc.emailChanged,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(color: Colors.teal),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Email",
                                          labelStyle: TextStyle(
                                              color: Colors.teal[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          labelText: "Email",
                                          errorText: snapshot.error),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.teal,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: StreamBuilder<String>(
                                    stream: bloc.password,
                                    builder: (context, snapshot) => TextField(
                                      onChanged: bloc.passwordChanged,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.teal),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter password",
                                          labelStyle: TextStyle(
                                              color: Colors.teal[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          labelText: "Password",
                                          errorText: snapshot.error),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.teal,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: StreamBuilder<String>(
                                    stream: bloc.passwordConfirm,
                                    builder: (context, snapshot) => TextField(
                                      onChanged: bloc.passwordConfirmChanged,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.teal),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Confirm password",
                                          labelStyle: TextStyle(
                                              color: Colors.teal[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          labelText: "Confirm Password",
                                          errorText: snapshot.error),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        2,
                        StreamBuilder<bool>(
                            stream: bloc.submitCheck,
                            builder: (context, snapshot) => GestureDetector(
                                  onTap: submitLoading == false
                                      ? snapshot.hasData
                                          ? () => bloc.submit(
                                              context,
                                              submitLoadings,
                                              manageError,
                                              bloc.email,
                                              bloc.password)
                                          : null
                                      : null,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.teal[100],
                                              blurRadius: 20.0,
                                              offset: Offset(0, 10))
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.teal[500],
                                            Colors.teal[800],
                                          ],
                                        )),
                                    child: Center(
                                      child: submitLoading == false
                                          ? Text(
                                              "SignUp",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : CircularProgressIndicator(
                                              backgroundColor: Colors.teal[400],
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white)),
                                    ),
                                  ),
                                )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2.1,
                          Text(
                            "OR",
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2.2,
                          GestureDetector(
                            onTap: () {
                              Navigator.popAndPushNamed(context, '/login');
                            },
                            child: Text(
                              "<- Login",
                              style: TextStyle(color: Colors.teal),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
