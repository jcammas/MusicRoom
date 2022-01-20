import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';

class MockAuth extends Mock implements AuthBase {}
class MockDatabase extends Mock implements Database {}
class MockUser extends Mock implements User {
  MockUser();
  factory MockUser.uid(String uid) {
    final user = MockUser();
    when(user.uid).thenReturn(uid);
    return user;
  }
}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
// class MockMaterialPageRoute extends Mock implements MaterialPageRoute {}
