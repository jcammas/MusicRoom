import 'package:flutter_test/flutter_test.dart';
import 'package:music_room_app/authentication/managers/login_manager.dart';
import 'mocks.dart';

void main() {
  late MockAuth mockAuth;
  late LoginManager manager;

  setUp(() {
    mockAuth = MockAuth();
    manager = LoginManager(auth: mockAuth);
  });

  test('updateEmail', () {
    var didNotifyListeners = false;
    manager.addListener(() => didNotifyListeners = true);
    const sampleEmail = 'email@email.com';
    manager.updateEmail(sampleEmail);
    expect(manager.email, sampleEmail);
    expect(didNotifyListeners, true);
  });
}