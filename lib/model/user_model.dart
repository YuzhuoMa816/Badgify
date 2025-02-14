import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing user data.
class UserModel {
  // Keep those values final which you do not want to update
  String uid;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String? profilePicture;
  bool isEmailVerified;
  bool isPhoneVerified;
  String type;
  String? address;
  String? title;
  DateTime createdDate;
  DateTime lastUpdatedDate;
  bool isAgentOrManager;
  bool isServiceProvider;
  String googleUid;
  String facebookUid;
  String appleUid;
  String emailPasswordUid;
  String agentWorkingCompany;
  String serviceProviderOccupation;
  bool agreedPolicy;

  /// Constructor for UserModel.
  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.type,
    this.address,
    this.title,
    required this.createdDate,
    required this.lastUpdatedDate,
    required this.isAgentOrManager,
    required this.isServiceProvider,
    required this.appleUid,
    required this.googleUid,
    required this.facebookUid,
    required this.emailPasswordUid,
    required this.agentWorkingCompany,
    required this.serviceProviderOccupation,
    required this.agreedPolicy,

  });

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(
      uid: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      profilePicture: '',
      isEmailVerified: false,
      isPhoneVerified: false,
      type: '',
      address: '',
      title: '',
      createdDate: DateTime.now(),
      lastUpdatedDate: DateTime.now(),
      isAgentOrManager: false,
      isServiceProvider: false,
      appleUid: '',
      googleUid: '',
      facebookUid: '',
      emailPasswordUid: '', agentWorkingCompany: '', serviceProviderOccupation: '',
      agreedPolicy:false,
  );

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'UID': uid,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'IsEmailVerified': isEmailVerified,
      'IsPhoneVerified': isPhoneVerified,
      'Type': type,
      'Address': address,
      'Title': title,
      'CreatedDate': createdDate,
      'LastUpdatedDate': lastUpdatedDate,
      'IsServiceProvider': isServiceProvider,
      'IsAgentOrManager': isAgentOrManager,
      'AppleUid': appleUid,
      'GoogleUid': googleUid,
      'FacebookUid': facebookUid,
      'EmailPasswordUid': emailPasswordUid,
      'AgentWorkingCompany': agentWorkingCompany,
      'ServiceProviderOccupation': serviceProviderOccupation,
      'AgreedPolicy': agreedPolicy,
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          uid: document.id,
          firstName: data['FirstName'] ?? '',
          lastName: data['LastName'] ?? '',
          email: data['Email'] ?? '',
          phoneNumber: data['PhoneNumber'] ?? '',
          profilePicture: data['ProfilePicture'] ?? '',
          isEmailVerified: data['IsEmailVerified'] ?? false,
          isPhoneVerified: data['IsPhoneVerified'] ?? false,
          type: data['Type'] ?? '',
          address: data['Address'] ?? '',
          title: data['Title'] ?? '',
          createdDate: (data['CreatedDate'] as Timestamp).toDate(),
          lastUpdatedDate: (data['LastUpdatedDate'] as Timestamp).toDate(),
          isAgentOrManager: data['IsAgentOrManager'] ?? false,
          isServiceProvider: data['IsServiceProvider'] ?? false,
          appleUid: data['AppleUid'] ?? '',
          googleUid: data['GoogleUid'] ?? '',
          facebookUid: data['FacebookUid'] ?? '',
          emailPasswordUid: data['EmailPasswordUid'] ?? '',
        agentWorkingCompany: data['AgentWorkingCompany'] ?? '',
        serviceProviderOccupation: data['ServiceProviderOccupation'] ?? '',
          agreedPolicy:data['AgreedPolicy'] ?? false,
      );
    } else {
      return UserModel.empty();
    }
  }
}
