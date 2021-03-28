import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/setting/api_responde.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  bool loading = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            error
                ? Text(
                    'Password Not Match',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: pass1,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: pass2,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)),
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: !loading
                    ? () {
                        if (pass1.text != pass2.text && pass1.text.length > 0) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          setState(() {
                            loading = true;
                          });
                          getTokenPreferences().then((token) async {
                            await updatePassword(token, pass2.text);
                            setState(() {
                              pass1.text = "";
                              pass2.text = "";
                              loading = false;
                              error = false;
                            });
                          });
                        }
                      }
                    : null,
                color: Colors.teal,
                icon: Icon(
                  FontAwesomeIcons.key,
                  color: Colors.white,
                ),
                label: !loading
                    ? Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      )
                    : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Colors.teal),
                      ))
          ],
        ),
      ),
    );
  }
}
