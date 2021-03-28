import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Video/components/model.dart';

import '../../gettoken.dart';
import 'api_response.dart';

class VideoSelector extends StatefulWidget {
  List<VideoModel> videos;
  bool initLoading;
  Function handlevideo;
  Function handleIncrementspace;
  Function handleDecrementspace;
  bool selected;
  VideoSelector(
      {Key key,
      this.videos,
      this.initLoading,
      this.selected,
      this.handlevideo,
      this.handleDecrementspace,
      this.handleIncrementspace})
      : super(key: key);

  @override
  _VideoSelectorState createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<VideoSelector> {
  int id = -1;

  @override
  Widget build(BuildContext context) {
    return !widget.initLoading
        ? widget.videos.length > 0
            ? ListView.builder(
                itemCount: widget.videos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    child: ListTile(
                        title: Text(widget.videos[index].title),
                        leading: Icon(
                          FontAwesomeIcons.video,
                          color: Colors.grey,
                        ),
                        trailing: widget.selected
                            ? widget.videos[index].id != id
                                ? Checkbox(
                                    value: widget.videos[index].selected,
                                    onChanged: (bool value) {
                                      setState(() {
                                        id = widget.videos[index].id;
                                      });
                                      getTokenPreferences().then((token) {
                                        patchSelectedVideo(token, value,
                                                widget.videos[index].id)
                                            .then((value1) {
                                          final videolist = widget.videos
                                              .where((element) =>
                                                  element.id != value1.id)
                                              .toList();
                                          widget.handlevideo([
                                            ...videolist,
                                            value1
                                          ]..sort(
                                              (a, b) => a.id.compareTo(b.id)));
                                          if (value1.selected == true) {
                                            widget.handleIncrementspace(
                                                value1.size);
                                          } else {
                                            widget.handleDecrementspace(
                                                value1.size);
                                          }
                                          setState(() {
                                            id = -1;
                                          });
                                        });
                                      });
                                    })
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.teal,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                            : null),
                  );
                })
            : Center(
                child: Text('No Videos'),
              )
        : Center(child: SpinKitFoldingCube(color: Colors.teal));
  }
}
