import 'dart:convert';

import 'package:fproject/Team/model.dart';
import 'package:fproject/Team/plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'package:http/http.dart' as http;

Future<NotificationModel> getPrivicy(
    String token, bool post, bool images, bool info) async {
  NotificationModel finaldata;
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/api/auth/user'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    final data = json.decode(value.body);
    print(data);
    print(data['id']);
    await http.get(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/user_allow/?user=${data['id'].toString()}'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value2) async {
      final data2 = jsonDecode(value2.body);
      final int count = data2.length;

      print(count);
      if (count > 0) {
        final data4 = data2[0];
        finaldata = NotificationModel(
            id: data4['id'],
            user: data4['user'],
            images: data4['images'],
            info: data4['info'],
            post: data4['post']);
      } else {
        await http.post(
            Uri.encodeFull(
                'http://abhishekpraja.pythonanywhere.com/user_allow/'),
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + token,
            }).then((val) {
          final valData = jsonDecode(val.body);
          finaldata = NotificationModel(
              id: valData['id'],
              user: valData['user'],
              images: valData['images'],
              info: valData['info'],
              post: valData['post']);
        });
      }
    });
  });
  return finaldata;
}

Future<NotificationModel> getData(
    String token, bool post, bool images, bool info) async {
  NotificationModel finaldata;
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/api/auth/user'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    final data = json.decode(value.body);
    await http.get(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/user_allow/?user=' +
                data['id'].toString()),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value2) async {
      final data2 = jsonDecode(value2.body);
      final int count = data2.length;
      final data4 = data2[0];
      if (count > 0) {
        await http.patch(
            Uri.encodeFull(
                'http://abhishekpraja.pythonanywhere.com/user_allow/${data4["id"].toString()}/'),
            body: {
              'post': post == true ? "true" : 'false',
              'images': images == true ? "true" : 'false',
              'info': info == true ? "true" : 'false',
            },
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + token,
            }).then((value2) {
          final jsonData = jsonDecode(value2.body);
          finaldata = NotificationModel(
              id: jsonData['id'],
              user: jsonData['user'],
              images: jsonData['images'],
              info: jsonData['info'],
              post: jsonData['post']);
        });
      } else {
        await http.post(
            Uri.encodeFull(
                'http://abhishekpraja.pythonanywhere.com/user_allow/'),
            body: {
              'user': data['username'],
              'post': post == true ? "true" : 'false',
              'images': images == true ? "true" : 'false',
              'info': info == true ? "true" : 'false',
            },
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + token,
            }).then((value2) {
          final jsonData = jsonDecode(value2.body);
          finaldata = NotificationModel(
              id: jsonData['id'],
              user: jsonData['user'],
              images: jsonData['images'],
              info: jsonData['info'],
              post: jsonData['post']);
        });
      }
    });
  });
  return finaldata;
}

Future<AllPlanModel> getCurrentPlan(String token) async {
  AllPlanModel finaldata;
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/api/auth/user'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    final data = json.decode(value.body);
    await http.get(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/Subs/?username=${data['username']}'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value1) async {
      final data1 = json.decode(value1.body);
      final data2 = data1[0];
      for (var item in Plan_detail) {
        finaldata = AllPlanModel(
            price: item['price'],
            type: item['type'],
            time: item['time'],
            cloudStorage: item['cloud_storage'],
            cloudStorageValue: item['cloud_storage_value'],
            noOfProjectMembers: item['No_of_project_members'],
            noOfProjects: item['No_of_Projects'],
            noOfTeamMember: item['No_of_team_member'],
            noTeam: item['No_team']);
        if (double.parse(finaldata.price.toString()) ==
            double.parse(data2['amount'])) {
          break;
        }
      }
    });
  });
  return finaldata;
}

Future<AllPlanModel> cancelSubs(String token, String username) async {
  AllPlanModel finaldata;
  await http.get(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/Subs/?username=$username'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    final data = json.decode(value.body)[0];
    final id = data['id'];
    await http.patch(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/Subs/${id.toString()}/'),
        body: {
          'order_id': data['id'].toString(),
          'amount': '0',
          "bank_name": "Free",
          "transaction_id": data['id'].toString(),
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value1) async {
      final data1 = json.decode(value1.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('price', 0.0);
      prefs.setString('type', 'Free');
      prefs.setInt('cloudStorage', 209715200);
      prefs.setInt('noOfProject', 1);
      prefs.setInt('noOfMember', 2);
      prefs.setBool('selected', true);
      finaldata = AllPlanModel(
          price: 0.0,
          type: 'Free',
          time: 'Month',
          cloudStorage: "200 MB",
          cloudStorageValue: 209715200,
          noOfProjectMembers: 2,
          noOfProjects: 1,
          noOfTeamMember: 3,
          noTeam: 1);
    });
  });
  return finaldata;
}

Future<void> updatePassword(String token, String pass) async {
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/api/auth/user'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value1) async {
    final data = json.decode(value1.body);
    await http.patch(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/userprofileUpdate/${data['id']}/'),
        body: {
          'password': pass
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).catchError((error) => print(error));
  });
}

Future<void> postContactUs(String token, String subject, String message) async {
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/api/auth/user'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value1) async {
    final data1 = json.decode(value1.body);
    await http.post(
        Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/contact_us/'),
        body: {
          'user': data1['id'].toString(),
          'email': data1['email'],
          'username': data1['username'],
          'subject': subject,
          'message': message,
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value2) {
      // await http.post(
      //     Uri.encodeFull('https://contact-us-mail.herokuapp.com/api/form'),
      //     body: {
      //       'user': data1['id'].toString(),
      //       'email': data1['email'],
      //       'username': data1['username'],
      //       'subject': subject,
      //       'message': message,
      //     },
      //     headers: {
      //       "Accept": 'application/json',
      //       "Authorization": 'Token ' + token,
      //     });
    });
  });
}
