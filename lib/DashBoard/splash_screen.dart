import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/gettoken.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTokenPreferences().then((token) async {
      if (token != null) {
        await getCurrentUser(token).then((value) {
          if (value == null) {
            Timer(Duration(seconds: 2),
                () => Navigator.popAndPushNamed(context, '/login'));
          } else {
            Timer(Duration(seconds: 2),
                () => Navigator.popAndPushNamed(context, '/dashboard'));
          }
        });
      } else {
        Timer(Duration(seconds: 2),
            () => Navigator.popAndPushNamed(context, '/login'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        child: FadeAnimation(
                            2,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logo.png'))),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      FadeAnimation(
                        2.5,
                        Text(
                          "Assign Project's",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FadeAnimation(
                  3,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // CircularProgressIndicator(
                      //     valueColor: AlwaysStoppedAnimation(Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        'loading ...',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Pacifico',
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 100, left: 100),
                        child: LinearProgressIndicator(
                            backgroundColor: Colors.white10,
                            minHeight: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
