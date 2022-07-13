class FriendsDataModel {
  String? sId;
  String? userId;
  String? friendId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Friend? friend;
  int? isFriend;
  int? isReqSent;
  int? isReqReceived;

  FriendsDataModel(
      {this.sId,
      this.userId,
      this.friendId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.friend,
      this.isFriend,
      this.isReqSent,
      this.isReqReceived});

  FriendsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    friend =
        json['friend'] != null ? new Friend.fromJson(json['friend']) : null;
    isFriend = json['is_friend'];
    isReqSent = json['is_req_sent'];
    isReqReceived = json['is_req_received'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.friend != null) {
      data['friend'] = this.friend!.toJson();
    }
    data['is_friend'] = this.isFriend;
    data['is_req_sent'] = this.isReqSent;
    data['is_req_received'] = this.isReqReceived;
    return data;
  }
}

class Friend {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  List<Country>? country;
  List<State>? state;
  List<City>? city;

  Friend(
      {this.sId,
      this.profileImage,
      this.status,
      this.fullName,
      this.country,
      this.state,
      this.city});

  Friend.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
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
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state!.map((v) => v.toJson()).toList();
    }
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
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

class FriendsMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  FriendsMetadata(
      {this.limit, this.currentPage, this.totalDocs, this.totalPages});

  FriendsMetadata.fromJson(Map<String, dynamic> json) {
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
