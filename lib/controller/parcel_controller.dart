
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appmartbduser/controller/location_controller.dart';
import 'package:appmartbduser/controller/order_controller.dart';
import 'package:appmartbduser/data/api/api_checker.dart';
import 'package:appmartbduser/data/model/response/address_model.dart';
import 'package:appmartbduser/data/model/response/parcel_category_model.dart';
import 'package:appmartbduser/data/model/response/place_details_model.dart';
import 'package:appmartbduser/data/model/response/zone_response_model.dart';
import 'package:appmartbduser/data/repository/parcel_repo.dart';
import 'package:appmartbduser/view/base/custom_snackbar.dart';

class ParcelController extends GetxController implements GetxService {
  final ParcelRepo parcelRepo;
  ParcelController({@required this.parcelRepo});

  List<ParcelCategoryModel> _parcelCategoryList;
  AddressModel _pickupAddress;
  AddressModel _destinationAddress;
  bool _isPickedUp = true;
  bool _isSender = true;
  bool _isLoading = false;
  double _distance = -1;
  List<String> _payerTypes = ['sender', 'receiver'];
  int _payerIndex = 0;
  int _paymentIndex = 0;

  List<ParcelCategoryModel> get parcelCategoryList => _parcelCategoryList;
  AddressModel get pickupAddress => _pickupAddress;
  AddressModel get destinationAddress => _destinationAddress;
  bool get isPickedUp => _isPickedUp;
  bool get isSender => _isSender;
  bool get isLoading => _isLoading;
  double get distance => _distance;
  int get payerIndex => _payerIndex;
  List<String> get payerTypes => _payerTypes;
  int get paymentIndex => _paymentIndex;

  Future<void> getParcelCategoryList() async {
    Response response = await parcelRepo.getParcelCategory();
    if(response.statusCode == 200) {
      _parcelCategoryList = [];
      response.body.forEach((parcel) => _parcelCategoryList.add(ParcelCategoryModel.fromJson(parcel)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setPickupAddress(AddressModel addressModel, bool notify) {
    _pickupAddress = addressModel;
    if(notify) {
      update();
    }
  }

  void setDestinationAddress(AddressModel addressModel) {
    _destinationAddress = addressModel;
    update();
  }

  void setLocationFromPlace(String placeID, String address, bool isPickedUp) async {
    Response response = await parcelRepo.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel _placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(_placeDetails.status == 'OK') {
        AddressModel _address = AddressModel(
          address: address, addressType: 'others', latitude: _placeDetails.result.geometry.location.lat.toString(),
          longitude: _placeDetails.result.geometry.location.lng.toString(),
          contactPersonName: Get.find<LocationController>().getUserAddress().contactPersonName,
          contactPersonNumber: Get.find<LocationController>().getUserAddress().contactPersonNumber,
        );
        ZoneResponseModel _response = await Get.find<LocationController>().getZone(_address.latitude, _address.longitude, false);
        if (_response.isSuccess) {
          bool _inZone = false;
          for(int zoneId in Get.find<LocationController>().getUserAddress().zoneIds) {
            if(_response.zoneIds.contains(zoneId)) {
              _inZone = true;
              break;
            }
          }
          if(_inZone) {
            _address.zoneId =  _response.zoneIds[0];
            _address.zoneIds = [];
            _address.zoneIds.addAll(_response.zoneIds);
            _address.zoneData = [];
            _address.zoneData.addAll(_response.zoneData);
            if(isPickedUp) {
              setPickupAddress(_address, true);
            }else {
              setDestinationAddress(_address);
            }
          }else {
            showCustomSnackBar('your_selected_location_is_from_different_zone_store'.tr);
          }
        } else {
          showCustomSnackBar(_response.message);
        }
      }
    }
  }

  void setIsPickedUp(bool isPickedUp, bool notify) {
    _isPickedUp = isPickedUp;
    if(notify) {
      update();
    }
  }

  void setIsSender(bool sender, bool notify) {
    _isSender = sender;
    if(notify) {
      update();
    }
  }

  void getDistance(AddressModel pickedUpAddress, AddressModel destinationAddress) async {
    _distance = -1;
    _distance = await Get.find<OrderController>().getDistanceInKM(
      LatLng(double.parse(pickedUpAddress.latitude), double.parse(pickedUpAddress.longitude)),
      LatLng(double.parse(destinationAddress.latitude), double.parse(destinationAddress.longitude)),
    );
    update();
  }

  void setPayerIndex(int index, bool notify) {
    _payerIndex = index;
    if(_payerIndex == 1) {
      _paymentIndex = 0;
    }
    if(notify) {
      update();
    }
  }

  void setPaymentIndex(int index, bool notify) {
    _paymentIndex = index;
    if(notify) {
      update();
    }
  }

  void startLoader(bool isEnable) {
    _isLoading = isEnable;
    update();
  }

}