class DiscoverDataModel {
  String? sId;
  String? title;
  String? userId;
  String? category;
  Country? country;
  String? state;
  String? city;
  Null? pincode;
  String? location;
  String? eventLink;
  int? startDate;
  int? endDate;
  int? privacy;
  String? about;
  String? profileImage;
  String? coverImage;
  String? status;
  int? isOnline;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalGoing;
  int? totalInterested;
  int? isGoing;
  int? isInterested;
  int? isGoSent;
  int? isInviteRecieved;
  int? isLink;

  DiscoverDataModel(
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
      this.isOnline,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.totalGoing,
      this.totalInterested,
      this.isGoing,
      this.isInterested,
      this.isGoSent,
      this.isInviteRecieved,
      this.isLink});

  DiscoverDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId = json['user_id'];
    category = json['category'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
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
    isOnline = json['is_online'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalGoing = json['total_going'];
    totalInterested = json['total_interested'];
    isGoing = json['is_going'];
    isInterested = json['is_interested'];
    isGoSent = json['is_go_sent'];
    isInviteRecieved = json['is_invite_recieved'];
    isLink = json['is_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['category'] = this.category;
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
    data['is_online'] = this.isOnline;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['total_going'] = this.totalGoing;
    data['total_interested'] = this.totalInterested;
    data['is_going'] = this.isGoing;
    data['is_interested'] = this.isInterested;
    data['is_go_sent'] = this.isGoSent;
    data['is_invite_recieved'] = this.isInviteRecieved;
    data['is_link'] = this.isLink;
    return data;
  }
}

class Country {
  String? sId;
  String? iso3;
  String? iso2;
  String? title;

  Country({this.sId, this.iso3, this.iso2, this.title});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['title'] = this.title;
    return data;
  }
}

class DisCoverMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  DisCoverMetadata(
      {this.limit, this.currentPage, this.totalDocs, this.totalPages});

  DisCoverMetadata.fromJson(Map<String, dynamic> json) {
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
