class Character {
  Feature health;
  Feature active;
  Feature smart;
  Feature loud;
  Feature likesEating;
  Feature familyFriendly;
  Feature peaceful;
  Feature inteligence;
  Feature wellBehaved;
  Feature indipendent;
  Feature fearfull;

  Character(
      {this.active,
      this.health,
      this.smart,
      this.loud,
      this.likesEating,
      this.familyFriendly,
      this.peaceful,
      this.inteligence,
      this.wellBehaved,
      this.indipendent,
      this.fearfull});

  Character.fromJson(Map<String, dynamic> json) {
    health =
        json['health'] != null ? new Feature.fromJson(json['health']) : null;
    active =
        json['active'] != null ? new Feature.fromJson(json['active']) : null;
    smart = json['smart'] != null ? new Feature.fromJson(json['smart']) : null;
    loud = json['loud'] != null ? new Feature.fromJson(json['loud']) : null;
    likesEating = json['likesEating'] != null
        ? new Feature.fromJson(json['likesEating'])
        : null;
    familyFriendly = json['familyFriendly'] != null
        ? new Feature.fromJson(json['familyFriendly'])
        : null;
    peaceful = json['peaceful'] != null
        ? new Feature.fromJson(json['peaceful'])
        : null;
    inteligence = json['inteligence'] != null
        ? new Feature.fromJson(json['inteligence'])
        : null;
    wellBehaved = json['wellBehaved'] != null
        ? new Feature.fromJson(json['wellBehaved'])
        : null;
    indipendent = json['indipendent'] != null
        ? new Feature.fromJson(json['indipendent'])
        : null;
    fearfull = json['fearfull'] != null
        ? new Feature.fromJson(json['fearfull'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.health != null) {
      data['health'] = this.health.toJson();
    }
    if (this.active != null) {
      data['active'] = this.active.toJson();
    }
    if (this.smart != null) {
      data['smart'] = this.smart.toJson();
    }
    if (this.loud != null) {
      data['loud'] = this.loud.toJson();
    }
    if (this.likesEating != null) {
      data['likesEating'] = this.likesEating.toJson();
    }
    if (this.familyFriendly != null) {
      data['familyFriendly'] = this.familyFriendly.toJson();
    }
    if (this.peaceful != null) {
      data['peaceful'] = this.peaceful.toJson();
    }
    if (this.inteligence != null) {
      data['inteligence'] = this.inteligence.toJson();
    }
    if (this.wellBehaved != null) {
      data['wellBehaved'] = this.wellBehaved.toJson();
    }
    if (this.indipendent != null) {
      data['indipendent'] = this.indipendent.toJson();
    }
    if (this.fearfull != null) {
      data['fearfull'] = this.fearfull.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Character(active: $active, smart: $smart, loud: $loud, likesEating: $likesEating, familyFriendly: $familyFriendly, peaceful: $peaceful, inteligence: $inteligence, wellBehaved: $wellBehaved, indipendent: $indipendent, fearfull: $fearfull)';
  }
}

class Feature {
  double numberDecimal;

  Feature({this.numberDecimal});

  Feature.fromJson(Map<String, dynamic> json) {
    numberDecimal = double.parse(json[r'$numberDecimal']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[r'$numberDecimal'] = this.numberDecimal.toString();
    return data;
  }

  @override
  String toString() => 'Feature(numberDecimal: $numberDecimal)';
}
