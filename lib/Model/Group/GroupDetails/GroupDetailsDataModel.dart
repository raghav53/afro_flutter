class GroupDetailsDataModel {
	String? sId;
	String? title;
	UserId? userId;
	Category? category;
	String? country;
	String? state;
	String? city;
	int? privacy;
	String? about;
	String? profileImage;
	String? coverImage;
	String? status;
	String? createdAt;
	String? updatedAt;
	int? iV;
	String? id;
	int? totalMembers;
	int? isMember;
	int? isJoinSent;
	int? isInviteRecieved;

	GroupDetailsDataModel({this.sId, this.title, this.userId, this.category, this.country, this.state, this.city, this.privacy, this.about, this.profileImage, this.coverImage, this.status, this.createdAt, this.updatedAt, this.iV, this.id, this.totalMembers, this.isMember, this.isJoinSent, this.isInviteRecieved});

	GroupDetailsDataModel.fromJson(Map<String, dynamic> json) {
		sId = json['_id'];
		title = json['title'];
		userId = json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
		category = json['category'] != null ? new Category.fromJson(json['category']) : null;
		country = json['country'];
		state = json['state'];
		city = json['city'];
		privacy = json['privacy'];
		about = json['about'];
		profileImage = json['profile_image'];
		coverImage = json['cover_image'];
		status = json['status'];
		createdAt = json['createdAt'];
		updatedAt = json['updatedAt'];
		iV = json['__v'];
		id = json['id'];
		totalMembers = json['total_members'];
		isMember = json['is_member'];
		isJoinSent = json['is_join_sent'];
		isInviteRecieved = json['is_invite_recieved'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = this.sId;
		data['title'] = this.title;
		if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
		if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
		data['country'] = this.country;
		data['state'] = this.state;
		data['city'] = this.city;
		data['privacy'] = this.privacy;
		data['about'] = this.about;
		data['profile_image'] = this.profileImage;
		data['cover_image'] = this.coverImage;
		data['status'] = this.status;
		data['createdAt'] = this.createdAt;
		data['updatedAt'] = this.updatedAt;
		data['__v'] = this.iV;
		data['id'] = this.id;
		data['total_members'] = this.totalMembers;
		data['is_member'] = this.isMember;
		data['is_join_sent'] = this.isJoinSent;
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

class Category {
	String? sId;
	String? title;

	Category({this.sId, this.title});

	Category.fromJson(Map<String, dynamic> json) {
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

class Metadata {
	Metadata();
	Metadata.fromJson(Map<String, dynamic> json) {}
	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}
