class LoginModel {
  bool? success;
  int? code;
  String? message;
  Data? data;
  Metadata? metadata;

  LoginModel({this.success, this.code, this.message, this.data, this.metadata});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    metadata = json['metadata'] != null ? new Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Data {
  String? socialId;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  int? dob;
  int? age;
  String? profileImage;
  String? password;
  String? randomKey;
  String? gender;
  String? userType;
  String? locale;
  String? hometown;
  String? token;
  String? deviceType;
  String? deviceToken;
  bool? isInterests;
  String? status;
  String? socialType;
  String? bio;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkdin;
  String? website;
  String? createdAt;
  String? updatedAt;
  String? fullName;
  int? iV;
  String? city;
  String? country;
  String? state;
  Community? community;
  String? socketId;
  String? id;

  Data({this.socialId, this.sId, this.firstName, this.lastName, this.email, this.dob, this.age, this.profileImage, this.password, this.randomKey, this.gender, this.userType, this.locale, this.hometown, this.token, this.deviceType, this.deviceToken, this.isInterests, this.status, this.socialType, this.bio, this.facebook, this.instagram, this.twitter, this.linkdin, this.website, this.createdAt, this.updatedAt, this.fullName, this.iV, this.city, this.country, this.state, this.community, this.socketId, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    socialId = json['social_id'];
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dob = json['dob'];
    age = json['age'];
    profileImage = json['profile_image'];
    password = json['password'];
    randomKey = json['random_key'];
    gender = json['gender'];
    userType = json['user_type'];
    locale = json['locale'];
    hometown = json['hometown'];
    token = json['token'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isInterests = json['is_interests'];
    status = json['status'];
    socialType = json['social_type'];
    bio = json['bio'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    linkdin = json['linkdin'];
    website = json['website'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['full_name'];
    iV = json['__v'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    community = json['community'] != null ? new Community.fromJson(json['community']) : null;
    socketId = json['socket_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['social_id'] = this.socialId;
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['profile_image'] = this.profileImage;
    data['password'] = this.password;
    data['random_key'] = this.randomKey;
    data['gender'] = this.gender;
    data['user_type'] = this.userType;
    data['locale'] = this.locale;
    data['hometown'] = this.hometown;
    data['token'] = this.token;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['is_interests'] = this.isInterests;
    data['status'] = this.status;
    data['social_type'] = this.socialType;
    data['bio'] = this.bio;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['linkdin'] = this.linkdin;
    data['website'] = this.website;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['__v'] = this.iV;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    if (this.community != null) {
      data['community'] = this.community!.toJson();
    }
    data['socket_id'] = this.socketId;
    data['id'] = this.id;
    return data;
  }
}

class Community {
  String? sId;
  String? title;

  Community({this.sId, this.title});

  Community.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}

class Metadata {
  Metadata();
Metadata.fromJson(
Map<String, dynamic> json
);

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}}
