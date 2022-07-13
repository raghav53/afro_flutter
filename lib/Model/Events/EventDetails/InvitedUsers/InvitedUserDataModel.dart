class InvitedUserDataModel {
  String? sId;
  String? eventId;
  String? senderId;
  String? receiverId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Receiver? receiver;

  InvitedUserDataModel(
      {this.sId,
      this.eventId,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.receiver});

  InvitedUserDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
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
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    return data;
  }
}

class Receiver {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;

  Receiver({this.sId, this.profileImage, this.status, this.fullName});

  Receiver.fromJson(Map<String, dynamic> json) {
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
