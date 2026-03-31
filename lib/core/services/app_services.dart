import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/location_service.dart';
import 'package:prosnap/core/services/socket_service.dart';

class AppServices {
  AppServices._();

  static final ApiClient apiClient = ApiClient();
  static final SocketService socketService = SocketService();
  static final LocationService locationService = LocationService();

  static Future<void> init() async {}
}
