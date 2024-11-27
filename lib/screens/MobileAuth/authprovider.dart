import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:movison/screens/MobileAuth/otp_screen.dart';
import 'package:movison/screens/MobileAuth/snackbar.dart';
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get the current user's ID
  String? getCurrentUserId() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      //await _firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(minutes: 2),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
             
            //  showSnackBar(context, phoneAuthCredential.toString());
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                verificationId: verificationId,
                PhoneNumber: phoneNumber,
              ),
              ),
            );
          },

          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
  required BuildContext context,
  required UserModel userModel,
  required File profilePic,
  required Function onSuccess,
  required File aadharFront,
  required File aadharBack,
  required File? panPic,
  required File collegeIdPicFront,
  required File collegeIdPicBack, 
}) async {
  _isLoading = true;
  notifyListeners();
  try {
    // Uploading profilePic to Firebase Storage
    await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
      userModel.profilePic = value;
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
    });

    // Uploading aadharPic to Firebase Storage
    await storeFileToStorage("aadharFront/$_uid", aadharFront).then((value) {
      userModel.aadharFront = value;
    });
    await storeFileToStorage("aadharBack/$_uid", aadharBack).then((value) {
      userModel.aadharBack = value;
    });

    // Uploading panPic to Firebase Storage
    if(panPic != null){
      await storeFileToStorage("panPic/$_uid", panPic).then((value) {
      userModel.panPic = value;
    });
    }

    // Uploading collegeIdPic to Firebase Storage
    await storeFileToStorage("collegeIdPicFront/$_uid", collegeIdPicFront).then((value) {
      userModel.collegeIdPicFront = value;
    });
    await storeFileToStorage("collegeIdPicBack/$_uid", collegeIdPicBack).then((value) {
      userModel.collegeIdPicBack = value;
    });

    _userModel = userModel;

    // Uploading user data to Firestore
    await _firebaseFirestore
        .collection("users")
        .doc(_uid)
        .set(userModel.toMap())
        .then((value) {
      onSuccess();
      _isLoading = false;
      notifyListeners();

    });
    await saveUserDataToSP();
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.message.toString());
    _isLoading = false;
    notifyListeners();
  }
}


  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        aadharFront: snapshot['aadharFront'],
        aadharBack: snapshot['aadharBack'],
        panPic: snapshot['panPic'],
        collegeIdPicFront: snapshot['collegeIdPicFront'],
        collegeIdPicBack: snapshot['collegeIdPicBack'],
        phoneNumber: snapshot['phoneNumber'],
        univercity: snapshot['univercity'] ,
        college: snapshot['college'],
      branch: snapshot['branch'],
      sem: snapshot['sem'],
      address: snapshot['address']
      );
      _uid = userModel.uid;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  // Assuming UserModel.fromMap method is implemented to convert Firestore data to UserModel object

  Future<void> updateProfile(
      BuildContext context, String name, String? email, File? profilePic,File? aadharBack,File? aadharFront,File? pan,File? collegeIdBack,File? collegeIdFront) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Ensure the user is authenticated
      User? currentUser1 = FirebaseAuth.instance.currentUser;
      if (currentUser1 == null) {
        throw Exception("User not authenticated.");
      }

      // Ensure the userModel is not null
      if (_userModel == null) {
        // If _userModel is null, fetch it from Firestore based on the current user's ID
        DocumentSnapshot userData = await _firebaseFirestore
            .collection("users")
            .doc(currentUser1.uid)
            .get();
        _userModel =
            UserModel.fromMap(userData.data()! as Map<String, dynamic>);
      }

      // Update name and bio in the userModel
      _userModel!.name = name;
      _userModel!.email=email!;
     

      // If a new profile picture is provided, upload it to Firebase Storage
      if (profilePic != null) {
        String imageUrl = await storeFileToStorage(
            "profilePic/${currentUser1.uid}", profilePic);
        _userModel!.profilePic = imageUrl;
      }
      if (aadharFront != null) {
        String imageUrl = await storeFileToStorage(
            "aadharFront/${currentUser1.uid}", aadharFront);
        _userModel!.aadharFront = imageUrl;
      }
      if (aadharBack != null) {
        String imageUrl = await storeFileToStorage(
            "aadharBack/${currentUser1.uid}", aadharBack);
        _userModel!.aadharBack = imageUrl;
      }
      if (pan != null) {
        String imageUrl = await storeFileToStorage(
            "panPic/${currentUser1.uid}", pan);
        _userModel!.panPic = imageUrl;
      }
      if (collegeIdFront != null) {
        String imageUrl = await storeFileToStorage(
            "collegeIdPicFront/${currentUser1.uid}", collegeIdFront);
        _userModel!.collegeIdPicFront = imageUrl;
      }
      if (collegeIdBack != null) {
        String imageUrl = await storeFileToStorage(
            "collegeIdPicBack/${currentUser1.uid}", collegeIdBack);
        _userModel!.collegeIdPicBack = imageUrl;
      }

      // Update user data in Firestore
      await _firebaseFirestore
          .collection("users")
          .doc(currentUser1.uid)
          .update(_userModel!.toMap());

        log("Update sucessfully");
        await saveUserDataToSP();

    } catch (e, stackTrace) {
      print("Error updating profile: $e");
      print(stackTrace);
      _isLoading = false;
      notifyListeners();
      // Handle error and show appropriate message to the user
      showSnackBar(context, "Failed to update profile: $e");
    }
  }
   Future<void> updateCollegeInfo(
      BuildContext context, String univercity,String branch,String sem,String college) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Ensure the user is authenticated
      User? currentUser1 = FirebaseAuth.instance.currentUser;
      if (currentUser1 == null) {
        throw Exception("User not authenticated.");
      }

      // Ensure the userModel is not null
      if (_userModel == null) {
        // If _userModel is null, fetch it from Firestore based on the current user's ID
        DocumentSnapshot userData = await _firebaseFirestore
            .collection("users")
            .doc(currentUser1.uid)
            .get();
        _userModel =
            UserModel.fromMap(userData.data()! as Map<String, dynamic>);
      }

      // Update name and bio in the userModel
      _userModel!.univercity=univercity;
      _userModel!.branch=branch;
      _userModel!.sem=sem;
      _userModel!.college=college;
     

      // If a new profile picture is provided, upload it to Firebase Storage
      
      // Update user data in Firestore
      await _firebaseFirestore
          .collection("users")
          .doc(currentUser1.uid)
          .update(_userModel!.toMap());

        log("Update sucessfully");
       await saveUserDataToSP();

    } catch (e, stackTrace) {
      print("Error updating profile: $e");
      print(stackTrace);
      _isLoading = false;
      notifyListeners();
      // Handle error and show appropriate message to the user
      showSnackBar(context, "Failed to update profile: $e");
    }
  }

 Future resendOtp({
    required String phoneNumber,
    required BuildContext context,
    required Function onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          onSuccess();
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      onFailed(e.message);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
