import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';

abstract class SpotifyService {
  Future<SpotifyProfile> getCurrentUserProfile();

  Future<List<Playlist>> getCurrentUserPlaylists();

  Future<List<Track>> getPlaylistTracks(String playlistId);
}

class Spotify implements SpotifyService {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? refreshToken;
  String? accessToken;
  DateTime? expirationTime;

  Future<void> _refreshWithSecuredStorage() async {
    try {
      accessToken = await secureStorage.read(key: 'accessToken');
      refreshToken = await secureStorage.read(key: 'refreshToken');
      String? expirationStr = await secureStorage.read(key: 'expirationTime');
      expirationTime =
          expirationStr == null ? null : DateTime.tryParse(expirationStr);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveWithSecuredStorage(
      {String? newAccessToken,
      String? newRefreshToken,
      DateTime? newExpirationTime}) async {
    try {
      if (newAccessToken != null) {
        await secureStorage.write(key: 'accessToken', value: newAccessToken);
        accessToken = newAccessToken;
      }
      if (newRefreshToken != null) {
        await secureStorage.write(key: 'refreshToken', value: newRefreshToken);
        refreshToken = newRefreshToken;
      }
      if (newExpirationTime != null) {
        await secureStorage.write(
            key: 'expirationTime', value: newExpirationTime.toString());
        expirationTime = newExpirationTime;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _getOAuth2TokenPKCE() async {
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          spotifyClientId,
          spotifyRedirectUri,
          discoveryUrl: spotifyDiscoveryUrl,
          scopes: spotifyScopes,
        ),
      );
      await _saveWithSecuredStorage(
          newAccessToken: result?.accessToken,
          newRefreshToken: result?.refreshToken,
          newExpirationTime: result?.accessTokenExpirationDateTime);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _refreshAccessToken() async {
    try {
      final TokenResponse? result = await appAuth.token(TokenRequest(
          spotifyClientId, spotifyRedirectUri,
          discoveryUrl: spotifyDiscoveryUrl,
          refreshToken: refreshToken,
          scopes: spotifyScopes));
      await _saveWithSecuredStorage(
          newAccessToken: result?.accessToken,
          newExpirationTime: result?.accessTokenExpirationDateTime);
    } on PlatformException catch (e) {
      if (e.code == 'token_failed') {
        try {
          await _getOAuth2TokenPKCE();
        } catch (e) {
          rethrow;
        }
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _refreshTokens() async {
    try {
      if (accessToken == null ||
          refreshToken == null ||
          expirationTime == null) {
        await _refreshWithSecuredStorage();
      }
      if (accessToken == null ||
          refreshToken == null ||
          expirationTime == null) {
        await _getOAuth2TokenPKCE();
      }
      if (accessToken == null ||
          refreshToken == null ||
          expirationTime == null) {
        throw Exception('Could not get access token to Spotify.');
      }
      if (expirationTime!
          .isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
        await _refreshAccessToken();
      }
      if (accessToken == null || expirationTime == null) {
        throw Exception('Could not get token to Spotify refreshed.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SpotifyProfile> getCurrentUserProfile() async {
    try {
      await _refreshTokens();
      final Uri uri = Uri.https('api.spotify.com', 'v1/me');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ' + accessToken!,
      });
      if (response.statusCode != 200) {
        String reason = response.reasonPhrase ?? 'No Error Message';
        throw HttpException('Could not get CurrentUser Profile : ' + reason);
      }
      Map<String, dynamic> profileMap = jsonDecode(response.body);
      return SpotifyProfile.fromMap(profileMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Playlist>> _getPlaylistsBatch({int offset = 0}) async {
    try {
      final Uri uri = Uri.https('api.spotify.com', 'v1/me/playlists',
          {'limit': playlistsLimitSpotifyAPI.toString(),
          'offset': offset.toString()});
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ' + accessToken!,
      });
      if (response.statusCode != 200) {
        String reason = response.reasonPhrase ?? 'No Error Message';
        throw HttpException('Could not get Playlists : ' + reason);
      }
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded['items'] == null) {
        throw Exception('Could not find playlists in API response');
      }
      final List<dynamic> playlistsList = decoded['items'];
      return playlistsList
          .whereType<Map<String, dynamic>>()
          .map((playlist) => playlist['id'] != null
          ? Playlist.fromMap(playlist, playlist['id'])
          : null)
          .whereType<Playlist>()
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Playlist>> getCurrentUserPlaylists() async {
    try {
      await _refreshTokens();
      List<Playlist> playlists = List.empty(growable:true);
      int offset = 0;
      int lastBatchSize = playlistsLimitSpotifyAPI;
      while(lastBatchSize == playlistsLimitSpotifyAPI) {
        List<Playlist> playlistBatch  = await _getPlaylistsBatch(offset: offset);
        playlists.addAll(playlistBatch);
        lastBatchSize = playlistBatch.length;
        offset += lastBatchSize;
      }
      return playlists;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Track>> _getTracksBatch(String playlistId, {int offset = 0}) async {
    try {
      final Uri uri = Uri.https(
          'api.spotify.com',
          'v1/playlists/' + playlistId + '/tracks',
          {'limit': tracksLimitSpotifyAPI.toString(), 'offset': offset.toString()});
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ' + accessToken!,
      });
      if (response.statusCode != 200) {
        String reason = response.reasonPhrase ?? 'No Error Message';
        throw HttpException(
            'Could not get tracks of playlist ' + playlistId + ' : ' + reason);
      }
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      List<dynamic> trackData = decoded['items'] ?? List.empty();
      return trackData
          .whereType<Map<String, dynamic>>()
          .map((track) => track['track'] != null
              ? track['track']['id'] != null
                  ? Track.fromMap(track['track'], track['track']['id'])
                  : null
              : null)
          .whereType<Track>()
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    try {
      await _refreshTokens();
      List<Track> trackList = List.empty(growable:true);
      int offset = 0;
      int lastBatchSize = tracksLimitSpotifyAPI;
      while(lastBatchSize == tracksLimitSpotifyAPI) {
        List<Track> trackBatch  = await _getTracksBatch(playlistId, offset: offset);
        lastBatchSize = trackBatch.length;
        trackList.addAll(trackBatch);
        offset += lastBatchSize;
      }
      return trackList;
    } catch (e) {
      rethrow;
    }
  }
}
