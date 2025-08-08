import 'package:flutter_dotenv/flutter_dotenv.dart';

final myApiKey = dotenv.env['API_KEY'] ?? 'default_key';
