import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String name;
  String email;
  String bio;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  String univercity;
  String branch;
  String sem;
  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.univercity,
    required this.branch,
    required this.sem
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      univercity: map['univercity'] ?? '',
      branch: map['branch']?? '',
      sem: map['sem']?? ''
    );
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get userId => _auth.currentUser?.uid;

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "bio": bio,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "univercity":univercity,
      "branch":branch,
      "sem":sem
    };
  }
}
