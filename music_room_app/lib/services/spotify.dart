import 'dart:convert';
import 'dart:math';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<String?> getOAuth2Token();
}

class Spotify implements SpotifyService {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Future<String?> getOAuth2Token() async {
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
      final Uri uriGetCode =
      Uri.https('accounts.spotify.com', 'authorize', queryParameters);
      final result = await FlutterWebAuth.authenticate(
        url: uriGetCode.toString(),
        callbackUrlScheme: spotifyCallbackUrlScheme,
      );
      if (state != Uri.parse(result).queryParameters['state']) {
        throw Exception(
            "Error : return \"state\" code different from request's. Rejected due to security concerns.");
      }
      final code = Uri.parse(result).queryParameters['code'];

      // String credentials = spotifyClientId + ':' + spotifyClientSecret;
      String credentials = spotifyClientId;
      String encoded = base64Url.encode(utf8.encode(credentials));
      String encoded64 = base64.encode(utf8.encode(credentials));
     // String decoded = utf8.decode(base64Url.decode(encoded));

      final Uri uriGetToken =
      Uri.https('accounts.spotify.com', 'api/token');
      final response = await http.post(uriGetToken, body: {
        'redirect_uri': spotifyRedirectUri,
        'grant_type': 'authorization_code',
        'code': code,
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + encoded
      });



      final accessToken = jsonDecode(response.body)['access_token'] as String?;

      return accessToken;

    } catch (e) {
      rethrow;
    }
  }
}
