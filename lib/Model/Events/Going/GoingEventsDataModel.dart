
class GoingEventUserData {
  String? sId;
  String? eventId;
  String? userId;
  bool? isGoing;
  String? createdAt;
  String? updatedAt;
  int? iV;
  EventDataModel? event;

  GoingEventUserData(
      {this.sId,
      this.eventId,
      this.userId,
      this.isGoing,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.event});

  GoingEventUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    userId = json['user_id'];
    isGoing = json['is_going'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    event = json['event'] != null
        ? new EventDataModel.fromJson(json['event'])
        : null;
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
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    return data;
  }
}

class EventDataModel {
  String? sId;
  String? title;
  String? userId;
  String? category;
  List<Country>? country;
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
  int? iV;
  int? isLink;
  int? totalGoing;
  int? totalInterested;
  String? website;

  EventDataModel(
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
      this.iV,
      this.isLink,
      this.totalGoing,
      this.totalInterested,
      this.website});

  EventDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId = json['user_id'];
    category = json['category'];
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(new Country.fromJson(v));
      });
    }
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
    iV = json['__v'];
    isLink = json['is_link'];
    totalGoing = json['total_going'];
    totalInterested = json['total_interested'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['category'] = this.category;
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
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
    data['__v'] = this.iV;
    data['is_link'] = this.isLink;
    data['total_going'] = this.totalGoing;
    data['total_interested'] = this.totalInterested;
    data['website'] = this.website;
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

class GoingEventMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  GoingEventMetadata({this.limit, this.currentPage, this.totalDocs, this.totalPages});

  GoingEventMetadata.fromJson(Map<String, dynamic> json) {
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
