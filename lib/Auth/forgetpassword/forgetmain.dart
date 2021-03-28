import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fproject/Auth/forgetpassword/bloc.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';

class ForgetMain extends StatefulWidget {
  ForgetMain({Key key}) : super(key: key);

  @override
  _ForgetMainState createState() => _ForgetMainState();
}

class _ForgetMainState extends State<ForgetMain> {
  String _error = "";
  final bloc = Bloc();
  bool submitLoading = false;
  int number = 0;
  bool status = false;

  @override
  Widget build(BuildContext context) {
    void submitLoadings() {
      setState(() {
        this.submitLoading = !submitLoading;
      });
    }

    manageError(data) {
      setState(() {
        this._error = data;
      });
      submitLoadings();
    }

    sendStatus() {
      setState(() {
        this.status = true;
        this.submitLoading = false;
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
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
                        height: 200,
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
                        height: 150,
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
                        top: 40,
                        width: 80,
                        height: 150,
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
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Send Reset Email",
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
                        right: 30,
                        top: 250,
                        width: 180,
                        height: 180,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Login-amico (1).png'))),
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
                            child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: StreamBuilder<String>(
                                  stream: bloc.verifyEmail,
                                  builder: (context, snapshot) => TextField(
                                    onChanged: bloc.verifyEmailChanged,
                                    style: TextStyle(color: Colors.teal),
                                    keyboardType: TextInputType.emailAddress,
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
                                )),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      !status
                          ? FadeAnimation(
                              2,
                              GestureDetector(
                                  onTap: submitLoading == false
                                      ? () {
                                          int min =
                                              100000; //min and max values act as your 6 digit range
                                          int max = 999999;
                                          var randomizer = new Random();
                                          var rNum = min +
                                              randomizer.nextInt(max - min);
                                          setState(() {
                                            number = rNum;
                                          });
                                          bloc.submit(
                                              context,
                                              submitLoadings,
                                              manageError,
                                              bloc.verifyEmail,
                                              sendStatus);
                                        }
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
                                              "Send",
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
                                  )),
                            )
                          : FadeAnimation(
                              2,
                              GestureDetector(
                                  onTap: () {},
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
                                              "Send Successful",
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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.popAndPushNamed(context, '/login');
                                },
                                child: Text(
                                  "<- Login",
                                  style: TextStyle(color: Colors.teal),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.popAndPushNamed(context, '/signup');
                                },
                                child: Text(
                                  "SignUp ->",
                                  style: TextStyle(color: Colors.teal),
                                ),
                              ),
                            ],
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
