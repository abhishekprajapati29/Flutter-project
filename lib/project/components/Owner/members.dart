import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/gettoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/models.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import '../../../gettoken.dart';

class Members extends StatefulWidget {
  final List<Promem> data;
  final List<UserModel> allUser;
  const Members({Key key, this.data, this.allUser}) : super(key: key);

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final users = <String>[];
  final userdetail = <UserModel>[];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    for (var item in widget.data) {
      users.add(item.member);
    }
    for (var item in users) {
      UserModel detail = widget.allUser
          .where((element) => element.username == item)
          .toList()[0];
      userdetail.add(detail);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.teal,
              brightness: Brightness.dark,
              elevation: 8,
              title: Text(
                'Members',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: userdetail.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel mem = userdetail[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectUserProfile(
                        data: userdetail[index],
                        usercount: widget.data,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 2,
                              color: Colors.teal,
                            ),
                            // shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(mem.image.image),
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
                                      Text(
                                        mem.username.capitalize(),
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
                                  mem.profile.aboutMe,
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
            ),
          )
        : Center(
            child: SpinKitFoldingCube(color: Colors.teal),
          );
  }
}

class ProjectUserProfile extends StatefulWidget {
  UserModel data;
  List<Promem> usercount;
  ProjectUserProfile({Key key, this.data, this.usercount}) : super(key: key);

  @override
  _ProjectUserProfileState createState() => _ProjectUserProfileState();
}

class _ProjectUserProfileState extends State<ProjectUserProfile> {
  var userImages = <Imagelist>[];
  bool loadingImagesAll = false;

  Future<List<Imagelist>> getUserImages1(String token, String username) async {
    var finaldata = <Imagelist>[];
    await http.get(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/imagelistall/'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) {
      if (value.statusCode == 200) {
        for (var item in jsonDecode(value.body)) {
          if (item['user'] == username) {
            final data = Imagelist(
                id: item['id'],
                user: item['user'],
                albumId: item['album_id'],
                src: item['src'],
                thumbnail: item['thumbnail'],
                thumbnailWidth: item['thumbnailWidth'],
                thumbnailHeight: item['thumbnailHeight'],
                caption: item['caption'],
                selected: item['selected'],
                size: item['size'],
                favourite: item['favourite']);
            finaldata.add(data);
          }
        }
      }
    });
    return finaldata;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loadingImagesAll = true;
    });
    getTokenPreferences().then((token) async {
      await getUserImages1(token, widget.data.username).then((value) {
        this.setState(() {
          userImages = value;
          loadingImagesAll = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.data.profile.backgroundImage),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: ClipOval(
                            child: Material(
                              color: Colors.blueGrey, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      width: 150,
                      height: 150,
                      child: Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: Ink.image(
                          image: NetworkImage(widget.data.image.image),
                          fit: BoxFit.cover,
                          width: 120.0,
                          height: 120.0,
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfileImageView(
                                    data: widget.data,
                                  );
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
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.data.username.capitalize(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.data.profile.aboutMe,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Spacer(),
                            Column(
                              children: [
                                FlatButton.icon(
                                    onPressed: () {},
                                    icon: Icon(FontAwesomeIcons.users),
                                    label: Text('Team')),
                                Text(widget.data.profile.teamName.toUpperCase())
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                FlatButton.icon(
                                    onPressed: () {},
                                    icon: Icon(FontAwesomeIcons.users),
                                    label: Text('Members')),
                                Text(widget.usercount.length.toString())
                              ],
                            ),
                            Spacer(),
                          ],
                        )),
                    !loadingImagesAll
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: userImages.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ImageViewAll(
                                      data: userImages[index],
                                    );
                                  }));
                                },
                                child: new Container(
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                            image: new NetworkImage(
                                                userImages[index].src),
                                            fit: BoxFit.cover))),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 2 : 1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                          )
                        : SpinKitFoldingCube(color: Colors.teal)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewAll extends StatefulWidget {
  Imagelist data;
  int allCount;
  ImageViewAll({Key key, this.data, this.allCount}) : super(key: key);

  @override
  _ImageViewAllState createState() => _ImageViewAllState();
}

class _ImageViewAllState extends State<ImageViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(widget.data.caption),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.data.src),
      ),
    );
  }
}

class ProfileImageView extends StatefulWidget {
  UserModel data;
  int allCount;
  String token;
  Function updateCurrentUser;
  UserModel currentUserData;
  ProfileImageView(
      {Key key,
      this.data,
      this.allCount,
      this.token,
      this.updateCurrentUser,
      this.currentUserData})
      : super(key: key);

  @override
  _ProfileImageViewState createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  bool loading = false;

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.username.capitalize()),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: !loading
              ? PhotoView(
                  imageProvider: NetworkImage(widget.data.image.image),
                )
              : Center(child: SpinKitFoldingCube(color: Colors.teal))),
    );
  }
}
