// lib/models/user_model.dart
class UserModel {
  final String? uid;
  final String? email;
  final String? name;

  UserModel({
    this.uid,
    this.email,
    this.name,
  });

  // Convert Firebase user to UserModel
  factory UserModel.fromFirebase(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
    );
  }

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
