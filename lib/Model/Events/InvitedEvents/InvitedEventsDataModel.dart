class InvitedEventsDataModel {
  String? sId;
  String? eventId;
  String? senderId;
  String? receiverId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Event? event;
  List<Sender>? sender;
  int? totalInterested;
  int? totalGoing;

  InvitedEventsDataModel(
      {this.sId,
      this.eventId,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.event,
      this.sender,
      this.totalInterested,
      this.totalGoing});

  InvitedEventsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    if (json['sender'] != null) {
      sender = <Sender>[];
      json['sender'].forEach((v) {
        sender!.add(new Sender.fromJson(v));
      });
    }
    totalInterested = json['total_interested'];
    totalGoing = json['total_going'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['event_id'] = this.eventId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.sender != null) {
      data['sender'] = this.sender!.map((v) => v.toJson()).toList();
    }
    data['total_interested'] = this.totalInterested;
    data['total_going'] = this.totalGoing;
    return data;
  }
}

class Event {
  String? sId;
  String? title;
  String? userId;
  String? category;
  List<Country>? country;
  String? state;
  String? city;
  Null? pincode;
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

  Event(
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
      this.isLink});

  Event.fromJson(Map<String, dynamic> json) {
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

class Sender {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;

  Sender({this.sId, this.profileImage, this.status, this.fullName});

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
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
