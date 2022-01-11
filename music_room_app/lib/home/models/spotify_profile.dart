class SpotifyProfile {
  SpotifyProfile(
      {required this.displayName,
      required this.email,
      required this.id,
      this.country,
      this.explicitContent,
      this.externalUrls,
      this.followers,
      this.href,
      this.images,
      this.product,
      this.type,
      this.uri});

  String? country;
  final String displayName;
  final String email;
  Map<String, dynamic>? explicitContent;
  Map<String, dynamic>? externalUrls;
  Map<String, dynamic>? followers;
  String? href;
  final String id;
  List<dynamic>? images;
  String? product;
  String? type;
  String? uri;

  factory SpotifyProfile.fromMap(Map<String, dynamic>? data) {
    if (data != null) {
      String? country = data['country'];
      final String displayName = data['display_name'] ?? 'N/A';
      final String email = data['email'] ?? 'N/A';
      Map<String, dynamic>? explicitContent = data['explicit_content'];
      Map<String, dynamic>? externalUrls = data['external_urls'];
      Map<String, dynamic>? followers = data['followers'];
      String? href = data['href'];
      final String id = data['id'] ?? 'N/A';
      List<dynamic>? images = data['images'];
      String? product = data['product'];
      String? type = data['type'];
      String? uri = data['uri'];
      return SpotifyProfile(
        country: country,
        displayName: displayName,
        email: email,
        explicitContent: explicitContent,
        externalUrls: externalUrls,
        followers: followers,
        href: href,
        id: id,
        images: images,
        product: product,
        type: type,
        uri: uri,
      );
    } else {
      return SpotifyProfile(id: "N/A", displayName: "N/A", email: "N/A");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'display_name': displayName,
      'email': email,
      'explicit_content': explicitContent,
      'external_urls': externalUrls,
      'followers': followers,
      'href': href,
      'id': id,
      'images': images,
      'product': product,
      'type': type,
      'uri': uri,
    };
  }
}
