import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<Map<String, dynamic>?> getCurrentUserProfile();
}

class Spotify implements SpotifyService {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  String? refreshToken;
  String? accessToken;
  DateTime? expirationTime;

  Future<String?> _getOAuth2TokenPKCE() async {
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          spotifyClientId,
          spotifyRedirectUri,
          discoveryUrl: spotifyDiscoveryUrl,
          scopes: ['user-read-private', 'user-read-email'],
        ),
      );
      refreshToken = result?.refreshToken;
      expirationTime = result?.accessTokenExpirationDateTime;
      return (result?.accessToken);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final TokenResponse? result = await appAuth.token(TokenRequest(
          spotifyClientId, spotifyRedirectUri,
          discoveryUrl: spotifyDiscoveryUrl,
          refreshToken: refreshToken,
          scopes: ['user-read-private', 'user-read-email']));
      return (result?.accessToken);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      accessToken ??= await _getOAuth2TokenPKCE();
      accessToken = expirationTime != null
          ? expirationTime!.isBefore(DateTime.now())
              ? await _refreshAccessToken()
              : accessToken
          : null;
      if (accessToken == null) {
        throw Exception('Could not get access token to Spotify');
      } else {
        final Uri uri = Uri.https('api.spotify.com', 'v1/me');
        final response = await http.get(uri, headers: {
          'Authorization': 'Bearer ' + accessToken!,
        });
        return jsonDecode(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
