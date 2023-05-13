import 'package:get/get.dart';

import 'controllers/address_controller.dart';
import 'models/address_model.dart';
import 'respositories/address_respository.dart';

class AddressModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
    Get.lazyPut<AddressModel>(() => AddressModel());
    Get.lazyPut<AddressRepository>(() => AddressRepository());
  }
}
