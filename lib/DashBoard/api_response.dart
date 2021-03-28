import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/Team/model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../gettoken.dart';

Future<int> getTotalStorage(String token) async {
  int finaldata = 0;
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/video/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    if (value.statusCode == 200) {
      final jsonVideodata = json.decode(value.body);
      for (var item in jsonVideodata) {
        if (item['size'] != null && item['selected'] == true) {
          finaldata = finaldata + item['size'];
        }
      }
      await http.get(
          Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/file/'),
          headers: {
            "Accept": 'application/json',
            "Authorization": 'Token ' + token,
          }).then((value) async {
        if (value.statusCode == 200) {
          final jsonVideodata = json.decode(value.body);
          for (var item in jsonVideodata) {
            if (item['size'] != null && item['selected'] == true) {
              finaldata = finaldata + item['size'];
            }
          }
          await http.get(
              Uri.encodeFull(
                  'https://abhishekpraja.pythonanywhere.com/images/'),
              headers: {
                "Accept": 'application/json',
                "Authorization": 'Token ' + token,
              }).then((value) async {
            if (value.statusCode == 200) {
              final jsonVideodata = json.decode(value.body);
              for (var item in jsonVideodata) {
                if (item['imagelistsize'] != null && item['selected'] == true) {
                  finaldata = finaldata + item['imagelistsize'];
                }
              }
            }
          });
        }
      });
    }
  });
  return finaldata;
}

Future<List<PostModel>> getPosts(String token) async {
  final finaldata = <PostModel>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/postALL/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    if (value.statusCode == 200) {
      final jsonPostdata = json.decode(value.body);
      for (var item in jsonPostdata) {
        final comments = <PostComment>[];
        for (var comment in item['post_comment']) {
          final data = PostComment(
              id: comment['id'],
              user: comment['user'],
              commentedBy: comment['commented_by'],
              commentContent: comment['comment_content'],
              commentTimestamp: comment['comment_timestamp']);
          comments.add(data);
        }
        final data = PostModel(
            commentCount: item['comment_count'],
            content: item['content'],
            id: item['id'],
            img: item['img'],
            postedId: item['posted_id'],
            timestamp: item['timestamp'],
            user: item['user'],
            postComment: comments);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<PostModel> sendComment(
    String token, String content, int id, PostModel post) async {
  PostModel finaldata;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username');
  await http.post(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/postcomment/'),
      body: {
        'comment_content': content,
        'commented_by': username,
        'user': id.toString()
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) async {
    if (value.statusCode == 201) {
      final jsonData = jsonDecode(value.body);
      final comments = <PostComment>[];
      final data = PostComment(
          commentContent: jsonData['comment_content'],
          commentedBy: jsonData['commented_by'],
          commentTimestamp: jsonData['comment_timestamp'],
          id: jsonData['id'],
          user: jsonData['user']);
      comments.add(data);
      for (var item in post.postComment) {
        final data = PostComment(
            commentContent: item.commentContent,
            commentedBy: item.commentedBy,
            commentTimestamp: item.commentTimestamp,
            id: item.id,
            user: item.user);
        comments.add(data);
      }
      finaldata = PostModel(
          commentCount: post.commentCount + 1,
          content: post.content,
          id: post.id,
          img: post.img,
          postedId: post.postedId,
          timestamp: post.timestamp,
          user: post.user,
          postComment: comments);
    }
  });
  return finaldata;
}

Future<int> deleteComment(String token, int id) async {
  await http.delete(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/post/${id.toString()}/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
  return id;
}

Future<PostModel> createAddPost(
    String token, data, Function loadingChange) async {
  SharedPreferences getdata = await SharedPreferences.getInstance();
  String username = getdata.getString('username');
  loadingChange();
  PostModel finaldata;
  print(data['name']);
  print(data['filename']);
  print(data['filepath']);
  var dio = new Dio();
  dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
  FormData formData;
  if (data['filename'] != null && data['name'] == null) {
    formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
      "posted_id": data['name'],
      "user": username
    });
  } else if (data['filename'] == null && data['name'] != null) {
    formData = FormData.fromMap(
        {"content": data['name'], "posted_id": data['name'], "user": username});
  } else {
    formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
      "content": data['name'],
      "posted_id": data['name'],
      "user": username
    });
  }
  await dio
      .post(
    "http://abhishekpraja.pythonanywhere.com/post/",
    data: formData,
  )
      .then((value) async {
    final json = value.data;
    finaldata = PostModel(
      id: json['id'],
      user: json['user'],
      postedId: json['posted_id'],
      img: json['img'],
      content: json['content'],
      timestamp: json['timestamp'],
      postComment: [],
      commentCount: 0,
    );
  }).catchError((error) => print(error.response.toString()));
  loadingChange();
  return finaldata;
}

