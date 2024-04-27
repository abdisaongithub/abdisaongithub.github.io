// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// import 'credential_storage.dart';
//
// class SecureCredentialsStorage extends CredentialsStorage {
//   // final FlutterSecureStorage _storage;
//
//   SecureCredentialsStorage(this._storage);
//
//   static const _key = "oauth_token";
//
//   String? _token;
//
//   @override
//   Future<String?> read() async {
//     if (_token != null) {
//       return _token;
//     }
//     final json = await _storage.read(key: _key);
//     if (json == null) {
//       return null;
//     }
//     _token = json;
//     return json;
//   }
//
//   @override
//   Future<void> save(String token) {
//     _token = token;
//     return _storage.write(key: _key, value: token);
//   }
//
//   @override
//   Future<void> clear() {
//     _token = null;
//     return _storage.delete(key: _key);
//   }
// }
