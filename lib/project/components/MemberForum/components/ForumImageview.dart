import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../models.dart';

class ForumImageView extends StatefulWidget {
  Forums data;
  ForumImageView({Key key, this.data}) : super(key: key);

  @override
  _ForumImageViewState createState() => _ForumImageViewState();
}

class _ForumImageViewState extends State<ForumImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Text(widget.data.content)),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.data.files),
      ),
    );
  }
}
