import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/setting/api_responde.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: subject,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)),
                labelText: 'Subject',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: message,
              minLines: 2,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black)),
                labelText: 'Message',
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: !loading
                    ? () {
                        setState(() {
                          loading = true;
                        });
                        getTokenPreferences().then((token) async {
                          await postContactUs(
                              token, subject.text, message.text);
                          setState(() {
                            subject.text = "";
                            message.text = "";
                            loading = false;
                          });
                        });
                      }
                    : null,
                color: Colors.teal,
                child: !loading
                    ? Text(
                        'Submit',
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
