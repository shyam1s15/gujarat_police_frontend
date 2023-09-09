import 'package:get/get.dart';

import '../controllers/police_create_controller.dart';
class PoliceCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliceCreateController>(
      () => PoliceCreateController(),
    );
  }
}
