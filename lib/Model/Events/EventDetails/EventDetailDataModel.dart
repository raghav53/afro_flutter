class EventDetailDataModel {
  String? sId;
  String? title;
  UserId? userId;
  Category? category;
  Country? country;
  String? state;
  String? city;
  var pincode;
  String? location;
  String? eventLink;
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
  String? website;
  int? isLink;
  String? id;
  int? totalGoing;
  int? totalInterested;
  int? isGoing;
  int? isInterested;
  int? isGoSent;
  int? isInviteRecieved;

  EventDetailDataModel(
      {this.sId,
      this.title,
      this.userId,
      this.category,
      this.country,
      this.state,
      this.city,
      this.pincode,
      this.location,
        this.eventLink,
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
        this.website,
        this.isLink,
      this.id,
      this.totalGoing,
      this.totalInterested,
      this.isGoing,
      this.isInterested,
      this.isGoSent,
      this.isInviteRecieved});

  EventDetailDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId =
        json['user_id'] != null ?  UserId.fromJson(json['user_id']) : null;
    category = json['country'] != null ?  Category.fromJson(json['country']) : null;
    country =
        json['country'] != null ?  Country.fromJson(json['country']) : null;
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    location = json['location'];
    eventLink = json['event_link'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    privacy = json['privacy'];
    about = json['about'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    status = json['status'];
    website = json['website'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isLink = json['is_link'];
    id = json['id'];
    totalGoing = json['total_going'];
    totalInterested = json['total_interested'];
    isGoing = json['is_going'];
    isInterested = json['is_interested'];
    isGoSent = json['is_go_sent'];
    isInviteRecieved = json['is_invite_recieved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['location'] = this.location;
    data['event_link'] = this.eventLink;
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
    data['website'] = this.website;
    data['is_link'] = this.isLink;
    data['id'] = this.id;
    data['total_going'] = this.totalGoing;
    data['total_interested'] = this.totalInterested;
    data['is_going'] = this.isGoing;
    data['is_interested'] = this.isInterested;
    data['is_go_sent'] = this.isGoSent;
    data['is_invite_recieved'] = this.isInviteRecieved;
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

class Country{
  String? sId;
  String? title;

  Country({this.sId, this.title});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}

class Category{
  String? sId;
  String? title;

  Category({this.sId, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}

class EventDetailDataModelMetadata {
  EventDetailDataModelMetadata();

  EventDetailDataModelMetadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    return data;
  }
}
