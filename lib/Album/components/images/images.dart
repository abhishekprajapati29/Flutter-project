import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/api_response.dart';
import 'package:fproject/Album/components/images/addImages.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class Images extends StatefulWidget {
  List<Imagelist> imagelist;
  AlbumModel data;
  Function completeDeleteProcess;
  bool deleteLoading;
  String title;
  Function deleteFunction;
  String token;
  Images(
      {Key key,
      this.imagelist,
      this.token,
      this.data,
      this.title,
      this.completeDeleteProcess,
      this.deleteFunction,
      this.deleteLoading})
      : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: widget.imagelist.length > 0
            ? Padding(
                padding: const EdgeInsets.all(6.0),
                child: !widget.deleteLoading
                    ? new StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: widget.imagelist.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ImageView(
                                data: widget.imagelist[index],
                                token: widget.token,
                                completeDeleteProcess:
                                    widget.completeDeleteProcess,
                                deleteLoading: widget.deleteLoading,
                                deleteFunction: widget.deleteFunction,
                              );
                            }));
                          },
                          child: new Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          widget.imagelist[index].thumbnail),
                                      fit: BoxFit.cover))),
                        ),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(2, index.isEven ? 2 : 1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      )
                    : SpinKitFoldingCube(color: Colors.teal),
              )
            : Center(
                child: Text('No Images'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddImages(
              token: widget.token,
              albumId: widget.data.id,
              completeDeleteProcess: widget.completeDeleteProcess,
            );
          }));
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ImageView extends StatefulWidget {
  Imagelist data;
  Function completeDeleteProcess;
  bool deleteLoading;
  Function deleteFunction;
  String token;
  ImageView(
      {Key key,
      this.data,
      this.token,
      this.completeDeleteProcess,
      this.deleteFunction,
      this.deleteLoading})
      : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool downloading = false;
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  String filenamepath = '';

  Future<void> downloadFile(String imgUrl, String name) async {
    Dio dio = Dio();

    try {
      if (await Permission.storage.request().isGranted) {
        await Permission.storage.request();
        Directory appDocDir = await getExternalStorageDirectory();
        await dio.download(imgUrl, "${appDocDir.path}/$name",
            onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            filenamepath = "${appDocDir.path}/$name";
            downloading = true;
            totalprogressString = total;
            runningprogressString = rec;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        });
        Fluttertoast.showToast(
            msg: "Downloaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            webShowClose: true,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.caption),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: !downloading
            ? !widget.deleteLoading
                ? PhotoView(
                    imageProvider: NetworkImage(widget.data.src),
                  )
                : Center(
                    child: SpinKitFoldingCube(color: Colors.teal),
                  )
            : Container(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      alignment: AlignmentDirectional.center,
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                      ),
                      child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: new BorderRadius.circular(10.0)),
                        width: 300.0,
                        height: 200.0,
                        alignment: AlignmentDirectional.center,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Center(
                              child: new SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: new CircularProgressIndicator(
                                  value: null,
                                  strokeWidth: 7.0,
                                ),
                              ),
                            ),
                            new Container(
                              margin: const EdgeInsets.only(top: 25.0),
                              child: new Center(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: new Text('File:- $filenamepath',
                                        style:
                                            new TextStyle(color: Colors.white)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  new Text(
                                    'Downloaded:- $progressString',
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                  new Text(
                                    filesize(runningprogressString)
                                            .toString()
                                            .toString() +
                                        ' / ' +
                                        filesize(totalprogressString)
                                            .toString(),
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color: Colors.teal,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Spacer(),
              IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    downloadFile(widget.data.src, widget.data.caption);
                  }),
              Spacer(),
              VerticalDivider(
                color: Colors.white,
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  widget.deleteFunction();
                  await ondeleteAlbumImage(widget.data.id, widget.data.albumId);

                  await widget.completeDeleteProcess(widget.data.albumId);

                  widget.deleteFunction();
                  Navigator.pop(context);
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
