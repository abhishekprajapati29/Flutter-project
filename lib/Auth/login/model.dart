class LoginModel {
  CurrentUser user;
  String token;

  LoginModel({this.user, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new CurrentUser.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class CurrentUser {
  int id;
  String username;
  String email;
  Profiles profile;
  Images image;

  CurrentUser({this.id, this.username, this.email, this.profile, this.image});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profile =
        json['profile'] != null ? new Profiles.fromJson(json['profile']) : null;
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }
}

class Profiles {
  int id;
  String user;
  String location;
  String teamName;
  String teamImage;
  String backgroundImage;
  String email;
  int phoneNumber;
  String designation;
  String aboutMe;
  String gender;
  String address;
  String occupation;
  String skills;
  String jobs;
  bool selected;

  Profiles(
      {this.id,
      this.user,
      this.location,
      this.teamName,
      this.teamImage,
      this.backgroundImage,
      this.email,
      this.phoneNumber,
      this.designation,
      this.aboutMe,
      this.gender,
      this.address,
      this.occupation,
      this.skills,
      this.jobs,
      this.selected});

  Profiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    location = json['location'];
    teamName = json['teamName'];
    teamImage = json['team_image'];
    backgroundImage = json['background_image'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    designation = json['designation'];
    aboutMe = json['about_me'];
    gender = json['gender'];
    address = json['address'];
    occupation = json['occupation'];
    skills = json['skills'];
    jobs = json['jobs'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['location'] = this.location;
    data['teamName'] = this.teamName;
    data['team_image'] = this.teamImage;
    data['background_image'] = this.backgroundImage;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['designation'] = this.designation;
    data['about_me'] = this.aboutMe;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['occupation'] = this.occupation;
    data['skills'] = this.skills;
    data['jobs'] = this.jobs;
    data['selected'] = this.selected;
    return data;
  }
}

class Images {
  int id;
  String user;
  String image;

  Images({this.id, this.user, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['image'] = this.image;
    return data;
  }
}

class CurrentUserPref {
  int id;
  String username;
  String email;
  String teamName;
  int totalStorage;
  double price;
  String type;
  int projectCount;
  int cloudStorage;
  int noOfProject;
  String userImage;
  bool selected;
  String txnDate;
  String duration;
  int noOfMember;

  CurrentUserPref(
      {this.id,
      this.username,
      this.email,
      this.teamName,
      this.totalStorage,
      this.price,
      this.projectCount,
      this.cloudStorage,
      this.userImage,
      this.selected,
      this.noOfProject,
      this.txnDate,
      this.noOfMember,
      this.duration,
      this.type});

  CurrentUserPref.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    teamName = json['teamName'];
    totalStorage = json['totalStorage'];
    price = json['price'];
    type = json['type'];
    projectCount = json['projectCount'];
    cloudStorage = json['cloudStorage'];
    noOfProject = json['noOfProject'];
    userImage = json['userImage'];
    selected = json['selected'];
    txnDate = json['txnDate'];
    duration = json['duration'];
    noOfMember = json['noOfMember'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['teamName'] = this.teamName;
    data['totalStorage'] = this.totalStorage;
    data['price'] = this.price;
    data['type'] = this.type;
    data['projectCount'] = this.projectCount;
    data['cloudStorage'] = this.cloudStorage;
    data['noOfProject'] = this.noOfProject;
    data['userImage'] = this.userImage;
    data['selected'] = this.selected;
    data['txnDate'] = this.txnDate;
    data['duration'] = this.duration;
    data['noOfMember'] = this.noOfMember;

    return data;
  }
}
