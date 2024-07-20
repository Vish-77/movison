import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String name;
  String email;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  String univercity;
  String college;
  String branch;
  String sem;
  String aadharFront;
  String aadharBack;
  String? panPic;
  String collegeIdPicFront;
  String collegeIdPicBack;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.univercity,
    required this.college,
    required this.branch,
    required this.sem,
    required this.aadharFront,
    required this.aadharBack,
    this.panPic,
    required this.collegeIdPicFront,
    required this.collegeIdPicBack,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      univercity: map['univercity'] ?? '',
      college: map['college'] ?? '',
      branch: map['branch']?? '',
      sem: map['sem']?? '',
      aadharFront: map['aadharFront'] ?? '',
      aadharBack:map['aadharBack'] ?? '',
      panPic: map['panPic'] ?? '',
      collegeIdPicFront: map['collegeIdPicFront'] ?? '',
      collegeIdPicBack: map['collegeIdPicBack'] ?? '',
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
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "univercity":univercity,
      "college":college,
      "branch":branch,
      "sem":sem,
      "aadharFront":aadharFront,
      "aadharBack":aadharBack,
      "panPic":panPic,
      "collegeIdPicFront":collegeIdPicFront,
      "collegeIdPicBack":collegeIdPicBack
    };
  }
}
