import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/Team/model.dart' as team;
import 'package:http/http.dart' as http;

Future<team.UserModel> getCurrentUser(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/api/auth/user';
  team.UserModel finaldata;
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) async {
    if (value.statusCode == 200) {
      final item = jsonDecode(value.body);
      finaldata = team.UserModel(
          id: item['id'],
          username: item['username'],
          email: item['email'],
          profile: team.Profile(
            id: item['profile']['id'],
            user: item['profile']['user'],
            location: item['profile']['location'],
            teamName: item['profile']['teamName'],
            teamImage: item['profile']['team_image'],
            backgroundImage: item['profile']['background_image'],
            email: item['profile']['email'],
            phoneNumber: item['profile']['phone_number'],
            designation: item['profile']['designation'],
            aboutMe: item['profile']['about_me'],
            gender: item['profile']['gender'],
            occupation: item['profile']['occupation'],
            skills: item['profile']['skills'],
            jobs: item['profile']['jobs'],
            selected: item['profile']['selected'],
          ),
          image: team.Image(
              id: item['image']['id'],
              user: item['image']['user'],
              image: item['image']['image']));
    }
  });
  return finaldata;
}

Future<List<team.UserModel>> getData(
    String token, team.UserModel data, String teamName) async {
  print(teamName);
  final finaldata = <team.UserModel>[];

  if (data.profile.teamName != 'default_team_name') {
    await http.get(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/userprofileList/?profile__teamName=${data.profile.teamName}'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) {
      if (value.statusCode == 200) {
        final finalJson = jsonDecode(value.body);
        print('yes');
        for (var item in finalJson) {
          final userdata = team.UserModel(
              id: item['id'],
              username: item['username'],
              email: item['email'],
              profile: team.Profile(
                id: item['profile']['id'],
                user: item['profile']['user'],
                location: item['profile']['location'],
                teamName: item['profile']['teamName'],
                teamImage: item['profile']['team_image'],
                backgroundImage: item['profile']['background_image'],
                email: item['profile']['email'],
                phoneNumber: item['profile']['phone_number'],
                designation: item['profile']['designation'],
                aboutMe: item['profile']['about_me'],
                gender: item['profile']['gender'],
                occupation: item['profile']['occupation'],
                skills: item['profile']['skills'],
                jobs: item['profile']['jobs'],
                selected: item['profile']['selected'],
              ),
              image: team.Image(
                  id: item['image']['id'],
                  user: item['image']['user'],
                  image: item['image']['image']));
          finaldata.add(userdata);
        }
      }
    });
  } else {
    print('no');
    await http.get(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/userprofileList/'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) {
      if (value.statusCode == 200) {
        final finalJson = jsonDecode(value.body);
        print('yes');
        for (var item in finalJson) {
          if (item['profile']['teamName'] != 'default_team_name') {
            final userdata = team.UserModel(
                id: item['id'],
                username: item['username'],
                email: item['email'],
                profile: team.Profile(
                  id: item['profile']['id'],
                  user: item['profile']['user'],
                  location: item['profile']['location'],
                  teamName: item['profile']['teamName'],
                  teamImage: item['profile']['team_image'],
                  backgroundImage: item['profile']['background_image'],
                  email: item['profile']['email'],
                  phoneNumber: item['profile']['phone_number'],
                  designation: item['profile']['designation'],
                  aboutMe: item['profile']['about_me'],
                  gender: item['profile']['gender'],
                  occupation: item['profile']['occupation'],
                  skills: item['profile']['skills'],
                  jobs: item['profile']['jobs'],
                  selected: item['profile']['selected'],
                ),
                image: team.Image(
                    id: item['image']['id'],
                    user: item['image']['user'],
                    image: item['image']['image']));
            finaldata.add(userdata);
          }
        }
      }
    });
  }
  return finaldata;
}

Future<team.SubModel> getPlan(String token, String username) async {
  team.SubModel finaldata;
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/Subs/?username=$username'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final finalJson = jsonDecode(value.body)[0];
      finaldata = team.SubModel(
        id: finalJson['id'],
        username: finalJson['username'],
        status: finalJson['status'],
        orderId: finalJson['order_id'],
        amount: finalJson['amount'],
        bankName: finalJson['bank_name'],
        transactionId: finalJson['transaction_id'],
        txnDate: finalJson['txn_date'],
      );
    }
  });
  return finaldata;
}

