import 'package:flutter/material.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/paytm/PaymentScreen.dart';

class Plans extends StatefulWidget {
  Plans({Key key}) : super(key: key);

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  bool button1 = true;
  bool button2 = false;
  bool button3 = false;
  bool month = true;
  bool year = false;
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image: AssetImage('assets/plan.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: ClipOval(
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
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(70.0),
                        child: Text(
                          'To get started, you will need to choose a plan for your needs.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 150),
                    height: 770,
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.teal[300],
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ],
                        ),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  FlatButton(
                                    color: month ? Colors.teal : Colors.white,
                                    splashColor: Colors.teal,
                                    onPressed: () {
                                      setState(() {
                                        month = true;
                                        year = false;
                                        button2 = false;
                                        button3 = false;
                                        button1 = true;
                                      });
                                    },
                                    child: Text('Monthly',
                                        style: TextStyle(
                                            color: month
                                                ? Colors.white
                                                : Colors.teal)),
                                    textColor:
                                        month ? Colors.white : Colors.teal,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: month
                                                ? Colors.teal
                                                : Colors.teal,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  Spacer(),
                                  FlatButton(
                                    color: year ? Colors.teal : Colors.white,
                                    splashColor: Colors.teal,
                                    onPressed: () {
                                      setState(() {
                                        year = true;
                                        month = false;
                                        button2 = false;
                                        button3 = false;
                                        button1 = true;
                                      });
                                    },
                                    child: Text('Yearly',
                                        style: TextStyle(
                                            color: year
                                                ? Colors.white
                                                : Colors.teal)),
                                    textColor:
                                        year ? Colors.white : Colors.teal,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: year
                                                ? Colors.teal
                                                : Colors.teal,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  Column(
                                    children: [
                                      FlatButton(
                                        color: button1
                                            ? Colors.teal
                                            : Colors.white,
                                        splashColor: Colors.teal,
                                        onPressed: () {
                                          setState(() {
                                            button1 = true;
                                            button2 = false;
                                            button3 = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text('Free',
                                              style: TextStyle(
                                                  color: button1
                                                      ? Colors.white
                                                      : Colors.teal)),
                                        ),
                                        textColor: button1
                                            ? Colors.white
                                            : Colors.teal,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: button1
                                                    ? Colors.teal
                                                    : Colors.teal,
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: button1
                                            ? Text(
                                                '\u{20B9}0/Month',
                                                style: TextStyle(
                                                    color: Colors.teal),
                                              )
                                            : Text(
                                                '\u{20B9}0/Month',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      FlatButton(
                                        color: button2
                                            ? Colors.teal
                                            : Colors.white,
                                        splashColor: Colors.teal,
                                        onPressed: () {
                                          setState(() {
                                            button1 = false;
                                            button2 = true;
                                            button3 = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text('Premium',
                                              style: TextStyle(
                                                  color: button2
                                                      ? Colors.white
                                                      : Colors.teal)),
                                        ),
                                        textColor: button2
                                            ? Colors.white
                                            : Colors.teal,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: button2
                                                    ? Colors.teal
                                                    : Colors.teal,
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: button2
                                            ? !year
                                                ? Text('\u{20B9}89/Month',
                                                    style: TextStyle(
                                                        color: Colors.teal))
                                                : Text('\u{20B9}748/Year',
                                                    style: TextStyle(
                                                        color: Colors.teal))
                                            : !year
                                                ? Text(
                                                    '\u{20B9}89/Month',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                : Text(
                                                    '\u{20B9}748/Year',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      FlatButton(
                                        color: button3
                                            ? Colors.teal
                                            : Colors.white,
                                        splashColor: Colors.teal,
                                        onPressed: () {
                                          setState(() {
                                            button1 = false;
                                            button2 = false;
                                            button3 = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text('Platinum',
                                              style: TextStyle(
                                                  color: button3
                                                      ? Colors.white
                                                      : Colors.teal)),
                                        ),
                                        textColor: button3
                                            ? Colors.white
                                            : Colors.teal,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: button3
                                                    ? Colors.teal
                                                    : Colors.teal,
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: button3
                                            ? !year
                                                ? Text('\u{20B9}199/Month',
                                                    style: TextStyle(
                                                        color: Colors.teal))
                                                : Text('\u{20B9}1672/Year',
                                                    style: TextStyle(
                                                        color: Colors.teal))
                                            : !year
                                                ? Text(
                                                    '\u{20B9}199/Month',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                : Text(
                                                    '\u{20B9}1672/Year',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 20, right: 15, bottom: 12),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text("No of Team's"),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  button1
                                      ? Text(
                                          '1',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('1'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button2
                                      ? Text(
                                          '1',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('1'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button3
                                      ? Text(
                                          '1',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('1'),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 12, right: 15, bottom: 12),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text("No of Team Member's"),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  button1
                                      ? Text(
                                          '3',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('3'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button2
                                      ? Text(
                                          '5',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('5'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button3
                                      ? Text(
                                          '20',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('20'),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 12, right: 15, bottom: 12),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text("No of Project's"),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  button1
                                      ? Text(
                                          '1',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('1'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button2
                                      ? Text(
                                          '5',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('5'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button3
                                      ? Text(
                                          '10',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('10'),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 12, right: 15, bottom: 12),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text("No of Project Member's"),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  button1
                                      ? Text(
                                          '2',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('2'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button2
                                      ? Text(
                                          '5',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('5'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button3
                                      ? Text(
                                          '20',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('20'),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 12, right: 15, bottom: 12),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text("Cloud Storage"),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  button1
                                      ? Text(
                                          '200 MB',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('200 MB'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button2
                                      ? Text(
                                          '1 GB',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('1 GB'),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  button3
                                      ? Text(
                                          '2.5 GB',
                                          style: TextStyle(color: Colors.teal),
                                        )
                                      : Text('2.5 GB'),
                                  Spacer(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 20, right: 15, bottom: 20),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              ButtonTheme(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.80,
                                child: RaisedButton(
                                  color: Colors.teal,
                                  onPressed: () {
                                    if (month && button2) {
                                      setState(() {
                                        amount = 89;
                                      });
                                    } else if (month && button3) {
                                      setState(() {
                                        amount = 199;
                                      });
                                    } else if (year && button2) {
                                      setState(() {
                                        amount = 748;
                                      });
                                    } else if (year && button3) {
                                      setState(() {
                                        amount = 1672;
                                      });
                                    } else {
                                      setState(() {
                                        amount = 0;
                                      });
                                    }
                                    getUserPreferences().then((user) {
                                      getTokenPreferences().then((token) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return PaymentScreen(
                                                amount: amount.toString(),
                                                token: token,
                                                username: user.username);
                                          },
                                        ));
                                      });
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    'BUY NOW',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
