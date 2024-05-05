import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Badgify';
const APP_NAME_TAG_LINE = 'Badgify APP Tag line';

var defaultPrimaryColor = const Color.fromRGBO(53, 173, 225, 1.0);

const DEFAULT_LANGUAGE = 'en';

//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
  'mkv', 'mp4', // Video
  'mp3', // Audio
];

var acs = ActionCodeSettings(
  // URL you want to redirect back to. The domain (www.example.com) for this
  // URL must be whitelisted in the Firebase Console.
    url: 'https://www.example.com/finishSignUp?cartId=1234',
    // This must be true
    handleCodeInApp: true,
    androidPackageName: 'com.example.android',
    // installIfNotAvailable
    androidInstallApp: true,
    // minimumVersion
    androidMinimumVersion: '12');

