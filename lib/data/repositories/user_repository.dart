import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_model.dart';
import '../../utils/exceptions/firebase_exceptions.dart';

/// Function to save user data to Firestore.
Future<void> saveUserRecord(UserModel user) async {
  try {
    /// Repository class for user-related operations.
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Users").doc(user.uid).set(user.toJson());
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

/// Function to fetch user details based on user ID.
Future<UserModel> fetchUserDetails(String uid) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final documentSnapshot = await db.collection("Users").doc(uid).get();
    if (documentSnapshot.exists) {
      return UserModel.fromSnapshot(documentSnapshot);
    } else {
      return UserModel.empty();
    }
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

/// Function to update user data in Firestore.
Future<void> updateUserDetails(UserModel updatedUser) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Users").doc(updatedUser.uid).update(updatedUser.toJson());
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

/// Function to remove user data from Firestore.
Future<void> removeUserRecord(String userId) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Users").doc(userId).delete();
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

/// Function to fetch user details based on google ID.
Future<UserModel?> fetchUserDetailsByGoogleId(String googleUid) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final documentSnapshot = await db
        .collection("Users")
        .where("GoogleUid", isEqualTo: googleUid)
        .limit(1)
        .get();

    if (documentSnapshot.docs.isNotEmpty) {
      return UserModel.fromSnapshot(documentSnapshot.docs.first);
    } else {
      return null;
    }
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

/// Function to fetch user details based on google ID.
Future<UserModel?> fetchUserDetailsByPhone(String phoneNum) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final documentSnapshot = await db
        .collection("Users")
        .where("PhoneNumber", isEqualTo: phoneNum)
        .limit(1)
        .get();

    if (documentSnapshot.docs.isNotEmpty) {
      return UserModel.fromSnapshot(documentSnapshot.docs.first);
    } else {
      return null;
    }
  } on FirebaseException catch (e) {
    throw BFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}