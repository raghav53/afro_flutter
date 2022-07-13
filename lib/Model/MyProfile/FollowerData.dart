class FollowerData {
  String? sId;
  String? userId;
  String? followerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Follower? follower;
  //MutualFriends? mutualFriends;
  int? isFollowing;

  FollowerData(
      {this.sId,
      this.userId,
      this.followerId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.follower,
      // this.mutualFriends,
      this.isFollowing});

  FollowerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    followerId = json['follower_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    follower = json['follower'] != null
        ? new Follower.fromJson(json['follower'])
        : null;
    // mutualFriends = json['mutual_friends'] != null
    //     ? new MutualFriends.fromJson(json['mutual_friends'])
    //   : null;
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['follower_id'] = this.followerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.follower != null) {
      data['follower'] = this.follower!.toJson();
    }
    // if (this.mutualFriends != null) {
    //   data['mutual_friends'] = this.mutualFriends!.toJson();
    // }
    data['is_following'] = this.isFollowing;
    return data;
  }
}

class Follower {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  List<City>? city;
  List<Country>? country;
  List<State>? state;

  Follower(
      {this.sId,
      this.profileImage,
      this.status,
      this.fullName,
      this.city,
      this.country,
      this.state});

  Follower.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

//City data
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

//City data
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

//City data
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

// //Mutual friends
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

//Metadata
class FollowerMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  double? totalPages;

  FollowerMetadata(
      {this.limit, this.currentPage, this.totalDocs, this.totalPages});

  FollowerMetadata.fromJson(Map<String, dynamic> json) {
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
