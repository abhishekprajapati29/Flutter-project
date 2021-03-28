import 'package:fluttertoast/fluttertoast.dart';
import 'package:fproject/Album/AlbumMain.dart';
import 'package:fproject/Auth/login/model.dart';
import 'package:fproject/DashBoard/Invites.dart';
import 'package:fproject/DashBoard/message.dart';
import 'package:fproject/DashBoard/notification.dart';
import 'package:fproject/Profile/profile.dart';
import 'package:fproject/Team/profileView.dart';
import 'package:fproject/Team/teammain.dart';
import 'package:fproject/Video/components/Videomain.dart';
import 'package:fproject/Forum/Forummain.dart';
import 'package:fproject/paytm/PaymentScreen.dart';
import 'package:fproject/project/projectMain.dart';
import 'package:fproject/selector/selectormain.dart';
import 'package:fproject/setting/setting.dart';
import 'package:fproject/todo/todomain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'Auth/Signup/Signup.dart';
import 'Auth/forgetpassword/forgetmain.dart';
import 'Auth/login/login.dart';
import 'DashBoard/dashboard.dart';
import 'DashBoard/splash_screen.dart';
import 'File/Filemain.dart';
import 'diary/diarymain.dart';
import 'notes/notemain.dart';

Future<String> getTokenPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");
  return token;
}

Future<CurrentUserPref> getUserPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final finaldata = CurrentUserPref(
      id: prefs.getInt('id'),
      email: prefs.getString('email'),
      teamName: prefs.getString('teamName'),
      username: prefs.getString('username'),
      totalStorage: prefs.getInt('totalStorage'),
      price: prefs.getDouble('price'),
      type: prefs.getString('type'),
      projectCount: prefs.getInt('projectCount'),
      cloudStorage: prefs.getInt('cloudStorage'),
      noOfProject: prefs.getInt('noOfProject'),
      userImage: prefs.getString('userImage'),
      txnDate: prefs.getString('txnDate'),
      duration: prefs.getString('duration'),
      noOfMember: prefs.getInt('noOfMember'),
      selected: prefs.getBool('selected'));
  return finaldata;
}

final MyRoute = {
  '/splash': (context) => SplashScreen(),
  '/signup': (context) => SignUp(),
  '/todo': (context) => Todo(),
  '/notes': (context) => NoteMain(),
  '/login': (context) => Login(),
  '/forget': (context) => ForgetMain(),
  '/diarys': (context) => DiaryMain(),
  '/album': (context) => AlbumMain(),
  '/file': (context) => FileMain(),
  '/video': (context) => VideoMain(),
  '/team': (context) => TeamMain(),
  '/profile': (context) => ProfileView(),
  '/user': (context) => User(),
  '/forum': (context) => Forum(),
  '/project': (context) => ProjectMain(),
  '/paytm': (context) => PaymentScreen(),
  "/dashboard": (context) => MenuDashboardPage(),
  "/setting": (context) => Setting(),
  '/invite': (context) => Invites(),
  '/message': (context) => Messages(),
  '/notification': (context) => Notify(),
  '/selector': (context) => SelectorMain()
};

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

final filterImageList = ['jpg', 'jpeg', 'png'];
final filterFileList = ['pdf', 'docx'];
final filterVideoList = ['mp4', 'mkv'];

DateTime currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "Tap back again to leave",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    return Future.value(false);
  }
  return Future.value(true);
}
