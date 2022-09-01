class IndividualInboxs {
  List<MessagesList>? list;
  Metadata? metadata;

  IndividualInboxs({this.list, this.metadata});

  IndividualInboxs.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <MessagesList>[];
      json['list'].forEach((v) {
        list!.add(new MessagesList.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class MessagesList {
  String? sId;
  SenderId? senderId;
  SenderId? receiverId;
  MessageId? messageId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? blockBy;
  bool? isBlock;
  int? unreadCount;

  MessagesList(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.messageId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.blockBy,
      this.isBlock,
      this.unreadCount});

  MessagesList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'] != null
        ? new SenderId.fromJson(json['sender_id'])
        : null;
    receiverId = json['receiver_id'] != null
        ? new SenderId.fromJson(json['receiver_id'])
        : null;
    messageId = json['message_id'] != null
        ? new MessageId.fromJson(json['message_id'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    blockBy = json['blockBy'];
    isBlock = json['isBlock'];
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.senderId != null) {
      data['sender_id'] = this.senderId!.toJson();
    }
    if (this.receiverId != null) {
      data['receiver_id'] = this.receiverId!.toJson();
    }
    if (this.messageId != null) {
      data['message_id'] = this.messageId!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['blockBy'] = this.blockBy;
    data['isBlock'] = this.isBlock;
    data['unread_count'] = this.unreadCount;
    return data;
  }
}

class SenderId {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  String? id;

  SenderId({this.sId, this.profileImage, this.status, this.fullName, this.id});

  SenderId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
    return data;
  }
}

class MessageId {
  String? sId;
  String? senderId;
  String? receiverId;
  String? message;
  String? media;
  int? mediaType;
  bool? unread;
  int? type;
  bool? isBlock;
  String? blockBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageId(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.message,
      this.media,
      this.mediaType,
      this.unread,
      this.type,
      this.isBlock,
      this.blockBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MessageId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    media = json['media'];
    mediaType = json['media_type'];
    unread = json['unread'];
    type = json['type'];
    isBlock = json['isBlock'];
    blockBy = json['blockBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['media'] = this.media;
    data['media_type'] = this.mediaType;
    data['unread'] = this.unread;
    data['type'] = this.type;
    data['isBlock'] = this.isBlock;
    data['blockBy'] = this.blockBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  int? totalDocs;
  Null? totalPages;

  Metadata({this.totalDocs, this.totalPages});

  Metadata.fromJson(Map<String, dynamic> json) {
    totalDocs = json['totalDocs'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDocs'] = this.totalDocs;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
