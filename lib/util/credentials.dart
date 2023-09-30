import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials {
  static String? baseUrl = dotenv.env['REST_END_POINT'];
}
