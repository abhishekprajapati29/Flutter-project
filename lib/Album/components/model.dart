class AlbumModel {
  int id;
  String user;
  String title;
  String timestamp;
  String image;
  List<Imagelist> imagelist;
  bool favourite;
  int imagelistsize;
  bool selected;

  AlbumModel(
      {this.id,
      this.user,
      this.title,
      this.timestamp,
      this.image,
      this.imagelist,
      this.favourite,
      this.imagelistsize,
      this.selected});

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    timestamp = json['timestamp'];
    image = json['image'];
    if (json['imagelist'] != null) {
      imagelist = new List<Imagelist>();
      json['imagelist'].forEach((v) {
        imagelist.add(new Imagelist.fromJson(v));
      });
    }
    favourite = json['favourite'];
    imagelistsize = json['imagelistsize'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['title'] = this.title;
    data['timestamp'] = this.timestamp;
    data['image'] = this.image;
    if (this.imagelist != null) {
      data['imagelist'] = this.imagelist.map((v) => v.toJson()).toList();
    }
    data['favourite'] = this.favourite;
    data['imagelistsize'] = this.imagelistsize;
    data['selected'] = this.selected;
    return data;
  }
}

class Imagelist {
  int id;
  String user;
  int albumId;
  String src;
  String thumbnail;
  int thumbnailWidth;
  int thumbnailHeight;
  String caption;
  bool selected;
  int size;
  bool favourite;

  Imagelist(
      {this.id,
      this.user,
      this.albumId,
      this.src,
      this.thumbnail,
      this.thumbnailWidth,
      this.thumbnailHeight,
      this.caption,
      this.selected,
      this.size,
      this.favourite});

  Imagelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    albumId = json['album_id'];
    src = json['src'];
    thumbnail = json['thumbnail'];
    thumbnailWidth = json['thumbnailWidth'];
    thumbnailHeight = json['thumbnailHeight'];
    caption = json['caption'];
    selected = json['selected'];
    size = json['size'];
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['album_id'] = this.albumId;
    data['src'] = this.src;
    data['thumbnail'] = this.thumbnail;
    data['thumbnailWidth'] = this.thumbnailWidth;
    data['thumbnailHeight'] = this.thumbnailHeight;
    data['caption'] = this.caption;
    data['selected'] = this.selected;
    data['size'] = this.size;
    data['favourite'] = this.favourite;
    return data;
  }
}
