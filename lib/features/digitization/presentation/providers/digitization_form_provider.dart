import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DigitizationFormData extends ChangeNotifier {
  // Step 1 data
  String? nin;
  String? email;
  String? phoneNumber;
  String? stateValue;
  String? localGovernment;
  String? fullName;
  String? ninSlipFilePath;
  String? profilePhotoFilePath;

  // Step 2 data
  String? certificateFilePath;
  String? certificateReferenceNumber;

  // Step 3 data
  String? paymentMethod;

  // Application ID after creation
  String? applicationId;

  void setStep1Data({
    required String nin,
    required String email,
    required String phoneNumber,
    required String stateValue,
    required String localGovernment,
    String? fullName,
    String? ninSlipFilePath,
    String? profilePhotoFilePath,
  }) {
    this.nin = nin;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.stateValue = stateValue;
    this.localGovernment = localGovernment;
    if (fullName != null) this.fullName = fullName;
    if (ninSlipFilePath != null) this.ninSlipFilePath = ninSlipFilePath;
    if (profilePhotoFilePath != null) this.profilePhotoFilePath = profilePhotoFilePath;
    notifyListeners();
  }

  void setStep2Data({
    String? certificateFilePath,
    String? certificateReferenceNumber,
  }) {
    if (certificateFilePath != null) this.certificateFilePath = certificateFilePath;
    if (certificateReferenceNumber != null) this.certificateReferenceNumber = certificateReferenceNumber;
    notifyListeners();
  }

  void setApplicationId(String id) {
    applicationId = id;
    notifyListeners();
  }

  void reset() {
    nin = null;
    email = null;
    phoneNumber = null;
    stateValue = null;
    localGovernment = null;
    fullName = null;
    ninSlipFilePath = null;
    profilePhotoFilePath = null;
    certificateFilePath = null;
    certificateReferenceNumber = null;
    paymentMethod = null;
    applicationId = null;
    notifyListeners();
  }
}

final digitizationFormProvider = ChangeNotifierProvider<DigitizationFormData>((ref) {
  return DigitizationFormData();
});
