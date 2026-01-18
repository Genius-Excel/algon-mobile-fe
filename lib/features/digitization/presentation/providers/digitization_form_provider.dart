import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitizationFormData extends ChangeNotifier {
  static const String _prefsKey = 'digitization_form_data';

  // Step 1 data
  String? nin;
  String? email;
  String? phoneNumber;
  String? stateValue;
  String? localGovernment;
  String? fullName;
  String? ninSlipFilePath; // File path - not persisted
  String? profilePhotoFilePath; // File path - not persisted

  // Step 2 data
  String? certificateFilePath; // File path - not persisted
  String? certificateReferenceNumber;

  // Step 3 data
  String? paymentMethod;

  // Application ID after creation
  String? applicationId;
  
  // Fee information
  int? digitizationFee;

  DigitizationFormData() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null) {
        final Map<String, dynamic> data = json.decode(jsonString);
        nin = data['nin'];
        email = data['email'];
        phoneNumber = data['phoneNumber'];
        stateValue = data['stateValue'];
        localGovernment = data['localGovernment'];
        fullName = data['fullName'];
        certificateReferenceNumber = data['certificateReferenceNumber'];
        paymentMethod = data['paymentMethod'];
        applicationId = data['applicationId'];
        digitizationFee = data['digitizationFee'] != null ? data['digitizationFee'] as int : null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading digitization form data: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'nin': nin,
        'email': email,
        'phoneNumber': phoneNumber,
        'stateValue': stateValue,
        'localGovernment': localGovernment,
        'fullName': fullName,
        'certificateReferenceNumber': certificateReferenceNumber,
        'paymentMethod': paymentMethod,
        'applicationId': applicationId,
        'digitizationFee': digitizationFee,
      };
      await prefs.setString(_prefsKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving digitization form data: $e');
    }
  }

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
    _saveToPrefs();
  }

  void setStep2Data({
    String? certificateFilePath,
    String? certificateReferenceNumber,
  }) {
    if (certificateFilePath != null) this.certificateFilePath = certificateFilePath;
    if (certificateReferenceNumber != null) this.certificateReferenceNumber = certificateReferenceNumber;
    notifyListeners();
    _saveToPrefs();
  }

  void setApplicationId(String id) {
    applicationId = id;
    notifyListeners();
    _saveToPrefs();
  }

  void setDigitizationFee(int? fee) {
    digitizationFee = fee;
    notifyListeners();
    _saveToPrefs();
  }

  void reset() async {
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
    digitizationFee = null;
    notifyListeners();
    
    // Clear from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    } catch (e) {
      debugPrint('Error clearing digitization form data: $e');
    }
  }
}

final digitizationFormProvider = ChangeNotifierProvider<DigitizationFormData>((ref) {
  return DigitizationFormData();
});