Future<List<team.UserModel>> getDefaultMember(String token) async {
  var finaldata = <team.UserModel>[];
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/userprofileList/?profile__teamName=default_team_name'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final finalJson = jsonDecode(value.body);
      print('yes');
      for (var item in finalJson) {
        final userdata = team.UserModel(
            id: item['id'],
            username: item['username'],
            email: item['email'],
            profile: team.Profile(
              id: item['profile']['id'],
              user: item['profile']['user'],
              location: item['profile']['location'],
              teamName: item['profile']['teamName'],
              teamImage: item['profile']['team_image'],
              backgroundImage: item['profile']['background_image'],
              email: item['profile']['email'],
              phoneNumber: item['profile']['phone_number'],
              designation: item['profile']['designation'],
              aboutMe: item['profile']['about_me'],
              gender: item['profile']['gender'],
              occupation: item['profile']['occupation'],
              skills: item['profile']['skills'],
              jobs: item['profile']['jobs'],
              selected: item['profile']['selected'],
            ),
            image: team.Image(
                id: item['image']['id'],
                user: item['image']['user'],
                image: item['image']['image']));
        finaldata.add(userdata);
      }
    }
  });
  return finaldata;
}

Future<List<team.UserModel>> getAllUsersData(String token) async {
  var finaldata = <team.UserModel>[];
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/userprofileList/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final finalJson = jsonDecode(value.body);
      print('yes');
      for (var item in finalJson) {
        final userdata = team.UserModel(
            id: item['id'],
            username: item['username'],
            email: item['email'],
            profile: team.Profile(
              id: item['profile']['id'],
              user: item['profile']['user'],
              location: item['profile']['location'],
              teamName: item['profile']['teamName'],
              teamImage: item['profile']['team_image'],
              backgroundImage: item['profile']['background_image'],
              email: item['profile']['email'],
              phoneNumber: item['profile']['phone_number'],
              designation: item['profile']['designation'],
              aboutMe: item['profile']['about_me'],
              gender: item['profile']['gender'],
              occupation: item['profile']['occupation'],
              skills: item['profile']['skills'],
              jobs: item['profile']['jobs'],
              selected: item['profile']['selected'],
            ),
            image: team.Image(
                id: item['image']['id'],
                user: item['image']['user'],
                image: item['image']['image']));
        finaldata.add(userdata);
      }
    }
  });
  return finaldata;
}

Future<List<Imagelist>> getUserImages(String token) async {
  var finaldata = <Imagelist>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/imagelist/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      for (var item in jsonDecode(value.body)) {
        final data = Imagelist(
            id: item['id'],
            user: item['user'],
            albumId: item['album_id'],
            src: item['src'],
            thumbnail: item['thumbnail'],
            thumbnailWidth: item['thumbnailWidth'],
            thumbnailHeight: item['thumbnailHeight'],
            caption: item['caption'],
            selected: item['selected'],
            size: item['size'],
            favourite: item['favourite']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<List<Imagelist>> getUserImages1(String token, String username) async {
  var finaldata = <Imagelist>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/imagelistall/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      for (var item in jsonDecode(value.body)) {
        if (item['user'] == username) {
          final data = Imagelist(
              id: item['id'],
              user: item['user'],
              albumId: item['album_id'],
              src: item['src'],
              thumbnail: item['thumbnail'],
              thumbnailWidth: item['thumbnailWidth'],
              thumbnailHeight: item['thumbnailHeight'],
              caption: item['caption'],
              selected: item['selected'],
              size: item['size'],
              favourite: item['favourite']);
          finaldata.add(data);
        }
      }
    }
  });
  return finaldata;
}

Future<team.InoviceModel> addMemberInvoice(
    team.UserModel data, team.UserModel currentUser) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/invoice/';
  team.InoviceModel finaldata;
  await http.post(Uri.encodeFull(url), body: {
    'user': data.id.toString(),
    'invoice':
        "${currentUser.username} want you to join his/her Team ( ${currentUser.profile.teamName} )",
    'requested_by': currentUser.id.toString()
  }, headers: {
    "Accept": 'application/json',
  }).then((value) async {
    if (value.statusCode == 201) {
      final item = jsonDecode(value.body);
      finaldata = team.InoviceModel(
          id: item['id'],
          user: item['user'],
          invoice: item['invoice'],
          requestedBy: item['requested_by']);
    }
  });
  return finaldata;
}

