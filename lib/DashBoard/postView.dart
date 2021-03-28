import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/Auth/login/model.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:intl/intl.dart';

class PostView extends StatefulWidget {
  PostModel post;
  Function handlePost;
  Function handlePost1;
  List<UserModel> allUsers;
  PostView(
      {Key key, this.post, this.allUsers, this.handlePost, this.handlePost1})
      : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  UserModel currentUser;
  PostModel post;
  bool sendLoading = false;
  bool deleteLoading = false;
  CurrentUserPref userPref;
  bool deleteload = false;
  TextEditingController controlComment = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mounted) return;
    setState(() {
      post = widget.post;
      deleteload = true;
    });
    getUserPreferences().then((value) {
      if (!mounted) return;
      setState(() {
        userPref = value;
        deleteload = false;
      });
    });
    getTokenPreferences().then((token) async {
      await getCurrentUser(token).then((val) {
        if (!mounted) return;
        this.setState(() {
          currentUser = val;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: ClipOval(
                  child: Material(
                    color: Colors.blueGrey, // button color
                    child: InkWell(
                      splashColor: Colors.blue, // inkwell color
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_left,
                            color: Colors.white,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                trailing: !deleteload
                    ? userPref.username == post.user
                        ? !deleteLoading
                            ? ClipOval(
                                child: Material(
                                  color: Colors.blueGrey, // button color
                                  child: InkWell(
                                    splashColor: Colors.blue, // inkwell color
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        )),
                                    onTap: () {
                                      setState(() {
                                        deleteLoading = true;
                                      });
                                      getTokenPreferences().then((token) async {
                                        await deleteComment(token, post.id)
                                            .then((value) async {
                                          setState(() {
                                            deleteLoading = false;
                                          });
                                          await widget.handlePost1(value);
                                        });
                                      });
                                    },
                                  ),
                                ),
                              )
                            : CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation(Colors.teal),
                              )
                        : Container()
                    : null,
                title: Text(
                  post.user.capitalize(),
                  textAlign: TextAlign.start,
                ),
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: post.img != null
                    ? Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(post.img),
                              fit: BoxFit.cover,
                            )))
                    : Container(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: post.content != null
                    ? Text(
                        post.content,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )
                    : null,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: Divider(
                  thickness: 5,
                ),
              ),
              ListTile(
                title: Text(
                  '${post.commentCount} Comments',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal,
                    child: currentUser != null
                        ? CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                NetworkImage(currentUser.image.image),
                          )
                        : Text(
                            post.user.capitalize().substring(0, 1),
                            style: TextStyle(fontSize: 25),
                          ),
                  ),
                  title: TextField(
                    controller: controlComment,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 25),
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'Add Comment',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black))),
                  ),
                  trailing: !sendLoading
                      ? IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              sendLoading = true;
                            });
                            getTokenPreferences().then((token) async {
                              await sendComment(
                                      token, controlComment.text, post.id, post)
                                  .then((value) {
                                print(post.commentCount);
                                setState(() {
                                  post = value;
                                  controlComment.text = '';
                                  sendLoading = false;
                                });
                                print(post.commentCount);
                                widget.handlePost(value);
                              });
                            });
                          },
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Colors.teal),
                        )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: post.postComment.length > 0
                      ? ListView.builder(
                          itemCount: post.postComment.length,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.teal,
                                  child: currentUser != null
                                      ? CircleAvatar(
                                          radius: 26,
                                          backgroundImage: NetworkImage(widget
                                              .allUsers
                                              .where((element) =>
                                                  element.username ==
                                                  post.postComment[index]
                                                      .commentedBy)
                                              .toList()
                                              .first
                                              .image
                                              .image))
                                      : Text(
                                          post.user
                                              .capitalize()
                                              .substring(0, 1),
                                          style: TextStyle(fontSize: 25),
                                        ),
                                ),
                                title: Text(
                                    post.postComment[index].commentContent),
                                subtitle: Text(DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(post
                                        .postComment[index].commentTimestamp))),
                              ),
                            );
                          },
                        )
                      : Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
