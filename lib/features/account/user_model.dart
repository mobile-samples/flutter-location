class UserInfo {
  String? id;
  String? username;
  String? email;
  String? occupation;
  String? company;
  String? bio;
  String? givenname;
  String? familyname;
  String? website;
  String? location;
  List<String>? interests;
  List<String>? lookingFor;
  List<Skills>? skills;
  List<Achievements>? achievements;
  List<Companies>? companies;
  List<Educations>? educations;
  List<Works>? works;
  List<Gallery>? gallery;
  String? imageURL;
  String? coverURL;

  UserInfo(
      {this.id,
      this.username,
      this.email,
      this.occupation,
      this.company,
      this.bio,
      this.givenname,
      this.familyname,
      this.website,
      this.location,
      this.interests,
      this.lookingFor,
      this.skills,
      this.achievements,
      this.companies,
      this.educations,
      this.works,
      this.gallery,
      this.imageURL,
      this.coverURL});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    occupation = json['occupation'];
    company = json['company'];
    bio = json['bio'];
    givenname = json['givenname'] ?? '';
    familyname = json['familyname'] ?? '';
    website = json['website'] ?? '';
    location = json['location'] ?? '';
    interests = json['interests'] == null
        ? ['']
        : List<String>.from(json['interests']?.map((x) => x.toString()));
    lookingFor = json['lookingFor'] == null
        ? ['']
        : List<String>.from(json['lookingFor']?.map((x) => x.toString()));
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(Skills.fromJson(v));
      });
    } else {
      skills = [];
    }
    if (json['achievements'] != null) {
      achievements = <Achievements>[];
      json['achievements'].forEach((v) {
        achievements!.add(Achievements.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(Companies.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = <Educations>[];
      json['educations'].forEach((v) {
        educations!.add(Educations.fromJson(v));
      });
    }
    if (json['works'] != null) {
      works = <Works>[];
      json['works'].forEach((v) {
        works!.add(Works.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
    imageURL = json['imageURL'];
    coverURL = json['coverURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['occupation'] = occupation;
    data['company'] = company;
    data['bio'] = bio;
    data['givenname'] = givenname;
    data['familyname'] = familyname;
    data['website'] = website;
    data['location'] = location;
    data['interests'] = interests;
    data['lookingFor'] = lookingFor;
    if (skills != null) {
      data['skills'] = skills!.map((v) => v.toJson()).toList();
    }
    if (achievements != null) {
      data['achievements'] = achievements!.map((v) => v.toJson()).toList();
    }
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    if (educations != null) {
      data['educations'] = educations!.map((v) => v.toJson()).toList();
    }
    if (works != null) {
      data['works'] = works!.map((v) => v.toJson()).toList();
    }
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    data['imageURL'] = imageURL;
    data['coverURL'] = coverURL;
    return data;
  }
}

class Skills {
  String? skill;

  Skills({this.skill});

  Skills.fromJson(Map<String, dynamic> json) {
    skill = json['skill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skill'] = skill;
    return data;
  }
}

class Achievements {
  String? subject;
  String? description;

  Achievements({this.subject, this.description});

  Achievements.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['description'] = description;
    return data;
  }
}

class Companies {
  String? name;
  String? description;
  String? position;
  String? from;
  String? to;

  Companies({this.name, this.description, this.position, this.from, this.to});

  Companies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['position'] = position;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Works {
  String? name;
  String? description;
  String? position;
  String? from;
  String? to;

  Works({this.name, this.description, this.position, this.from, this.to});

  Works.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['position'] = position;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Educations {
  String? school;
  String? degree;
  String? major;
  String? from;
  String? to;
  String? title;

  Educations(
      {this.school, this.degree, this.major, this.from, this.to, this.title});

  Educations.fromJson(Map<String, dynamic> json) {
    school = json['school'];
    degree = json['degree'];
    major = json['major'];
    from = json['from'];
    to = json['to'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school'] = school;
    data['degree'] = degree;
    data['major'] = major;
    data['from'] = from;
    data['to'] = to;
    data['title'] = title;
    return data;
  }
}

class Gallery {
  String? type;
  String? url;

  Gallery({this.type, this.url});

  Gallery.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