Future<void> logout(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await http.post(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/api/auth/logout'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    prefs.remove('id');
    prefs.remove('email');
    prefs.remove('teamName');
    prefs.remove('username');
    prefs.remove('totalStorage');
    prefs.getDouble('price');
    prefs.remove('type');
    prefs.remove('projectCount');
    prefs.remove('cloudStorage');
    prefs.remove('noOfProject');
    prefs.remove('userImage');
  });
}

Future<List<MessageModelDrawer>> getAllMessages(String token) async {
  var finaldata = <MessageModelDrawer>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/user_message/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var item in jsonData) {
        final data = MessageModelDrawer(
            id: item['id'],
            message: item['message'],
            messageBy: item['message_by'],
            timestamp: item['timestamp'],
            user: item['user']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<List<NotificationModelDrawer>> getAllNotification(String token) async {
  var finaldata = <NotificationModelDrawer>[];
  await http.get(
      Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/notification/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var item in jsonData) {
        final data = NotificationModelDrawer(
            id: item['id'],
            content: item['content'],
            postedBy: item['posted_by'],
            timestamp: item['timestamp'],
            user: item['user']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<List<InviteModelDrawer>> getAllInvites(String token) async {
  var finaldata = <InviteModelDrawer>[];
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/list-project-invoice/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var item in jsonData) {
        final data = InviteModelDrawer(
            id: item['id'],
            requestedBy: item['requested_by'],
            invoice: item['invoice'],
            user: item['user']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<List<ProjectInvoice>> getAllProjectInvites(String token) async {
  var finaldata = <ProjectInvoice>[];
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/list-project-invoice/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var json in jsonData) {
        final data = ProjectInvoice(
            id: json['id'],
            requestedBy: json['requested_by'],
            invoice: json['invoice'],
            message: json['message'],
            projectNameToJoin: json['project_name_to_join'],
            projectNumber: json['project_number'],
            timestamp: json['timestamp'],
            user: json['user']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<SubModel> updateSubsPlan(String token, String username) async {
  SubModel finaldata;
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/Subs/?username=$username'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value1) async {
    final json = jsonDecode(value1.body)[0];
    await http.patch(
        Uri.encodeFull('https://abhishekpraja.pythonanywhere.com/Subs/' +
            json['id'].toString() +
            '/'),
        body: {
          'amount': '0',
          'bank_name': 'Free',
          'transaction_id': 'Free',
          'order_id': 'Free',
          'txn_date': DateTime.now().toString()
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) async {
      if (value.statusCode == 200) {
        final finalJson = jsonDecode(value.body);
        finaldata = SubModel(
          id: finalJson['id'],
          username: finalJson['username'],
          status: finalJson['status'],
          orderId: finalJson['order_id'],
          amount: finalJson['amount'],
          bankName: finalJson['bank_name'],
          transactionId: finalJson['transaction_id'],
          txnDate: finalJson['txn_date'],
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('price', finalJson['amount']);
        prefs.setString('type', 'Free');
        prefs.setInt('cloudStorage', 209715200);
        prefs.setInt('noOfProject', 1);
        prefs.setString('txnDate', DateTime.now().toString());
        prefs.setString('duration', 'Free');
      }
    });
  });
  return finaldata;
}

Future<void> updateSelectorOn(String token) async {
  await getUserPreferences().then((value) async {
    await http.patch(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/userprofile/${value.id.toString()}/'),
        body: {
          'selected': 'true'
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) async {
      final jsonData = jsonDecode(value.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('selected', jsonData['selected']);
    });
  });
}

Future<int> deleteInvite(String token, int id) async {
  await http.delete(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/list-project-invoice/${id.toString()}/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      });
  return id;
}

Future<void> joinTeam(ProjectInvoice invoice, String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/project-member/';
  await http.post(Uri.encodeFull(url), body: {
    'member': invoice.requestedBy,
    'selected': 'true',
    'project_id': invoice.projectNumber.toString(),
  }, headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) {
    deleteInvite(token, invoice.id);
  });
}
