import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/setting/components/contactUs.dart';
import 'package:fproject/setting/components/notification.dart';
import 'package:fproject/setting/components/subscription.dart';
import 'package:fproject/setting/components/updatePassword.dart';

import '../gettoken.dart';
import 'api_responde.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int selectedIndex = 0;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  AllPlanModel sub;
  bool initialLoading = false;

  onItemTapped1(data) {
    setState(() {
      selectedIndex = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initialLoading = !initialLoading;
    });
    getTokenPreferences().then((token) async {
      await getPrivicy(token, _isChecked1, _isChecked2, _isChecked3)
          .then((value1) {
        setState(() {
          _isChecked1 = value1.post;
          _isChecked2 = value1.images;
          _isChecked3 = value1.info;
        });
      });
      await getCurrentPlan(token).then((value) {
        print(value.price);
        setState(() {
          sub = value;
          initialLoading = !initialLoading;
        });
      });
    });
  }

  handleChecked(data1, data2, data3) {
    setState(() {
      _isChecked1 = data1;
      _isChecked2 = data2;
      _isChecked3 = data3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: MyRoute,
        theme: ThemeData(
            accentColor: Colors.teal,
            canvasColor: Colors.transparent,
            fontFamily: 'CrimsonTextRegular'),
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          drawer: MyDrawer(),
          appBar: AppBar(
            title: selectedIndex == 0
                ? Text('Notification')
                : selectedIndex == 1
                    ? Text('Subscription')
                    : selectedIndex == 2
                        ? Text('Update Password')
                        : selectedIndex == 3 ? Text('Contact Us') : null,
            backgroundColor: Colors.teal,
          ),
          body: !initialLoading
              ? selectedIndex == 0
                  ? WillPopScope(
                      onWillPop: onWillPop,
                      child: Notifications(
                          handleChecked: handleChecked,
                          isChecked1: _isChecked1,
                          isChecked2: _isChecked2,
                          isChecked3: _isChecked3),
                    )
                  : selectedIndex == 1
                      ? Subs(
                          data: sub,
                        )
                      : selectedIndex == 2
                          ? UpdatePassword()
                          : selectedIndex == 3 ? ContactUs() : null
              : Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
          bottomNavigationBar: CurvedNavigationBar(
            height: 55,
            backgroundColor: Colors.grey[200],
            color: Colors.teal,
            items: <Widget>[
              Icon(
                FontAwesomeIcons.bell,
                size: 25,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.creditCard,
                size: 25,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.key,
                size: 25,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.teamspeak,
                size: 25,
                color: Colors.white,
              ),
            ],
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 350),
            index: selectedIndex,
            onTap: (index) {
              onItemTapped1(index);
            },
          ),
        ));
  }
}
