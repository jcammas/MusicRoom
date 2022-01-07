import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<String?> getAuthorizationCode();
}

class Spotify implements SpotifyService {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Future<String?> getAuthorizationCode() async {
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
      final Uri uri =
          Uri.https('accounts.spotify.com', 'authorize', queryParameters);
      final result = await FlutterWebAuth.authenticate(
        url: uri.toString(),
        callbackUrlScheme: spotifyCallbackUrlScheme,
      );
      if (state != Uri.parse(result).queryParameters['state']) {
        throw Exception(
            "Error : return \"state\" code different from request's. Rejected due to security concerns.");
      }
      return Uri.parse(result).queryParameters['code'];
    } catch (e) {
      rethrow;
    }
  }
}
