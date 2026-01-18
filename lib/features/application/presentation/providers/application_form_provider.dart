import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationFormData extends ChangeNotifier {
  static const String _prefsKey = 'application_form_data';

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
  String? letterFromTraditionalRulerPath; // File path - not persisted

  // Step 3 data
  String? paymentMethod;
  int? applicationFee;
  int? verificationFee;

  // Application ID after creation
  String? applicationId;

  ApplicationFormData() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null) {
        final Map<String, dynamic> data = json.decode(jsonString);
        nin = data['nin'];
        fullName = data['fullName'];
        dateOfBirth = data['dateOfBirth'];
        stateValue = data['stateValue'];
        localGovernment = data['localGovernment'];
        village = data['village'];
        email = data['email'];
        phoneNumber = data['phoneNumber'];
        residentialAddress = data['residentialAddress'];
        landmark = data['landmark'];
        paymentMethod = data['paymentMethod'];
        applicationId = data['applicationId'];
        applicationFee = data['applicationFee'] != null ? data['applicationFee'] as int : null;
        verificationFee = data['verificationFee'] != null ? data['verificationFee'] as int : null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading application form data: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'nin': nin,
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'stateValue': stateValue,
        'localGovernment': localGovernment,
        'village': village,
        'email': email,
        'phoneNumber': phoneNumber,
        'residentialAddress': residentialAddress,
        'landmark': landmark,
        'paymentMethod': paymentMethod,
        'applicationId': applicationId,
        'applicationFee': applicationFee,
        'verificationFee': verificationFee,
      };
      await prefs.setString(_prefsKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving application form data: $e');
    }
  }

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
    _saveToPrefs();
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
    _saveToPrefs();
  }

  void setApplicationId(String id) {
    applicationId = id;
    notifyListeners();
    _saveToPrefs();
  }

  void setFees({int? applicationFee, int? verificationFee}) {
    this.applicationFee = applicationFee;
    this.verificationFee = verificationFee;
    notifyListeners();
    _saveToPrefs();
  }

  void reset() async {
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
    
    // Clear from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    } catch (e) {
      debugPrint('Error clearing application form data: $e');
    }
  }
}

final applicationFormProvider = ChangeNotifierProvider<ApplicationFormData>((ref) {
  return ApplicationFormData();
});
