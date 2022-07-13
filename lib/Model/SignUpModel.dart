class SignUpModel {
  bool? success;
  int? code;
  String? message;
  Data? data;
  Metadata? metadata;

  SignUpModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
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
  String? socketId;
  String? token;
  String? deviceType;
  String? deviceToken;
  bool? isInterests;
  String? status;
  String? socialType;
  String? socialId;
  String? bio;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkdin;
  String? website;
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? fullName;
  int? iV;
  String? id;

  Data(
      {this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.age,
      this.profileImage,
      this.password,
      this.randomKey,
      this.gender,
      this.userType,
      this.locale,
      this.hometown,
      this.socketId,
      this.token,
      this.deviceType,
      this.deviceToken,
      this.isInterests,
      this.status,
      this.socialType,
      this.socialId,
      this.bio,
      this.facebook,
      this.instagram,
      this.twitter,
      this.linkdin,
      this.website,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.iV,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
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
    socketId = json['socket_id'];
    token = json['token'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isInterests = json['is_interests'];
    status = json['status'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    bio = json['bio'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    linkdin = json['linkdin'];
    website = json['website'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['full_name'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['socket_id'] = this.socketId;
    data['token'] = this.token;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['is_interests'] = this.isInterests;
    data['status'] = this.status;
    data['social_type'] = this.socialType;
    data['social_id'] = this.socialId;
    data['bio'] = this.bio;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['linkdin'] = this.linkdin;
    data['website'] = this.website;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
