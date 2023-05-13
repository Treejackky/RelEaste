import 'package:get/get.dart';
import '../models/address_model.dart';
import '../respositories/address_respository.dart';

class AddressController extends GetxController {
  late final AddressRepository _repository;
  late final AddressModel _model;

  AddressController() {
    _repository = AddressRepository();

    _model = AddressModel();
  }

  Future<void> loadAddress() async {
    final address = await _repository.getAddress();
    _model.address = address;
    update();
    print('Address: $address');
  }
}
