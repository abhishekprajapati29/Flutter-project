import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/Team/profileView.dart';

import '../gettoken.dart';
import 'api_response.dart';
import 'model.dart';

class AddMembers extends StatefulWidget {
  String token;
  List<UserModel> allUsersData;
  Function updateCurrentUser;
  UserModel currentUserData;
  List<InoviceModel> invoiceData;
  Function updateInvoice;
  AddMembers(
      {Key key,
      this.currentUserData,
      this.updateInvoice,
      this.allUsersData,
      this.invoiceData,
      this.token,
      this.updateCurrentUser})
      : super(key: key);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  List<UserModel> defaultTeamData = [];
  bool loading = false;
  List<InoviceModel> invoiceData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loading = true;
      invoiceData = widget.invoiceData;
    });

    getTokenPreferences().then(_handletoken);
  }

  updateInvoice1(InoviceModel value) {
    invoiceData = [...invoiceData, value];
  }

  _handletoken(String token) {
    getDefaultMember(token).then((data) {
      this.setState(() {
        defaultTeamData = data;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Member'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: !loading
          ? ListView.builder(
              itemCount: defaultTeamData.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel chat = defaultTeamData[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileView(
                            token: widget.token,
                            currentUserData: widget.currentUserData,
                            profileData: defaultTeamData[index],
                            invoiceData: invoiceData,
                            updateInvoice: widget.updateInvoice,
                            updateInvoice1: updateInvoice1,
                            updateCurrentUser: widget.updateCurrentUser,
                            allUsersData: widget.allUsersData)),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Material(
                              elevation: 4.0,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              child: Ink.image(
                                image: NetworkImage(chat.image.image),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ProfileView(
                                            token: widget.token,
                                            currentUserData:
                                                widget.currentUserData,
                                            profileData: defaultTeamData[index],
                                            invoiceData: invoiceData,
                                            updateInvoice: widget.updateInvoice,
                                            updateInvoice1: updateInvoice1,
                                            updateCurrentUser:
                                                widget.updateCurrentUser,
                                            allUsersData: widget.allUsersData);
                                      },
                                    ));
                                  },
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border:
                                  Border.all(width: 5, color: Colors.white70),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 8.0, // soften the shadow
                                  spreadRadius: 3.0,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.64,
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          chat.username.length > 25
                                              ? chat.username
                                                  .capitalize()
                                                  .substring(0, 25)
                                              : chat.username.capitalize(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      true
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : Container(
                                              child: null,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  chat.profile.email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
    );
  }
}
