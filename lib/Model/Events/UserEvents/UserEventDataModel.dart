
class UserEventsDataModel {
  String? sId;
  String? title;
  UserId? userId;
  String? category;
  Country? country;
  String? state;
  String? city;
  var pincode;
  String? location;
  int? startDate;
  int? endDate;
  int? privacy;
  String? about;
  String? profileImage;
  String? coverImage;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? isLink;
  String? id;
  int? totalGoing;
  int? totalInterested;
  String? website;

  UserEventsDataModel(
      {this.sId,
      this.title,
      this.userId,
      this.category,
      this.country,
      this.state,
      this.city,
      this.pincode,
      this.location,
      this.startDate,
      this.endDate,
      this.privacy,
      this.about,
      this.profileImage,
      this.coverImage,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isLink,
      this.id,
      this.totalGoing,
      this.totalInterested,
      this.website});

  UserEventsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    category = json['category'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    location = json['location'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    privacy = json['privacy'];
    about = json['about'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isLink = json['is_link'];
    id = json['id'];
    totalGoing = json['total_going'];
    totalInterested = json['total_interested'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    data['category'] = this.category;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['location'] = this.location;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['privacy'] = this.privacy;
    data['about'] = this.about;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['is_link'] = this.isLink;
    data['id'] = this.id;
    data['total_going'] = this.totalGoing;
    data['total_interested'] = this.totalInterested;
    data['website'] = this.website;
    return data;
  }
}

class UserId {
  String? sId;
  String? profileImage;
  String? fullName;
  String? id;

  UserId({this.sId, this.profileImage, this.fullName, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    fullName = json['full_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
    return data;
  }
}

class Country {
  String? sId;
  String? title;

  Country({this.sId, this.title});

  Country.fromJson(Map<String, dynamic> json) {
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

class UserEventsMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  UserEventsMetadata(
      {this.limit, this.currentPage, this.totalDocs, this.totalPages});

  UserEventsMetadata.fromJson(Map<String, dynamic> json) {
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
