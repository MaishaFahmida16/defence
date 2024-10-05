import 'dart:convert';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get user => _auth.currentUser;

}