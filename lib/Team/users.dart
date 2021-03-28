import 'package:flutter/material.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/Team/profileView.dart';
import 'package:fproject/gettoken.dart';

class TeamMembers extends StatefulWidget {
  List<UserModel> data;
  List<UserModel> allUsersData;
  List<InoviceModel> invoiceData1;
  String teamName;
  Function updateInvoice2;
  Function updateInvoice12;
  List<InoviceModel> invoiceData;
  Function updateCurrentUser;
  String token;
  UserModel currentUserData;
  TeamMembers(
      {Key key,
      this.data,
      this.invoiceData,
      this.updateInvoice2,
      this.invoiceData1,
      this.updateInvoice12,
      this.currentUserData,
      this.token,
      this.teamName,
      this.allUsersData,
      this.updateCurrentUser})
      : super(key: key);

  @override
  _TeamMembersState createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: _buildPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        final UserModel chat = widget.data[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileView(
                    token: widget.token,
                    invoiceData: widget.invoiceData,
                    updateInvoice2: widget.updateInvoice2,
                    currentUserData: widget.currentUserData,
                    invoiceData1: widget.invoiceData1,
                    profileData: widget.data[index],
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
                                    invoiceData: widget.invoiceData,
                                    updateInvoice2: widget.updateInvoice2,
                                    currentUserData: widget.currentUserData,
                                    invoiceData1: widget.invoiceData1,
                                    profileData: widget.data[index],
                                    updateCurrentUser: widget.updateCurrentUser,
                                    allUsersData: widget.allUsersData);
                              },
                            ));
                          },
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(width: 5, color: Colors.white70),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                chat.username.capitalize(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }
}