Future<team.InoviceModel> addMemberInvoice1(
    team.UserModel data, team.UserModel currentUser) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/invoice/';
  team.InoviceModel finaldata;
  await http.post(Uri.encodeFull(url), body: {
    'user': data.id.toString(),
    'invoice':
        "${currentUser.username} Request to join your Team ( ${data.profile.teamName} )",
    'requested_by': currentUser.id.toString()
  }, headers: {
    "Accept": 'application/json',
  }).then((value) async {
    if (value.statusCode == 201) {
      final item = jsonDecode(value.body);
      finaldata = team.InoviceModel(
          id: item['id'],
          user: item['user'],
          invoice: item['invoice'],
          requestedBy: item['requested_by']);
    }
  });
  return finaldata;
}

Future<List<team.InoviceModel>> getInvoice() async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/invoice/';
  var finaldata = <team.InoviceModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
  }).then((value) async {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var item in jsonData) {
        final data = team.InoviceModel(
            id: item['id'],
            user: item['user'],
            invoice: item['invoice'],
            requestedBy: item['requested_by']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<team.UserModel> getInvoiceUserData(String token, int id) async {
  final String url =
      'http://abhishekpraja.pythonanywhere.com/userprofileList/' +
          id.toString() +
          '/';
  team.UserModel finaldata;
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) async {
    if (value.statusCode == 200) {
      final item = jsonDecode(value.body);
      finaldata = team.UserModel(
          id: item['id'],
          username: item['username'],
          email: item['email'],
          profile: team.Profile(
            id: item['profile']['id'],
            user: item['profile']['user'],
            location: item['profile']['location'],
            teamName: item['profile']['teamName'],
            teamImage: item['profile']['team_image'],
            backgroundImage: item['profile']['background_image'],
            email: item['profile']['email'],
            phoneNumber: item['profile']['phone_number'],
            designation: item['profile']['designation'],
            aboutMe: item['profile']['about_me'],
            gender: item['profile']['gender'],
            occupation: item['profile']['occupation'],
            skills: item['profile']['skills'],
            jobs: item['profile']['jobs'],
            selected: item['profile']['selected'],
          ),
          image: team.Image(
              id: item['image']['id'],
              user: item['image']['user'],
              image: item['image']['image']));
    }
  });
  return finaldata;
}

Future<void> acceptInvite(String token, team.UserModel data,
    team.InoviceModel invoice, String teamName) async {
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/userprofile/' +
          data.profile.id.toString() +
          '/'),
      body: {
        'teamName': teamName
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value2) async {
    await http.delete(
        Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/invoice/' +
            invoice.id.toString() +
            '/'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        });
  });
}

Future<void> acceptInvite1(
    String token, team.UserModel data, team.InoviceModel invoice) async {
  await http.get(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/addUserList/' +
          invoice.user.toString() +
          '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      final teamName = jsonData['profile']['teamName'];
      print(teamName);
      await http.get(
          Uri.encodeFull(
              'http://abhishekpraja.pythonanywhere.com/addUserList/' +
                  invoice.requestedBy.toString() +
                  '/'),
          headers: {
            "Accept": 'application/json',
            "Authorization": 'Token ' + token,
          }).then((value) async {
        if (value.statusCode == 200) {
          final data = jsonDecode(value.body);
          final id = data['profile']['id'];
          await http.put(
              Uri.encodeFull(
                  'http://abhishekpraja.pythonanywhere.com/addUserListteam/' +
                      id.toString() +
                      '/'),
              body: {
                'teamName': teamName
              },
              headers: {
                "Accept": 'application/json',
                "Authorization": 'Token ' + token,
              }).then((value2) async {
            await http.delete(
                Uri.encodeFull(
                    'http://abhishekpraja.pythonanywhere.com/invoice/' +
                        invoice.id.toString() +
                        '/'),
                headers: {
                  "Accept": 'application/json',
                  "Authorization": 'Token ' + token,
                });
          });
        }
      });
    }
  });
}

Future<void> leaveTeam(team.UserModel data) async {
  final String url =
      'http://abhishekpraja.pythonanywhere.com/addUserListteam/' +
          data.profile.id.toString() +
          '/';
  await http.put(Uri.encodeFull(url), body: {
    'teamName': 'default_team_name'
  }, headers: {
    "Accept": 'application/json',
  });
}
