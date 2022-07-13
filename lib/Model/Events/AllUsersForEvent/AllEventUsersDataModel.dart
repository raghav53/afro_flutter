

class AllEventUsersDataModel {
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
  String? createdAt;
  String? updatedAt;
  String? fullName;
  int? iV;
  List<City>? city;
  String? community;
  List<Country>? country;
  List<State>? state;
  List<UserEvents>? userEvents;
  int? mutualEventsCount;
  int? isFriend;
  int? isReqSent;
  int? isReqReceived;
  int? isFollower;
  int? isFollowing;
  int? isEventInviteSent;
  int? isGoing;
  int? isEventJoinReq;

  AllEventUsersDataModel(
      {this.sId,
      this.firstName,
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
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.iV,
      this.city,
      this.community,
      this.country,
      this.state,
      this.userEvents,
      this.mutualEventsCount,
      this.isFriend,
      this.isReqSent,
      this.isReqReceived,
      this.isFollower,
      this.isFollowing,
      this.isEventInviteSent,
      this.isGoing,
      this.isEventJoinReq});

  AllEventUsersDataModel.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['full_name'];
    iV = json['__v'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
    community = json['community'];
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(new Country.fromJson(v));
      });
    }
    if (json['state'] != null) {
      state = <State>[];
      json['state'].forEach((v) {
        state!.add(new State.fromJson(v));
      });
    }
    if (json['user_events'] != null) {
      userEvents = <UserEvents>[];
      json['user_events'].forEach((v) {
        userEvents!.add(new UserEvents.fromJson(v));
      });
    }
    mutualEventsCount = json['mutual_events_count'];
    isFriend = json['is_friend'];
    isReqSent = json['is_req_sent'];
    isReqReceived = json['is_req_received'];
    isFollower = json['is_follower'];
    isFollowing = json['is_following'];
    isEventInviteSent = json['is_event_invite_sent'];
    isGoing = json['is_going'];
    isEventJoinReq = json['is_event_join_req'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['__v'] = this.iV;
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
    data['community'] = this.community;
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state!.map((v) => v.toJson()).toList();
    }
    if (this.userEvents != null) {
      data['user_events'] = this.userEvents!.map((v) => v.toJson()).toList();
    }
    data['mutual_events_count'] = this.mutualEventsCount;
    data['is_friend'] = this.isFriend;
    data['is_req_sent'] = this.isReqSent;
    data['is_req_received'] = this.isReqReceived;
    data['is_follower'] = this.isFollower;
    data['is_following'] = this.isFollowing;
    data['is_event_invite_sent'] = this.isEventInviteSent;
    data['is_going'] = this.isGoing;
    data['is_event_join_req'] = this.isEventJoinReq;
    return data;
  }
}

class City {
  String? sId;
  String? title;

  City({this.sId, this.title});

  City.fromJson(Map<String, dynamic> json) {
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

class Country {
  String? sId;
  int? id;
  String? iso3;
  String? iso2;
  String? title;

  Country({this.sId, this.id, this.iso3, this.iso2, this.title});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['title'] = this.title;
    return data;
  }
}

class State {
  String? sId;
  int? id;
  String? title;

  State({this.sId, this.id, this.title});

  State.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class UserEvents {
  String? sId;
  String? eventId;
  String? userId;
  bool? isGoing;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserEvents(
      {this.sId,
      this.eventId,
      this.userId,
      this.isGoing,
      this.createdAt,
      this.updatedAt,
      this.iV});

  UserEvents.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    userId = json['user_id'];
    isGoing = json['is_going'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['event_id'] = this.eventId;
    data['user_id'] = this.userId;
    data['is_going'] = this.isGoing;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  double? totalPages;

  Metadata({this.limit, this.currentPage, this.totalDocs, this.totalPages});

  Metadata.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    currentPage = json['currentPage'];
    totalDocs = json['totalDocs'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['currentPage'] = this.currentPage;
    data['totalDocs'] = this.totalDocs;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
