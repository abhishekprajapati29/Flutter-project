class VideoModel {
  int id;
  String user;
  String title;
  String video;
  String type;
  int size;
  bool selected;
  bool favourite;
  String timestamp;

  VideoModel(
      {this.id,
      this.user,
      this.title,
      this.video,
      this.type,
      this.size,
      this.selected,
      this.favourite,
      this.timestamp});

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    video = json['Video'];
    type = json['type'];
    size = json['size'];
    selected = json['selected'];
    favourite = json['favourite'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['title'] = this.title;
    data['Video'] = this.video;
    data['type'] = this.type;
    data['size'] = this.size;
    data['selected'] = this.selected;
    data['favourite'] = this.favourite;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
