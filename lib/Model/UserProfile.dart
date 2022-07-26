class UserProfileData {
  String? socialId;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  int? dob;
  int? age;
  String? profileImage;
  String? password;
  String? randomKey;
  String? gender;
  String? userType;
  String? locale;
  String? hometown;
  String? token;
  String? deviceType;
  String? deviceToken;
  bool? isInterests;
  String? status;
  String? socialType;
  String? bio;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkdin;
  String? website;
  String? createdAt;
  String? updatedAt;
  String? fullName;
  int? iV;
  City? city;
  Country? country;
  State? state;
  String? community;
  String? socketId;
  String? id;
  int? totalFirends;
  int? totalFollowers;
  int? totalFollowings;
  int? isFriend;
  int? isReqSent;
  int? isReqReceived;
  int? isFollower;
  int? isFollowing;
  bool? isBlock;
  String? blockBy;
  List<Events>? events;
  List<Interests>? interests;
  List<Educations>? educations;
  List<Visits>? visits;
  List<Experiences>? experiences;
  UserProfileData(
      {this.socialId,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.age,
      this.profileImage,
      this.password,
      this.randomKey,
      this.gender,
      this.userType,
      this.locale,
      this.hometown,
      this.token,
      this.deviceType,
      this.deviceToken,
      this.isInterests,
      this.status,
      this.socialType,
      this.bio,
      this.facebook,
      this.instagram,
      this.twitter,
      this.linkdin,
      this.website,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.iV,
      this.city,
      this.country,
      this.state,
      this.community,
      this.socketId,
      this.id,
      this.totalFirends,
      this.totalFollowers,
      this.totalFollowings,
      this.isFriend,
      this.isReqSent,
      this.isReqReceived,
      this.isFollower,
      this.isFollowing,
      this.isBlock,
      this.blockBy,
      this.interests,
      this.educations,
      this.experiences});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    socialId = json['social_id'];
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dob = json['dob'];
    age = json['age'];
    profileImage = json['profile_image'];
    password = json['password'];
    randomKey = json['random_key'];
    gender = json['gender'];
    userType = json['user_type'];
    locale = json['locale'];
    hometown = json['hometown'];
    token = json['token'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isInterests = json['is_interests'];
    status = json['status'];
    socialType = json['social_type'];
    bio = json['bio'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    linkdin = json['linkdin'];
    website = json['website'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['full_name'];
    iV = json['__v'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    community = json['community'];
    socketId = json['socket_id'];
    id = json['id'];
    totalFirends = json['total_firends'];
    totalFollowers = json['total_followers'];
    totalFollowings = json['total_followings'];
    isFriend = json['is_friend'];
    isReqSent = json['is_req_sent'];
    isReqReceived = json['is_req_received'];
    isFollower = json['is_follower'];
    isFollowing = json['is_following'];
    isBlock = json['isBlock'];
    blockBy = json['blockBy'];

    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(new Experiences.fromJson(v));
      });
    }

    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }

    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }

    if (json['educations'] != null) {
      educations = <Educations>[];
      json['educations'].forEach((v) {
        educations!.add(new Educations.fromJson(v));
      });
    }
    if (json['visits'] != null) {
      visits = <Visits>[];
      json['visits'].forEach((v) {
        visits!.add(new Visits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['social_id'] = this.socialId;
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['profile_image'] = this.profileImage;
    data['password'] = this.password;
    data['random_key'] = this.randomKey;
    data['gender'] = this.gender;
    data['user_type'] = this.userType;
    data['locale'] = this.locale;
    data['hometown'] = this.hometown;
    data['token'] = this.token;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['is_interests'] = this.isInterests;
    data['status'] = this.status;
    data['social_type'] = this.socialType;
    data['bio'] = this.bio;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['linkdin'] = this.linkdin;
    data['website'] = this.website;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['__v'] = this.iV;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    data['community'] = this.community;
    data['socket_id'] = this.socketId;
    data['id'] = this.id;
    data['total_firends'] = this.totalFirends;
    data['total_followers'] = this.totalFollowers;
    data['total_followings'] = this.totalFollowings;
    data['is_friend'] = this.isFriend;
    data['is_req_sent'] = this.isReqSent;
    data['is_req_received'] = this.isReqReceived;
    data['is_follower'] = this.isFollower;
    data['is_following'] = this.isFollowing;
    data['isBlock'] = this.isBlock;
    data['blockBy'] = this.blockBy;

    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }

    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    if (this.visits != null) {
      data['visits'] = this.visits!.map((v) => v.toJson()).toList();
    }
    if (this.educations != null) {
      data['educations'] = this.educations!.map((v) => v.toJson()).toList();
    }

    if (this.experiences != null) {
      data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Visits {
  String? sId;
  String? userId;
  String? country;
  String? state;
  String? city;
  int? from;
  int? to;
  int? current;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? iso2;

  Visits(
      {this.sId,
      this.userId,
      this.country,
      this.state,
      this.city,
      this.from,
      this.to,
      this.current,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.iso2});

  Visits.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    from = json['from'];
    to = json['to'];
    current = json['current'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    iso2 = json['iso2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['from'] = this.from;
    data['to'] = this.to;
    data['current'] = this.current;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['iso2'] = this.iso2;
    return data;
  }
}

class City {
  String? sId;
  int? id;
  String? name;
  int? stateId;
  String? stateCode;
  String? stateName;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? latitude;
  String? longitude;
  String? wikiDataId;
  String? title;
  String? status;

  City(
      {this.sId,
      this.id,
      this.name,
      this.stateId,
      this.stateCode,
      this.stateName,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.latitude,
      this.longitude,
      this.wikiDataId,
      this.title,
      this.status});

  City.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    wikiDataId = json['wikiDataId'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['state_code'] = this.stateCode;
    data['state_name'] = this.stateName;
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['wikiDataId'] = this.wikiDataId;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}

class Country {
  String? sId;
  int? id;
  String? name;
  String? iso3;
  String? iso2;
  String? numericCode;
  String? phoneCode;
  String? capital;
  String? currency;
  String? currencyName;
  String? currencySymbol;
  String? tld;
  String? native;
  String? region;
  String? subregion;
  List<Timezones>? timezones;
  Translations? translations;
  String? latitude;
  String? longitude;
  String? emoji;
  String? emojiU;
  String? title;
  String? status;

  Country(
      {this.sId,
      this.id,
      this.name,
      this.iso3,
      this.iso2,
      this.numericCode,
      this.phoneCode,
      this.capital,
      this.currency,
      this.currencyName,
      this.currencySymbol,
      this.tld,
      this.native,
      this.region,
      this.subregion,
      this.timezones,
      this.translations,
      this.latitude,
      this.longitude,
      this.emoji,
      this.emojiU,
      this.title,
      this.status});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    numericCode = json['numeric_code'];
    phoneCode = json['phone_code'];
    capital = json['capital'];
    currency = json['currency'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    tld = json['tld'];
    native = json['native'];
    region = json['region'];
    subregion = json['subregion'];
    if (json['timezones'] != null) {
      timezones = <Timezones>[];
      json['timezones'].forEach((v) {
        timezones!.add(new Timezones.fromJson(v));
      });
    }
    translations = json['translations'] != null
        ? new Translations.fromJson(json['translations'])
        : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['numeric_code'] = this.numericCode;
    data['phone_code'] = this.phoneCode;
    data['capital'] = this.capital;
    data['currency'] = this.currency;
    data['currency_name'] = this.currencyName;
    data['currency_symbol'] = this.currencySymbol;
    data['tld'] = this.tld;
    data['native'] = this.native;
    data['region'] = this.region;
    data['subregion'] = this.subregion;
    if (this.timezones != null) {
      data['timezones'] = this.timezones!.map((v) => v.toJson()).toList();
    }
    if (this.translations != null) {
      data['translations'] = this.translations!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}

class Timezones {
  String? zoneName;
  int? gmtOffset;
  String? gmtOffsetName;
  String? abbreviation;
  String? tzName;

  Timezones(
      {this.zoneName,
      this.gmtOffset,
      this.gmtOffsetName,
      this.abbreviation,
      this.tzName});

  Timezones.fromJson(Map<String, dynamic> json) {
    zoneName = json['zoneName'];
    gmtOffset = json['gmtOffset'];
    gmtOffsetName = json['gmtOffsetName'];
    abbreviation = json['abbreviation'];
    tzName = json['tzName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zoneName'] = this.zoneName;
    data['gmtOffset'] = this.gmtOffset;
    data['gmtOffsetName'] = this.gmtOffsetName;
    data['abbreviation'] = this.abbreviation;
    data['tzName'] = this.tzName;
    return data;
  }
}

class Translations {
  String? kr;
  String? br;
  String? pt;
  String? nl;
  String? hr;
  String? fa;
  String? de;
  String? es;
  String? fr;
  String? ja;
  String? it;
  String? cn;

  Translations(
      {this.kr,
      this.br,
      this.pt,
      this.nl,
      this.hr,
      this.fa,
      this.de,
      this.es,
      this.fr,
      this.ja,
      this.it,
      this.cn});

  Translations.fromJson(Map<String, dynamic> json) {
    kr = json['kr'];
    br = json['br'];
    pt = json['pt'];
    nl = json['nl'];
    hr = json['hr'];
    fa = json['fa'];
    de = json['de'];
    es = json['es'];
    fr = json['fr'];
    ja = json['ja'];
    it = json['it'];
    cn = json['cn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kr'] = this.kr;
    data['br'] = this.br;
    data['pt'] = this.pt;
    data['nl'] = this.nl;
    data['hr'] = this.hr;
    data['fa'] = this.fa;
    data['de'] = this.de;
    data['es'] = this.es;
    data['fr'] = this.fr;
    data['ja'] = this.ja;
    data['it'] = this.it;
    data['cn'] = this.cn;
    return data;
  }
}

class State {
  String? sId;
  int? id;
  String? name;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? stateCode;
  Null? type;
  String? latitude;
  String? longitude;
  String? status;
  String? title;

  State(
      {this.sId,
      this.id,
      this.name,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.type,
      this.latitude,
      this.longitude,
      this.status,
      this.title});

  State.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    stateCode = json['state_code'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['state_code'] = this.stateCode;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['title'] = this.title;
    return data;
  }
}

class Events {
  String? sId;
  String? title;
  String? userId;
  String? category;
  String? country;
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
  String? updatedAt;
  int? iV;
  String? website;
  int? isLink;
  String? id;

  Events(
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
      this.website,
      this.isLink,
      this.id});

  Events.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId = json['user_id'];
    category = json['category'];
    country = json['country'];
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
    website = json['website'];
    isLink = json['is_link'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['category'] = this.category;
    data['country'] = this.country;
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
    data['website'] = this.website;
    data['is_link'] = this.isLink;
    data['id'] = this.id;
    return data;
  }
}

class Interests {
  String? sId;
  String? userId;
  String? interestId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Interest? interest;

  Interests(
      {this.sId,
      this.userId,
      this.interestId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.interest});

  Interests.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    interest = json['interest'] != null
        ? new Interest.fromJson(json['interest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['interest_id'] = this.interestId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.interest != null) {
      data['interest'] = this.interest!.toJson();
    }
    return data;
  }
}

class Interest {
  String? sId;
  String? title;
  int? popularity;
  String? status;
  String? createdAt;
  int? iV;

  Interest(
      {this.sId,
      this.title,
      this.popularity,
      this.status,
      this.createdAt,
      this.iV});

  Interest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    popularity = json['popularity'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
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

class Educations {
  String? sId;
  String? userId;
  String? institution;
  String? degree;
  String? subject;
  String? description;
  int? from;
  int? to;
  int? current;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Educations(
      {this.sId,
      this.userId,
      this.institution,
      this.degree,
      this.subject,
      this.description,
      this.from,
      this.to,
      this.current,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Educations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    institution = json['institution'];
    degree = json['degree'];
    subject = json['subject'];
    description = json['description'];
    from = json['from'];
    to = json['to'];
    current = json['current'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['institution'] = this.institution;
    data['degree'] = this.degree;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['from'] = this.from;
    data['to'] = this.to;
    data['current'] = this.current;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Experiences {
  String? sId;
  String? userId;
  String? company;
  String? location;
  String? position;
  int? from;
  int? to;
  int? current;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Experiences(
      {this.sId,
      this.userId,
      this.company,
      this.location,
      this.position,
      this.from,
      this.to,
      this.current,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Experiences.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    company = json['company'];
    location = json['location'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
    current = json['current'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['company'] = this.company;
    data['location'] = this.location;
    data['position'] = this.position;
    data['from'] = this.from;
    data['to'] = this.to;
    data['current'] = this.current;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
