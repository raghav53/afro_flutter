class FollowingUserData {
  String? sId;
  String? userId;
  String? followerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  User? user;
  // MutualFriends? mutualFriends;

  FollowingUserData({
    this.sId,
    this.userId,
    this.followerId,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.user,
    //  this.mutualFriends
  });

  FollowingUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    followerId = json['follower_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    // mutualFriends = json['mutual_friends'] != null
    //     ? new MutualFriends.fromJson(json['mutual_friends'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['follower_id'] = this.followerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    // if (this.mutualFriends != null) {
    //   data['mutual_friends'] = this.mutualFriends!.toJson();
    // }
    return data;
  }
}

class User {
  String? sId;
  String? profileImage;
  String? fullName;
  List<City>? city;
  List<Country>? country;
  List<State>? state;

  User(
      {this.sId,
      this.profileImage,
      this.fullName,
      this.city,
      this.country,
      this.state});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
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
    return data;
  }
}

class City {
  String? sId;
  String? name;
  String? title;

  City({this.sId, this.name, this.title});

  City.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}

class Country {
  String? sId;
  String? name;
  String? title;

  Country({this.sId, this.name, this.title});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}

class State {
  String? sId;
  String? name;
  String? title;

  State({this.sId, this.name, this.title});

  State.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}

// class MutualFriends {
//   List<Null>? friends;

//   MutualFriends({this.friends});

//   MutualFriends.fromJson(Map<String, dynamic> json) {
//     if (json['friends'] != null) {
//       friends = <Null>[];
//       json['friends'].forEach((v) {
//         friends!.add(new Null.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.friends != null) {
//       data['friends'] = this.friends!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Metadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

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
