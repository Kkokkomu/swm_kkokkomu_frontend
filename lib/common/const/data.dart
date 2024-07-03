import 'package:flutter_dotenv/flutter_dotenv.dart';

const DEVICE_ID = 'DEVICE_ID';

final ip = dotenv.env['BASE_URL'] ?? '';
