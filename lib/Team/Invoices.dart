import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Invoices extends StatefulWidget {
  List<InoviceModel> invoiceData;
  String token;
  Function loadingChange;
  Function handleAcceptInvite;
  UserModel currentUserData;
  Invoices({
    Key key,
    this.invoiceData,
    this.handleAcceptInvite,
    this.currentUserData,
    this.loadingChange,
    this.token,
  }) : super(key: key);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  bool loading = false;

  loadingChange() {
    loading = !loading;
  }

  handleInvoice(String token, UserModel currentUserData, InoviceModel data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Accept This Invitation"),
            content: Text("Are you sure?"),
            actions: [
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.pop(context);
                  await loadingChange();
                  if (currentUserData.profile.teamName == 'default_team_name') {
                    print('1');
                    await http.get(
                        Uri.encodeFull(
                            'http://abhishekpraja.pythonanywhere.com/addUserList/' +
                                data.requestedBy.toString() +
                                '/'),
                        headers: {
                          "Accept": 'application/json',
                          "Authorization": 'Token ' + token,
                        }).then((value) async {
                      if (value.statusCode == 200) {
                        final jsonData = jsonDecode(value.body);
                        String teamName = jsonData['profile']['teamName'];
                        print(teamName);
                        await acceptInvite(
                                token, currentUserData, data, teamName)
                            .then((_) async {
                          await widget.handleAcceptInvite();
                          await loadingChange();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('teamName', teamName);
                        });
                      }
                    });
                  } else {
                    print('2');
                    await acceptInvite1(token, currentUserData, data)
                        .then((_) async {
                      await widget.handleAcceptInvite();
                      await loadingChange();
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Invoices'),
        ),
        body: !loading
            ? widget.invoiceData.length > 0
                ? ListView.builder(
                    itemCount: widget.invoiceData.length,
                    itemBuilder: (context, index) {
                      return Container(
                          height: 80,
                          width: double.maxFinite,
                          child: Material(
                              color: Colors.transparent,
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                child: ListTile(
                                  onTap: () {},
                                  leading: Icon(
                                    FontAwesomeIcons.envelopeOpenText,
                                    size: 40,
                                  ),
                                  title: Text(widget.invoiceData[index].invoice,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  trailing: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.plus,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      handleInvoice(
                                          widget.token,
                                          widget.currentUserData,
                                          widget.invoiceData[index]);
                                    },
                                  ),
                                ),
                              )));
                    },
                  )
                : Center(
                    child: Text('No Invoices'),
                  )
            : Center(
                child: SpinKitFoldingCube(color: Colors.teal),
              ));
  }
}
