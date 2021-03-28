class NotificationModel {
  int id;
  String user;
  bool post;
  bool images;
  bool info;

  NotificationModel({this.id, this.user, this.post, this.images, this.info});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    post = json['post'];
    images = json['images'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['post'] = this.post;
    data['images'] = this.images;
    data['info'] = this.info;
    return data;
  }
}
