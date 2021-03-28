import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/plan.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  final String username;
  final String token;

  PaymentScreen({this.amount, this.username, this.token});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _loadingPayment = false;
  Future<void> saveUserPreferences(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('price', data['price']);
    prefs.setString('type', data['type']);
    prefs.setInt('cloudStorage', data['cloudStorage']);
    prefs.setInt('noOfProject', data['noOfProject']);
    prefs.setBool('selected', data['selected']);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl:
                  'https://paytm-app.herokuapp.com/paywithpaytm?amount=${widget.amount}&name=${widget.username}&token=${widget.token}',
              onPageFinished: (page) async {
                if (page.contains("/dashboard")) {
                  setState(() {
                    _loadingPayment = true;
                  });
                  await getPlan(widget.token, widget.username)
                      .then((plan) async {
                    await getCurrentUser(widget.token).then((cuser) async {
                      final subPlanDetail = Plan_detail;
                      for (var item1 in subPlanDetail) {
                        if (double.parse(item1['price'].toString()) ==
                            double.parse(plan.amount)) {
                          await saveUserPreferences({
                            'selected': cuser.profile.selected,
                            'price': item1['price'],
                            'type': item1['type'],
                            'cloudStorage': item1['cloud_storage_value'],
                            'noOfProject': item1['No_of_Projects'],
                          });
                        }
                      }
                      setState(() {
                        _loadingPayment = false;
                      });
                    });
                  });
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/dashboard');
                }
              },
            ),
          ),
          (_loadingPayment)
              ? Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                )
              : Center(),
        ],
      )),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Thank you making the payment!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName("/dashboard"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName("/dashboard"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName("/dashboard"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
