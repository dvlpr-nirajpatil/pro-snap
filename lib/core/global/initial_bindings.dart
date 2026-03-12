import 'package:prosnap/core/network/api_client.dart';
import 'package:get/instance_manager.dart';
import 'package:prosnap/core/services/location_service.dart';
import 'package:prosnap/features/auth/controllers/auth_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient());
    Get.put(AuthController());
    Get.lazyPut(() => LocationService(), fenix: true);
  }
}
