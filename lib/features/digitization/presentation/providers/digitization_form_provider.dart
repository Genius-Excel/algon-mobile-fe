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

  // Step 2 data
  String? certificateFilePath;
  String? ninSlipFilePath;
  String? profilePhotoFilePath;
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
  }) {
    this.nin = nin;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.stateValue = stateValue;
    this.localGovernment = localGovernment;
    if (fullName != null) this.fullName = fullName;
    notifyListeners();
  }

  void setStep2Data({
    String? certificateFilePath,
    String? ninSlipFilePath,
    String? profilePhotoFilePath,
    String? certificateReferenceNumber,
  }) {
    if (certificateFilePath != null) this.certificateFilePath = certificateFilePath;
    if (ninSlipFilePath != null) this.ninSlipFilePath = ninSlipFilePath;
    if (profilePhotoFilePath != null) this.profilePhotoFilePath = profilePhotoFilePath;
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
    certificateFilePath = null;
    ninSlipFilePath = null;
    profilePhotoFilePath = null;
    certificateReferenceNumber = null;
    paymentMethod = null;
    applicationId = null;
    notifyListeners();
  }
}

final digitizationFormProvider = ChangeNotifierProvider<DigitizationFormData>((ref) {
  return DigitizationFormData();
});
