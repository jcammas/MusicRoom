const String spotifyClientId = "fd579d2f56a8427abc45ab0b695bc136";
const String spotifyRedirectUri = "music-room-app-login:/";
const String spotifyDiscoveryUrl =
    'https://accounts.spotify.com/.well-known/openid-configuration';
const List<String> spotifyScopes = [
  'user-read-private',
  'user-read-email',
  'playlist-read-private',
  'playlist-read-collaborative',
  'app-remote-control',
  'user-modify-playback-state',
  'playlist-modify-public',
  'user-read-currently-playing'
];
const int tracksLimitSpotifyAPI = 100;
const int playlistsLimitSpotifyAPI = 50;
