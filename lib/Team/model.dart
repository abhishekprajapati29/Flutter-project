class UserModel {
  int id;
  String username;
  String email;
  Profile profile;
  Image image;

  UserModel({this.id, this.username, this.email, this.profile, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
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

class Profile {
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

  Profile(
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

  Profile.fromJson(Map<String, dynamic> json) {
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

class Image {
  int id;
  String user;
  String image;

  Image({this.id, this.user, this.image});

  Image.fromJson(Map<String, dynamic> json) {
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

class SubModel {
  int id;
  String username;
  String status;
  String orderId;
  String amount;
  String bankName;
  String transactionId;
  String txnDate;

  SubModel(
      {this.id,
      this.username,
      this.status,
      this.orderId,
      this.amount,
      this.bankName,
      this.transactionId,
      this.txnDate});

  SubModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    status = json['status'];
    orderId = json['order_id'];
    amount = json['amount'];
    bankName = json['bank_name'];
    transactionId = json['transaction_id'];
    txnDate = json['txn_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['bank_name'] = this.bankName;
    data['transaction_id'] = this.transactionId;
    data['txn_date'] = this.txnDate;
    return data;
  }
}

class AllPlanModel {
  double price;
  String type;
  String time;
  int noTeam;
  int noOfTeamMember;
  int noOfProjects;
  int noOfProjectMembers;
  String cloudStorage;
  int cloudStorageValue;

  AllPlanModel(
      {this.price,
      this.type,
      this.time,
      this.noTeam,
      this.noOfTeamMember,
      this.noOfProjects,
      this.noOfProjectMembers,
      this.cloudStorage,
      this.cloudStorageValue});

  AllPlanModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    type = json['type'];
    time = json['time'];
    noTeam = json['No_team'];
    noOfTeamMember = json['No_of_team_member'];
    noOfProjects = json['No_of_Projects'];
    noOfProjectMembers = json['No_of_project_members'];
    cloudStorage = json['cloud_storage'];
    cloudStorageValue = json['cloud_storage_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['type'] = this.type;
    data['time'] = this.time;
    data['No_team'] = this.noTeam;
    data['No_of_team_member'] = this.noOfTeamMember;
    data['No_of_Projects'] = this.noOfProjects;
    data['No_of_project_members'] = this.noOfProjectMembers;
    data['cloud_storage'] = this.cloudStorage;
    data['cloud_storage_value'] = this.cloudStorageValue;
    return data;
  }
}

class InoviceModel {
  int id;
  int user;
  String invoice;
  int requestedBy;

  InoviceModel({this.id, this.user, this.invoice, this.requestedBy});

  InoviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    invoice = json['invoice'];
    requestedBy = json['requested_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['invoice'] = this.invoice;
    data['requested_by'] = this.requestedBy;
    return data;
  }
}
