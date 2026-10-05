import 'dart:convert';

Map<String, dynamic> decodePayload(String token) {
  final parts = token.split('.');          // header, payload, signature
  // 1. take parts[1]
  // 2. base64Url.normalize(...) fixes missing '=' padding
  // 3. base64Url.decode(...) gives bytes
  // 4. utf8.decode(...) gives text
  // 5. jsonDecode(...) gives the Map
  final payload = parts[1];
  final normalizedPayload = base64Url.normalize(payload);
  final bytes = base64Url.decode(normalizedPayload);
  final text = utf8.decode(bytes);
  return jsonDecode(text);
}

bool isTokenExpired(String token) {
  final payload = decodePayload(token);
  final exp = payload['exp'] as int;
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds
  return currentTime >= exp;
}


String fakeToken(int expSeconds) {
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': expSeconds})))
      .replaceAll('=', '');   // JWTs leave the padding off
  return 'header.$payload.signature';   // header and signature aren't read
}
int nowSeconds() => DateTime.now().millisecondsSinceEpoch ~/ 1000;