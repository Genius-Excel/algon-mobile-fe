import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationFormData extends ChangeNotifier {
  // Step 1 data
  String? nin;
  String? fullName;
  String? dateOfBirth;
  String? stateValue;
  String? localGovernment;
  String? village;

  // Step 2 data
  String? email;
  String? phoneNumber;
  String? residentialAddress;
  String? landmark;
  String? letterFromTraditionalRulerPath; // File path

  // Step 3 data
  String? paymentMethod;
  int? applicationFee;
  int? verificationFee;

  // Application ID after creation
  String? applicationId;

  void setStep1Data({
    required String nin,
    required String fullName,
    required String dateOfBirth,
    required String stateValue,
    required String localGovernment,
    required String village,
  }) {
    this.nin = nin;
    this.fullName = fullName;
    this.dateOfBirth = dateOfBirth;
    this.stateValue = stateValue;
    this.localGovernment = localGovernment;
    this.village = village;
    notifyListeners();
  }

  void setStep2Data({
    required String email,
    required String phoneNumber,
    String? residentialAddress,
    String? landmark,
    String? letterFromTraditionalRulerPath,
  }) {
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.residentialAddress = residentialAddress;
    this.landmark = landmark;
    this.letterFromTraditionalRulerPath = letterFromTraditionalRulerPath;
    notifyListeners();
  }

  void setApplicationId(String id) {
    applicationId = id;
    notifyListeners();
  }

  void reset() {
    nin = null;
    fullName = null;
    dateOfBirth = null;
    stateValue = null;
    localGovernment = null;
    village = null;
    email = null;
    phoneNumber = null;
    residentialAddress = null;
    landmark = null;
    letterFromTraditionalRulerPath = null;
    paymentMethod = null;
    applicationId = null;
    applicationFee = null;
    verificationFee = null;
    notifyListeners();
  }
}

final applicationFormProvider = ChangeNotifierProvider<ApplicationFormData>((ref) {
  return ApplicationFormData();
});
