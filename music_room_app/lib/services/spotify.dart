import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<String?> getOAuth2TokenWithSecret();
  Future<String?> getOAuth2TokenPKCE();

}

class Spotify implements SpotifyService {
  final _charsState =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  String getRandomString(int length, String chars) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

  static final Random _rndSecure = Random.secure();

  String getCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _rndSecure.nextInt(256));

    return base64Url.encode(values);
  }

  String getSHA256(String input) =>
      sha256.convert(utf8.encode(input)).toString();

  String encodeBase64Url(String input) => base64Url.encode(utf8.encode(input));

  String decodeBase64Url(String input) => utf8.decode(base64Url.decode(input));

  @override
  Future<String?> getOAuth2TokenWithSecret() async {
    try {
      var scope = 'user-read-private user-read-email';
      var state = getRandomString(16, _charsState);
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
      String encoded = encodeBase64Url(credentials);

      final Uri uriGetToken = Uri.https('accounts.spotify.com', 'api/token');
      final response = await http.post(uriGetToken, body: {
        'redirect_uri': spotifyRedirectUri,
        'grant_type': 'authorization_code',
        'code': code,
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + encoded
      });

      final accessToken = jsonDecode(response.body)['access_token'] as String?;

      return accessToken;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getOAuth2TokenPKCE() async {
    try {
      FlutterAppAuth appAuth = FlutterAppAuth();
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          spotifyClientId,
          spotifyRedirectUri,
          discoveryUrl: 'https://accounts.spotify.com/.well-known/openid-configuration',
          scopes: ['user-read-private', 'user-read-email'],
        ),
      );
      return (result?.accessToken);

    } catch (e) {
      rethrow;
    }
  }
}
