import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fproject/Team/model.dart';

import '../../gettoken.dart';
import 'models.dart';

Future<List<UserModel>> getAllUsersData(String token) async {
  var finaldata = <UserModel>[];
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
          final userdata = UserModel(
              id: item['id'],
              username: item['username'],
              email: item['email'],
              profile: Profile(
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
              image: Image(
                  id: item['image']['id'],
                  user: item['image']['user'],
                  image: item['image']['image']));
          finaldata.add(userdata);
        }
      }
    }
  });
  return finaldata;
}

Future<List<MessageModel>> getAllMessageData(
    String token, String teamName) async {
  var finaldata = <MessageModel>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/comment/'),
      headers: {
        "Content-Type": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final finalJson = jsonDecode(utf8.decode(value.bodyBytes));
      print('yes');
      for (var item in finalJson) {
        if (item['teamName'] == teamName) {
          if (item['id'] == 24) {
            print(item['message']);
          }
          final userdata = MessageModel(
              id: item['id'],
              message: item['message'],
              teamName: item['teamName'],
              timestamp: item['timestamp'],
              user: item['user']);
          finaldata.add(userdata);
        }
      }
    }
  });
  return finaldata;
}

Future<void> sendMessageData(
    String text,
    String token,
    String teamName,
    Function updateMessage,
    Function updateMessage1,
    Function updateTextMessage) async {
  MessageModel finaldata;
  final String message = text;
  updateTextMessage();
  await getTokenPreferences().then((value) async {
    await http.post(
        Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/comment/'),
        body: {
          'teamName': teamName,
          'message': message
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + value
        }).then((value1) {
      if (value1.statusCode == 201) {
        final item = jsonDecode(utf8.decode(value1.bodyBytes));
        finaldata = MessageModel(
            id: item['id'],
            message: item['message'],
            teamName: item['teamName'],
            timestamp: item['timestamp'],
            user: item['user']);
        updateMessage(finaldata);
        updateMessage1(finaldata);
      }
    });
  });
}
