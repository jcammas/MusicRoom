import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<void> getCurrentUserId();
}

class Spotify implements SpotifyService {

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Future<void> getCurrentUserId() async {
    try {
      var scope = 'user-read-private user-read-email';
      var state = getRandomString(16);
      final queryParameters = {
        'response_type': 'code',
        'client_id': spotifyClientId,
        'scope': scope,
        'redirect_uri': spotifyRedirectUri,
        'state': state,
      };
      final uri =
      Uri.https('accounts.spotify.com', 'authorize', queryParameters);
      final result = await FlutterWebAuth.authenticate(
        url: uri.toString(),
        callbackUrlScheme: spotifyCallbackUrlScheme,
      );

// Extract token from resulting url
      final token = Uri.parse(result).queryParameters['token'];
      print('token');
      print(token);
    } catch (e) {
      print(e.toString());
    }
  }

}
