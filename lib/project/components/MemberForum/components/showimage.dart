import 'dart:io';

import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String image;
  const ShowImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.file(File(image), fit: BoxFit.fill),
    );
  }
}
