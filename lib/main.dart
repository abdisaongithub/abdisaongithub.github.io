import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'network/api_client.dart';
import 'network/api_client_impl.dart';
import 'src/app.dart';
import 'util/SecureCredentials/secure_credential_storage.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  _setupApiClient();
  runApp(const App());
}

void _setupApiClient() {
  final apiClient = ApiClientImpl(Dio());
  GetIt.I.registerSingleton<ApiClient>(apiClient as ApiClient);
  // final credentialStorage = SecureCredentialsStorage(
  //   const FlutterSecureStorage(),
  // );
  // GetIt.I.registerSingleton<SecureCredentialsStorage>(credentialStorage);
}
