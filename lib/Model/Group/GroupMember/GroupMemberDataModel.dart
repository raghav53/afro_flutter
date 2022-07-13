class GroupMemberDataModel {
  String? sId;
  String? groupId;
  String? memberId;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Member? member;

  GroupMemberDataModel(
      {this.sId,
      this.groupId,
      this.memberId,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.member});

  GroupMemberDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupId = json['group_id'];
    memberId = json['member_id'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    member =
        json['member'] != null ? new Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['group_id'] = this.groupId;
    data['member_id'] = this.memberId;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    return data;
  }
}

class Member {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  List<City>? city;
  List<Country>? country;
  List<State>? state;
  int? isFriend;
  int? isReqSent;
  int? isReqReceived;
  int? isFollower;
  int? isFollowing;

  Member(
      {this.sId,
      this.profileImage,
      this.status,
      this.fullName,
      this.city,
      this.country,
      this.state,
      this.isFriend,
      this.isReqSent,
      this.isReqReceived,
      this.isFollower,
      this.isFollowing});

  Member.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
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
    isFriend = json['is_friend'];
    isReqSent = json['is_req_sent'];
    isReqReceived = json['is_req_received'];
    isFollower = json['is_follower'];
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state!.map((v) => v.toJson()).toList();
    }
    data['is_friend'] = this.isFriend;
    data['is_req_sent'] = this.isReqSent;
    data['is_req_received'] = this.isReqReceived;
    data['is_follower'] = this.isFollower;
    data['is_following'] = this.isFollowing;
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

class State {
  String? sId;
  String? title;

  State({this.sId, this.title});

  State.fromJson(Map<String, dynamic> json) {
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
  String? iso2;
  String? title;

  Country({this.sId, this.iso2, this.title});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    iso2 = json['iso2'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['iso2'] = this.iso2;
    data['title'] = this.title;
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
