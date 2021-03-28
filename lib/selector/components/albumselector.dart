import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/selector/components/api_response.dart';

class AlbumSelector extends StatefulWidget {
  List<AlbumModel> albums;
  bool initLoading;
  Function handlealbum;
  Function handleIncrementspace;
  Function handleDecrementspace;
  bool selected;
  AlbumSelector(
      {Key key,
      this.albums,
      this.initLoading,
      this.handlealbum,
      this.selected,
      this.handleDecrementspace,
      this.handleIncrementspace})
      : super(key: key);

  @override
  _AlbumSelectorState createState() => _AlbumSelectorState();
}

class _AlbumSelectorState extends State<AlbumSelector> {
  bool checkboxLoading = false;
  int id = -1;

  @override
  Widget build(BuildContext context) {
    return !widget.initLoading
        ? widget.albums.length > 0
            ? ListView.builder(
                itemCount: widget.albums.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 6,
                      child: ListTile(
                          title: Text(widget.albums[index].title),
                          leading: Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                          trailing: widget.selected
                              ? widget.albums[index].id != id
                                  ? Checkbox(
                                      value: widget.albums[index].selected,
                                      onChanged: (bool value) {
                                        setState(() {
                                          checkboxLoading = true;
                                          id = widget.albums[index].id;
                                        });
                                        getTokenPreferences().then((token) {
                                          patchSelectedAlbum(token, value,
                                                  widget.albums[index].id)
                                              .then((value1) {
                                            final albumlist = widget.albums
                                                .where((element) =>
                                                    element.id != value1.id)
                                                .toList();
                                            widget.handlealbum([
                                              ...albumlist,
                                              value1
                                            ]..sort((a, b) =>
                                                a.id.compareTo(b.id)));
                                            if (value1.selected == true) {
                                              widget.handleIncrementspace(
                                                  value1.imagelistsize);
                                            } else {
                                              widget.handleDecrementspace(
                                                  value1.imagelistsize);
                                            }
                                            setState(() {
                                              checkboxLoading = false;
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
                              : null));
                })
            : Center(
                child: Text('No albums'),
              )
        : Center(child: SpinKitFoldingCube(color: Colors.teal));
  }
}
