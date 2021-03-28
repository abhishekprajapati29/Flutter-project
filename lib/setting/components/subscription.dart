import 'dart:async';

import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/setting/components/plans.dart';

import '../../gettoken.dart';
import '../api_responde.dart';

class Subs extends StatefulWidget {
  AllPlanModel data;
  Subs({Key key, this.data}) : super(key: key);

  @override
  _SubsState createState() => _SubsState();
}

class _SubsState extends State<Subs> {
  bool loading = false;
  AllPlanModel data;

  cancelSubscription() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Cancel Subscription !",
              style: TextStyle(
                  fontFamily: 'CrimsonTextRegular',
                  fontWeight: FontWeight.bold),
            ),
            content: Text("Are you sure?",
                style: TextStyle(
                    fontFamily: 'CrimsonTextRegular',
                    fontWeight: FontWeight.bold)),
            actions: [
              CupertinoDialogAction(
                child: Text('No',
                    style: TextStyle(
                        fontFamily: 'CrimsonTextRegular',
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes',
                    style: TextStyle(
                        fontFamily: 'CrimsonTextRegular',
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    loading = true;
                  });
                  await getTokenPreferences().then((token) async {
                    await getUserPreferences().then((user) async {
                      await cancelSubs(token, user.username).then((sub) {
                        setState(() {
                          data = sub;
                          loading = false;
                        });
                      });
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return !loading
        ? SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 100),
                            Center(
                              child: Text(
                                '\u{20B9}' +
                                    data.price.toString() +
                                    '/' +
                                    data.time,
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 44,
                                  color: const Color(0xff47455f),
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Platinum',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 30,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              thickness: 5,
                            ),
                            Center(child: Text('1 Team')),
                            Divider(
                              thickness: 2,
                            ),
                            Center(
                                child: Text(
                                    "${data.noOfTeamMember} Team Members's")),
                            Divider(
                              thickness: 2,
                            ),
                            Center(
                                child: Text("${data.noOfProjects} Project's")),
                            Divider(
                              thickness: 2,
                            ),
                            Center(
                                child: Text(
                                    "${data.noOfProjectMembers} Project Member's")),
                            Divider(
                              thickness: 2,
                            ),
                            Center(
                                child: Text(filesize(data.cloudStorageValue) +
                                    " Cloud Storage")),
                            Divider(
                              thickness: 5,
                            ),
                            Stack(children: [
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return Plans();
                                        },
                                      ));
                                    },
                                    child: Text(
                                      'Upgrade',
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        fontSize: 18,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    cancelSubscription();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 18,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green,
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Icon(
                        Icons.ac_unit,
                        size: 60,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          )
        : Center(
            child: SpinKitFoldingCube(
            color: Colors.teal,
          ));
  }
}
