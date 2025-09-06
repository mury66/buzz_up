class UserModel {
  final String id;
  final String name;
  final String number;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.number,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'profilePicture': profilePicture,
    };
  }
}