import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/setting/api_responde.dart';

class Notifications extends StatefulWidget {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  Function handleChecked;
  Notifications(
      {Key key,
      this.isChecked1,
      this.isChecked2,
      this.isChecked3,
      this.handleChecked})
      : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _currText = '';
  String token = "";
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;

  List<String> text = ["Show Posts", "Show Images", "showInfo"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        color: Colors.grey[200],
        height: 350.0,
        child: Column(children: [
          !_isLoading1
              ? CheckboxListTile(
                  title: Text('Show Posts'),
                  activeColor: Colors.teal,
                  value: widget.isChecked1,
                  onChanged: (val) async {
                    setState(() {
                      _isLoading1 = true;
                    });
                    widget.handleChecked(
                      val,
                      widget.isChecked2,
                      widget.isChecked3,
                    );
                    await getTokenPreferences().then((token) async {
                      await getData(
                        token,
                        val,
                        widget.isChecked2,
                        widget.isChecked3,
                      ).then((value1) {
                        widget.handleChecked(
                            value1.post, value1.images, value1.info);
                        setState(() {
                          _isLoading1 = false;
                        });
                      });
                    });
                  },
                )
              : ListTile(
                  title: Text('Show Posts'),
                  trailing: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                  ),
                ),
          !_isLoading2
              ? CheckboxListTile(
                  title: Text('Show Images'),
                  activeColor: Colors.teal,
                  value: widget.isChecked2,
                  onChanged: (val) async {
                    setState(() {
                      _isLoading2 = true;
                    });
                    widget.handleChecked(
                      widget.isChecked1,
                      val,
                      widget.isChecked3,
                    );
                    await getTokenPreferences().then((token) async {
                      await getData(
                        token,
                        widget.isChecked1,
                        val,
                        widget.isChecked3,
                      ).then((value1) {
                        widget.handleChecked(
                            value1.post, value1.images, value1.info);
                        setState(() {
                          _isLoading2 = false;
                        });
                      });
                    });
                  },
                )
              : ListTile(
                  title: Text('Show Images'),
                  trailing: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                  ),
                ),
          !_isLoading3
              ? CheckboxListTile(
                  title: Text('Show Info'),
                  activeColor: Colors.teal,
                  value: widget.isChecked3,
                  onChanged: (val) async {
                    setState(() {
                      _isLoading3 = true;
                    });
                    widget.handleChecked(
                      widget.isChecked1,
                      widget.isChecked2,
                      val,
                    );
                    await getTokenPreferences().then((token) async {
                      await getData(
                        token,
                        widget.isChecked1,
                        widget.isChecked2,
                        val,
                      ).then((value1) {
                        widget.handleChecked(
                            value1.post, value1.images, value1.info);
                        setState(() {
                          _isLoading3 = false;
                        });
                      });
                    });
                  },
                )
              : ListTile(
                  title: Text('Show Info'),
                  trailing: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Colors.teal),
                      )),
                ),
        ]),
      ),
    );
  }
}
